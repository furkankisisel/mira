import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../domain/room_model.dart';
import '../domain/room_member_model.dart';
import '../domain/room_habit_model.dart';
import '../data/room_service.dart';

class RoomAnalyticsScreen extends StatefulWidget {
  const RoomAnalyticsScreen({super.key, required this.room});
  final Room room;

  @override
  State<RoomAnalyticsScreen> createState() => _RoomAnalyticsScreenState();
}

class _RoomAnalyticsScreenState extends State<RoomAnalyticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  bool _loading = true;
  List<RoomMember> _members = [];
  List<RoomHabit> _habits = [];
  List<RoomHabitSession> _todaySessions = [];
  List<RoomHabitSession> _weekSessions = [];
  List<RoomHabitSession> _monthSessions = [];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final weekStart = todayStart.subtract(Duration(days: now.weekday - 1));
    final monthStart = DateTime(now.year, now.month, 1);

    try {
      final membersStream = await RoomService.instance.streamMembers(widget.room.id).first;
      final habitsList = await RoomService.instance.getRoomHabits(widget.room.id);
      
      final mSess = await Future.wait([
        RoomService.instance.getRoomHabitSessions(widget.room.id, todayStart, now),
        RoomService.instance.getRoomHabitSessions(widget.room.id, weekStart, now),
        RoomService.instance.getRoomHabitSessions(widget.room.id, monthStart, now),
      ]);

      if (mounted) {
        setState(() {
          _members = membersStream;
          _habits = habitsList;
          _todaySessions = mSess[0];
          _weekSessions = mSess[1];
          _monthSessions = mSess[2];
        });
      }
    } catch (e) {
      debugPrint('Analytics load error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oda Analizi'),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Bugün'),
            Tab(text: 'Haftalık'),
            Tab(text: 'Aylık'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tab,
              children: [
                _AnalyticsTabView(
                  room: widget.room,
                  tabSessions: _todaySessions,
                  monthSessions: _monthSessions,
                  members: _members,
                  habits: _habits,
                  period: 'Bugün',
                ),
                _AnalyticsTabView(
                  room: widget.room,
                  tabSessions: _weekSessions,
                  monthSessions: _monthSessions,
                  members: _members,
                  habits: _habits,
                  period: 'Bu Hafta',
                ),
                _AnalyticsTabView(
                  room: widget.room,
                  tabSessions: _monthSessions,
                  monthSessions: _monthSessions,
                  members: _members,
                  habits: _habits,
                  period: 'Bu Ay',
                ),
              ],
            ),
    );
  }
}

class _AnalyticsTabView extends StatelessWidget {
  const _AnalyticsTabView({
    required this.room,
    required this.tabSessions,
    required this.monthSessions,
    required this.members,
    required this.habits,
    required this.period,
  });

  final Room room;
  final List<RoomHabitSession> tabSessions;
  final List<RoomHabitSession> monthSessions;
  final List<RoomMember> members;
  final List<RoomHabit> habits;
  final String period;

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) {
      return const Center(child: Text('Odada henüz alışkanlık yok.'));
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildRoomSummary(context)),
        SliverToBoxAdapter(child: _buildLeaderboard(context)),
        SliverToBoxAdapter(child: _buildHeatmap(context)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          sliver: SliverToBoxAdapter(
            child: Text('Bireysel Derin Analiz (Deep Dive)', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildMemberDeepDiveCard(context, members[index]),
            childCount: members.length,
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
      ],
    );
  }

  // 1. ODA ÖZETİ PANELİ
  Widget _buildRoomSummary(BuildContext context) {
    final theme = Theme.of(context);
    
    // Günün Yıldızı
    RoomMember? starMember;
    int maxVal = 0;
    final uidToVal = <String, int>{};
    for (var s in tabSessions) {
      uidToVal[s.uid] = (uidToVal[s.uid] ?? 0) + s.reportedValue;
    }
    uidToVal.forEach((uid, val) {
      if (val > maxVal) {
        maxVal = val;
        starMember = members.firstWhere((m) => m.uid == uid, orElse: () => RoomMember(uid: uid, displayName: 'Bilinmeyen', joinedAt: DateTime.now()));
      }
    });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Oda Özeti', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Card(
                  color: theme.colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const Icon(Icons.flash_on, color: Colors.orange, size: 28),
                        const SizedBox(height: 8),
                        const Text('Günün Yıldızı', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(starMember?.displayName ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('$maxVal Puan', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  color: theme.colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const Icon(Icons.local_fire_department, color: Colors.redAccent, size: 28),
                        const SizedBox(height: 8),
                        const Text('Aktif Etkileşim', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('${tabSessions.length} Seans', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text('Bu Dönem', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      )
    );
  }

  // 2. ÇOKLU LİDERLİK TABLOSU
  Widget _buildLeaderboard(BuildContext context) {
    final theme = Theme.of(context);
    
    // Top Contributor in this period
    final uidToTotal = <String, int>{};
    for (var s in tabSessions) {
      uidToTotal[s.uid] = (uidToTotal[s.uid] ?? 0) + s.reportedValue;
    }
    String topContributorUid = '';
    int maxContribution = -1;
    uidToTotal.forEach((k, v) {
      if (v > maxContribution) {
        maxContribution = v;
        topContributorUid = k;
      }
    });

    // Streak Champion (most distinct days logged in monthSessions)
    final uidToDays = <String, Set<String>>{};
    for (var s in monthSessions) {
      uidToDays.putIfAbsent(s.uid, () => <String>{});
      uidToDays[s.uid]!.add('${s.startTime.year}-${s.startTime.month}-${s.startTime.day}');
    }
    String streakChampUid = '';
    int maxStreak = -1;
    uidToDays.forEach((uid, days) {
      if (days.length > maxStreak) {
        maxStreak = days.length;
        streakChampUid = uid;
      }
    });

    // Last 24 Hours Active
    final active24h = <String>{};
    final yesterday = DateTime.now().subtract(const Duration(hours: 24));
    for (var s in monthSessions) {
      if (s.startTime.isAfter(yesterday)) {
        active24h.add(s.uid);
      }
    }

    RoomMember? contMember;
    if (topContributorUid.isNotEmpty) {
      contMember = members.firstWhere((m) => m.uid == topContributorUid, orElse: () => RoomMember(uid: '', displayName: 'Bilinmeyen', joinedAt: DateTime.now()));
    }
    
    RoomMember? streakMember;
    if (streakChampUid.isNotEmpty) {
      streakMember = members.firstWhere((m) => m.uid == streakChampUid, orElse: () => RoomMember(uid: '', displayName: 'Bilinmeyen', joinedAt: DateTime.now()));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Liderlik Tablosu', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          
          ListTile(
            tileColor: theme.colorScheme.surfaceContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.star, color: Colors.white)),
            title: const Text('En Çok Katkı Sağlayan', style: TextStyle(fontSize: 12, color: Colors.grey)),
            subtitle: Text(contMember?.displayName ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            trailing: Text(maxContribution > 0 ? '+$maxContribution' : '0', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 8),
          
          ListTile(
            tileColor: theme.colorScheme.surfaceContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const CircleAvatar(backgroundColor: Colors.blueAccent, child: Icon(Icons.timeline, color: Colors.white)),
            title: const Text('İstikrar Şampiyonu', style: TextStyle(fontSize: 12, color: Colors.grey)),
            subtitle: Text(streakMember?.displayName ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            trailing: Text(maxStreak > 0 ? '$maxStreak Gün' : '0 Gün', style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 16),
          
          Text('Son 24 Saatte Aktif', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (active24h.isEmpty) const Text('Henüz kimse aktif değil.', style: TextStyle(color: Colors.grey))
          else Wrap(
            spacing: 8,
            runSpacing: 8,
            children: active24h.take(10).map((uid) {
              final m = members.firstWhere((m) => m.uid == uid, orElse: () => RoomMember(uid: '', displayName: 'Bilinmeyen', joinedAt: DateTime.now()));
              return Chip(
                avatar: CircleAvatar(backgroundImage: m.avatarUrl != null ? NetworkImage(m.avatarUrl!) : null, child: m.avatarUrl == null ? Text(m.displayName.isNotEmpty ? m.displayName[0] : '?') : null),
                label: Text(m.displayName),
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                padding: EdgeInsets.zero,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // 3. KARŞILAŞTIRMALI ISI HARİTASI (Heatmap)
  Widget _buildHeatmap(BuildContext context) {
    if (members.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final now = DateTime.now();
    final dates = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));

    final uidToDateValue = <String, Map<String, int>>{};
    int globalMax = 0;

    for (var s in monthSessions) {
      final dStr = '${s.startTime.year}-${s.startTime.month}-${s.startTime.day}';
      uidToDateValue.putIfAbsent(s.uid, () => {});
      uidToDateValue[s.uid]![dStr] = (uidToDateValue[s.uid]![dStr] ?? 0) + s.reportedValue;
      if (uidToDateValue[s.uid]![dStr]! > globalMax) {
        globalMax = uidToDateValue[s.uid]![dStr]!;
      }
    }

    // Determine active members to display (only those with SOME session, or all room members)
    // To keep it clean, maybe just show all members.

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.grid_on, color: Colors.indigo),
              const SizedBox(width: 8),
              Text('Son 7 Günlük Isı Haritası', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Days Header (X-axis)
                  Row(
                    children: [
                      const SizedBox(width: 60), // Space for usernames
                      ...dates.map((d) => Expanded(
                        child: Center(
                          child: Text(
                            '${d.day}/${d.month}',
                            style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Heatmap Rows (Y-axis)
                  ...members.map((m) {
                    final dateValues = uidToDateValue[m.uid] ?? {};
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          // Username
                          SizedBox(
                            width: 60,
                            child: Text(
                              m.displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                          // Cells
                          ...dates.map((d) {
                            final dStr = '${d.year}-${d.month}-${d.day}';
                            final val = dateValues[dStr] ?? 0;
                            // Calculate color intensity (0.1 to 1.0) based on globalMax
                            double opacity = 0.1;
                            if (val > 0) {
                              opacity = 0.3 + (0.7 * (val / (globalMax == 0 ? 1 : globalMax)));
                              if (opacity > 1.0) opacity = 1.0;
                            }
                            
                            return Expanded(
                              child: Center(
                                child: Tooltip(
                                  message: '${m.displayName} - ${d.day}/${d.month}: $val Puan',
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: val > 0 ? Colors.green.withOpacity(opacity) : theme.colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // 4. BİREYSEL DERİN ANALİZ KARTLARI (Radar Grafiği & Nudge)
  Widget _buildMemberDeepDiveCard(BuildContext context, RoomMember member) {
    final theme = Theme.of(context);
    final memberSessions = monthSessions.where((s) => s.uid == member.uid).toList();

    // Calculate Radar Data
    final habitToVal = <String, int>{};
    for (var s in memberSessions) {
      habitToVal[s.habitId] = (habitToVal[s.habitId] ?? 0) + s.reportedValue;
    }

    double maxVal = 0;
    final radarEntries = <RadarEntry>[];
    final radarTitles = <String>[];
    
    for (var h in habits) {
      final val = (habitToVal[h.id] ?? 0).toDouble();
      if (val > maxVal) maxVal = val;
      radarEntries.add(RadarEntry(value: val));
      radarTitles.add(h.emoji ?? '📌');
    }

    // fl_chart: RadarChart requires at least 3 axes to draw the polygon.
    while (radarEntries.length < 3) {
      radarEntries.add(const RadarEntry(value: 0));
      radarTitles.add('...');
    }

    // Determine "Insights"
    String insight = "Henüz yeterli veri yok.";
    if (memberSessions.isNotEmpty) {
      // Find the most successful habit
      String topHabit = '';
      int topVal = -1;
      habitToVal.forEach((key, value) {
        if (value > topVal) {
          topVal = value;
          topHabit = habits.firstWhere((h) => h.id == key, orElse: () => habits.first).title;
        }
      });
      insight = "En çok '${topHabit}' görevine odaklanmış.";
    }

    return Card(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Header
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: member.avatarUrl != null ? NetworkImage(member.avatarUrl!) : null,
                  child: member.avatarUrl == null ? Text(member.displayName.isNotEmpty ? member.displayName[0] : '?', style: const TextStyle(fontSize: 24)) : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(member.displayName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(insight, style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
                    ],
                  ),
                ),
                // Nudge Button
                IconButton(
                  icon: const Icon(Icons.back_hand, color: Colors.orange),
                  tooltip: 'Dürt',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('👉 ${member.displayName} dürtüldü!')),
                    );
                  },
                ),
              ],
            ),
            const Divider(height: 32),
            
            // Radar Chart Area
            if (maxVal == 0)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('Odak dağılımı için yeterli veri yok.', style: TextStyle(color: Colors.grey)),
              )
            else
              SizedBox(
                height: 200,
                child: RadarChart(
                  RadarChartData(
                    radarShape: RadarShape.polygon,
                    tickCount: 3,
                    ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 10),
                    radarBorderData: const BorderSide(color: Colors.grey, width: 1.5),
                    gridBorderData: const BorderSide(color: Colors.grey, width: 0.5),
                    titlePositionPercentageOffset: 0.2,
                    getTitle: (index, angle) {
                      return RadarChartTitle(
                        text: radarTitles[index],
                        angle: angle,
                      );
                    },
                    dataSets: [
                      RadarDataSet(
                        dataEntries: radarEntries,
                        fillColor: theme.colorScheme.primary.withOpacity(0.3),
                        borderColor: theme.colorScheme.primary,
                        entryRadius: 3,
                      ),
                    ],
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 250),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


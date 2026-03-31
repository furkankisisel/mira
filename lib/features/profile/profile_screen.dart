import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../gamification/gamification_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'profile_repository.dart';
import 'dart:ui'; // for ImageFilter
import '../habit/domain/habit_repository.dart';
import '../habit/domain/habit_model.dart';
import '../habit/presentation/habit_analysis_screen.dart';
import '../social/presentation/social_hub_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    ProfileRepository.instance.initialize();
    ProfileRepository.instance.addListener(_onProfileChange);
    GamificationRepository.instance.initialize();
    GamificationRepository.instance.addListener(_onGamificationChange);
    HabitRepository.instance.initialize();
    HabitRepository.instance.addListener(_onHabitChange);
  }

  @override
  void dispose() {
    ProfileRepository.instance.removeListener(_onProfileChange);
    GamificationRepository.instance.removeListener(_onGamificationChange);
    HabitRepository.instance.removeListener(_onHabitChange);
    _nameCtrl.dispose();
    super.dispose();
  }

  void _onHabitChange() {
    if (mounted) setState(() {});
  }

  void _onProfileChange() {
    final repo = ProfileRepository.instance;
    if (_nameCtrl.text != repo.name) _nameCtrl.text = repo.name;
    if (mounted) setState(() {});
  }

  void _onGamificationChange() {
    if (mounted) setState(() {});
  }

  Future<void> _pickAvatar() async {
    try {
      final result = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 85,
      );
      if (result != null) {
        await ProfileRepository.instance.setAvatarPath(result.path);
      }
    } catch (_) {
      // ignore errors silently for now
    }
  }

  void _showEditProfileSheet() {
    final profile = ProfileRepository.instance;
    // prime controllers with latest values
    _nameCtrl.text = profile.name;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx);
        final insets = MediaQuery.of(ctx).viewInsets;
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + insets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: Theme.of(
                          ctx,
                        ).colorScheme.surfaceContainerHighest,
                        backgroundImage: (profile.avatarPath != null &&
                                profile.avatarPath!.isNotEmpty)
                            ? FileImage(io.File(profile.avatarPath!))
                            : (profile.avatarUrl != null &&
                                    profile.avatarUrl!.isNotEmpty)
                                ? NetworkImage(profile.avatarUrl!)
                                    as ImageProvider
                                : null,
                        child: (profile.avatarPath == null ||
                                    profile.avatarPath!.isEmpty) &&
                                (profile.avatarUrl == null ||
                                    profile.avatarUrl!.isEmpty)
                            ? const Icon(Icons.person, size: 28)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () async {
                            Navigator.of(ctx).pop();
                            await _pickAvatar();
                            _showEditProfileSheet();
                          },
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Theme.of(ctx).colorScheme.primary,
                            foregroundColor: Theme.of(
                              ctx,
                            ).colorScheme.onPrimary,
                            child: const Icon(Icons.edit, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameCtrl,
                          decoration: InputDecoration(
                            labelText: l10n.fullName,
                            hintText: l10n.enterYourName,
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () async {
                    // Capture navigator and messenger before awaits to avoid
                    // using BuildContext across async gaps.
                    final navigator = Navigator.of(ctx);
                    final messenger = ScaffoldMessenger.of(context);
                    await profile.setName(_nameCtrl.text.trim());
                    if (navigator.mounted) navigator.pop();
                    messenger.showSnackBar(
                      SnackBar(content: Text(l10n.profileUpdated)),
                    );
                  },
                  icon: const Icon(Icons.check),
                  label: Text(l10n.save),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBadgeDetails(BuildContext context, BadgeDef badge, bool unlocked) {
    final repo = GamificationRepository.instance;
    // Compute current value by metric
    int current;
    switch (badge.metric) {
      case BadgeMetric.totalHabitCompletions:
        current = repo.totalHabitCompletions;
        break;
      case BadgeMetric.activeDays:
        current = repo.activeDays;
        break;
      case BadgeMetric.totalTransactions:
        current = repo.totalTransactions;
        break;
      case BadgeMetric.totalVisions:
        current = repo.totalVisions;
        break;
      case BadgeMetric.level:
        current = repo.level;
        break;
      case BadgeMetric.xp:
        current = repo.xp;
        break;
    }
    final pct = (current / badge.goal).clamp(0.0, 1.0);
    showDialog(
      context: context,
      builder: (ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        final l10n = AppLocalizations.of(ctx);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: scheme.surface,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: unlocked
                      ? scheme.primaryContainer
                      : scheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  badge.icon,
                  color: unlocked ? scheme.primary : scheme.onSurfaceVariant,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(badge.title, style: const TextStyle(fontSize: 20)),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                badge.description,
                style: TextStyle(
                  fontSize: 16,
                  color: scheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 12,
                  backgroundColor: scheme.surfaceContainerHighest,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$current / ${badge.goal}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: scheme.primary,
                    ),
                  ),
                  Text(
                    '${(pct * 100).toInt()}%',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
              if (!unlocked) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 20,
                        color: scheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${l10n.howToEarn}: ${badge.description}',
                          style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.close, style: const TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = ProfileRepository.instance;
    final repo = GamificationRepository.instance;
    final scheme = Theme.of(context).colorScheme;

    if (_nameCtrl.text.isEmpty && profile.name.isNotEmpty) {
      _nameCtrl.text = profile.name;
    }

    // Achievements Data
    final badges = repo.allBadges(l10n);
    final unlocked = repo.unlockedBadges;
    final Map<String, List<BadgeDef>> groups = {};
    for (final b in badges) {
      groups.putIfAbsent(b.category, () => []).add(b);
    }

    // Stats for highlights
    final activeDays = repo.activeDays;
    final totalHabits = repo.totalHabitCompletions;
    final totalBadges = unlocked.length;

    return AnimationLimiter(
      child: CustomScrollView(
        slivers: [
          // 1. Immersive Header
          SliverToBoxAdapter(
            child: AnimationConfiguration.staggeredList(
              position: 0,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          scheme.primaryContainer.withValues(alpha: 0.6),
                          scheme.surface,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ), // Adjusted for safe area implies AppBar is present
                        GestureDetector(
                          onTap: _showEditProfileSheet,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        scheme.primary.withValues(alpha: 0.2),
                                    width: 4,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 56,
                                  backgroundColor:
                                      scheme.surfaceContainerHighest,
                                  backgroundImage: (profile.avatarPath !=
                                              null &&
                                          profile.avatarPath!.isNotEmpty)
                                      ? FileImage(io.File(profile.avatarPath!))
                                      : (profile.avatarUrl != null &&
                                              profile.avatarUrl!.isNotEmpty)
                                          ? NetworkImage(profile.avatarUrl!)
                                              as ImageProvider
                                          : null,
                                  child: (profile.avatarPath == null ||
                                              profile.avatarPath!.isEmpty) &&
                                          (profile.avatarUrl == null ||
                                              profile.avatarUrl!.isEmpty)
                                      ? Icon(
                                          Icons.person,
                                          size: 56,
                                          color: scheme.onSurfaceVariant,
                                        )
                                      : null,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: scheme.primary,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: scheme.primary
                                            .withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    l10n.levelShort(repo.level),
                                    style: TextStyle(
                                      color: scheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          (profile.name.isNotEmpty)
                              ? profile.name
                              : l10n.profile,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: scheme.primary.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${repo.xpIntoLevel} / ${repo.xpPerLevel} XP',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -0.5,
                                            color: scheme.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          l10n.levelLabel(repo.level),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: scheme.onSurfaceVariant
                                                .withValues(alpha: 0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: scheme.primary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${(repo.xpIntoLevel / repo.xpPerLevel * 100).toInt()}%',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: scheme.onPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: (repo.xpIntoLevel / repo.xpPerLevel)
                                        .clamp(0.0, 1.0),
                                    minHeight: 12,
                                    backgroundColor:
                                        scheme.surfaceContainerHighest,
                                    color: scheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.auto_awesome,
                                      size: 14,
                                      color: scheme.primary.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.xpToNextLevel(repo.xpToNextLevel),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: scheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ), // 2. Stats Highlights Row
          SliverToBoxAdapter(
            child: AnimationConfiguration.staggeredList(
              position: 1,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: scheme.outlineVariant.withValues(alpha: 0.4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            context,
                            activeDays.toString(),
                            l10n.statsActiveDays,
                            Icons.local_fire_department,
                            Colors.orange,
                          ),
                        ),
                        Container(
                            width: 1, height: 40, color: scheme.outlineVariant),
                        Expanded(
                          child: _buildStatItem(
                            context,
                            totalHabits.toString(),
                            l10n.habits,
                            Icons.check_circle,
                            Colors.green,
                          ),
                        ),
                        Container(
                            width: 1, height: 40, color: scheme.outlineVariant),
                        Expanded(
                          child: _buildStatItem(
                            context,
                            totalBadges.toString(),
                            l10n.achievements,
                            Icons.emoji_events,
                            Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // 2.4. Social Rooms Entry
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SocialHubScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: scheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Icon(Icons.groups, color: scheme.primary, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sosyal Odalar',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Arkadaşlarınla hedeflerini paylaş',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // 2.5. Streak Tracker (Habits 7-Day History)
          if (HabitRepository.instance.habits.isNotEmpty) ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.habits,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100, // Fixed height for streak cards row
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: HabitRepository.instance.habits.length,
                  itemBuilder: (context, index) {
                    final habit = HabitRepository.instance.habits[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _buildStreakCard(context, habit, scheme),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],

          // 3. Badges Grid
          for (final entry in groups.entries) ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.key,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.75, // More compact badges
                ),
                delegate: SliverChildBuilderDelegate((context, i) {
                  final b = entry.value[i];
                  final isUnlocked = unlocked.contains(b.id);
                  return AnimationConfiguration.staggeredGrid(
                    position: i,
                    columnCount: 3,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _buildBadgeCard(context, b, isUnlocked, scheme),
                      ),
                    ),
                  );
                }, childCount: entry.value.length),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStreakCard(
      BuildContext context, Habit habit, ColorScheme scheme) {
    // Determine last 7 days keys
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final List<bool> last7Days = [];

    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      bool completed = false;
      if (i == 0) {
        // Today => check immediate property
        completed = habit.isCompleted;
      } else {
        // Past day
        completed = HabitRepository.evaluateCompletionFromLog(habit, dateKey);
      }
      last7Days.add(completed);
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => HabitAnalysisScreen(
              habitTitle: habit.title,
              habitDescription: habit.description,
              habitIcon: habit.icon,
              habitColor: habit.color,
              currentStreak: habit.currentStreak,
              targetCount: habit.targetCount,
              unit: habit.unit,
              habitId: habit.id,
            ),
          ),
        );
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon & Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: habit.color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: habit.emoji != null && habit.emoji!.isNotEmpty
                      ? Text(habit.emoji!, style: const TextStyle(fontSize: 14))
                      : Icon(habit.icon, size: 14, color: habit.color),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    habit.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            // 7 Days Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: last7Days.map((isDone) {
                return Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color:
                        isDone ? habit.color : scheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeCard(
    BuildContext context,
    BadgeDef badge,
    bool isUnlocked,
    ColorScheme scheme,
  ) {
    final repo = GamificationRepository.instance;

    // Calculate progress for locked badges
    int current = 0;
    if (!isUnlocked) {
      switch (badge.metric) {
        case BadgeMetric.totalHabitCompletions:
          current = repo.totalHabitCompletions;
          break;
        case BadgeMetric.activeDays:
          current = repo.activeDays;
          break;
        case BadgeMetric.totalTransactions:
          current = repo.totalTransactions;
          break;
        case BadgeMetric.totalVisions:
          current = repo.totalVisions;
          break;
        case BadgeMetric.level:
          current = repo.level;
          break;
        case BadgeMetric.xp:
          current = repo.xp;
          break;
      }
    }
    final progress = (current / badge.goal).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () => _showBadgeDetails(context, badge, isUnlocked),
      child: Container(
        decoration: BoxDecoration(
          // Glassmorphism background
          gradient: isUnlocked
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scheme.primaryContainer.withValues(alpha: 0.8),
                    scheme.primaryContainer.withValues(alpha: 0.4),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scheme.surfaceContainerHighest.withValues(alpha: 0.6),
                    scheme.surfaceContainerHigh.withValues(alpha: 0.3),
                  ],
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked
                ? scheme.primary.withValues(alpha: 0.3)
                : scheme.outlineVariant.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Badge icon with gradient background
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: isUnlocked
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [scheme.primary, scheme.tertiary],
                          )
                        : null,
                    color: isUnlocked ? null : scheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                    boxShadow: isUnlocked
                        ? [
                            BoxShadow(
                              color: scheme.primary.withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: 0,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    badge.icon,
                    size: 22,
                    color: isUnlocked
                        ? Colors.white
                        : scheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 8),
                // Badge title
                Text(
                  badge.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.w500,
                    color: isUnlocked
                        ? scheme.onSurface
                        : scheme.onSurfaceVariant.withValues(alpha: 0.7),
                    height: 1.2,
                  ),
                ),
                // Progress indicator for locked badges
                if (!isUnlocked) ...[
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 3,
                        backgroundColor: scheme.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                        color: scheme.primary.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 9,
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../l10n/app_localizations.dart';
import '../../../design_system/theme/theme_variations.dart';

import '../data/mood_models.dart';
import '../data/detailed_mood_repository.dart';

class MoodAnalyticsScreen extends StatefulWidget {
  const MoodAnalyticsScreen({super.key, this.variant});
  final ThemeVariant? variant;

  @override
  State<MoodAnalyticsScreen> createState() => _MoodAnalyticsScreenState();
}

class _MoodAnalyticsScreenState extends State<MoodAnalyticsScreen>
    with TickerProviderStateMixin {
  final DetailedMoodRepository _repository = DetailedMoodRepository();

  late TabController _tabController;
  List<MoodEntry> _recentEntries = [];
  MoodStatistics? _statistics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final entries = await _repository.getAllMoodEntries();
      final stats = await _repository.getMoodStatistics();
      setState(() {
        _recentEntries = entries.take(20).toList();
        _statistics = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    // Apply exact same colors as mood_screen.dart
    final Color bgColor = theme.scaffoldBackgroundColor;
    final Color cardColor = theme.colorScheme.surface;
    final Color primaryColor = theme.colorScheme.primary;
    final Color textColor = theme.colorScheme.onSurface;
    final bool isDark = theme.brightness == Brightness.dark;
    final Color chipColor = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.05);

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: textColor),
          titleTextStyle: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Outfit',
          ),
          title: Text(l10n.moodAnalytics),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: primaryColor,
            labelColor: primaryColor,
            unselectedLabelColor: textColor.withOpacity(0.5),
            tabs: [
              Tab(text: l10n.overview),
              Tab(text: l10n.history),
            ],
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator(color: primaryColor))
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(theme, l10n, cardColor, chipColor,
                      primaryColor, textColor),
                  _buildHistoryTab(theme, l10n, cardColor, chipColor,
                      primaryColor, textColor),
                ],
              ),
      ),
    );
  }

  Widget _buildOverviewTab(ThemeData theme, AppLocalizations l10n,
      Color cardColor, Color chipColor, Color primaryColor, Color textColor) {
    if (_statistics == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mood, size: 64, color: textColor.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(l10n.noMoodData,
                style: theme.textTheme.titleMedium?.copyWith(color: textColor)),
            const SizedBox(height: 8),
            Text(
              l10n.startTrackingMood,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    title: l10n.totalEntries,
                    value: _statistics!.totalEntries.toString(),
                    icon: Icons.event_note,
                    color: Colors.blue,
                    chipColor: chipColor,
                    textColor: textColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    title: l10n.averageMood,
                    value: _statistics!.averageMoodScore.toStringAsFixed(1),
                    icon: Icons.trending_up,
                    color: _getMoodColor(_statistics!.averageMoodScore),
                    chipColor: chipColor,
                    textColor: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Mood Distribution
            Text(
              l10n.moodDistribution,
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
                height: 200,
                child: _buildMoodDistributionChart(theme, textColor)),
            const SizedBox(height: 32),

            // Top Categories
            Text(
              l10n.topCategories,
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildTopCategoriesCard(
                theme, l10n, chipColor, textColor, primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab(ThemeData theme, AppLocalizations l10n,
      Color cardColor, Color chipColor, Color primaryColor, Color textColor) {
    if (_recentEntries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: textColor.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(l10n.noHistory,
                style: theme.textTheme.titleMedium?.copyWith(color: textColor)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _recentEntries.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final entry = _recentEntries[index];
        return _buildHistoryCard(
            entry, theme, l10n, cardColor, chipColor, primaryColor, textColor);
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color chipColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMoodDistributionChart(ThemeData theme, Color textColor) {
    final l10n = AppLocalizations.of(context);
    if (_statistics == null || _statistics!.moodDistribution.isEmpty) {
      return Center(
          child: Text(l10n.noMoodData, style: TextStyle(color: textColor)));
    }

    final sections = _statistics!.moodDistribution.entries.map((entry) {
      final mood = entry.key;
      final count = entry.value;
      final percentage = (count / _statistics!.totalEntries) * 100;

      return PieChartSectionData(
        color: _getMoodColor(mood.index + 1.0),
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return PieChart(
      PieChartData(sections: sections, centerSpaceRadius: 40, sectionsSpace: 4),
    );
  }

  Widget _buildTopCategoriesCard(ThemeData theme, AppLocalizations l10n,
      Color chipColor, Color textColor, Color primaryColor) {
    if (_statistics == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryRow(
            l10n.mostCommonMood,
            _getMoodTitle(_statistics!.mostCommonMood, l10n),
            _getMoodIcon(_statistics!.mostCommonMood),
            _getMoodColor(_statistics!.mostCommonMood.index + 1.0),
            textColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: textColor.withOpacity(0.1), height: 1),
          ),
          _buildCategoryRow(
            l10n.mostCommonEmotion,
            _getSubEmotionTitle(_statistics!.mostCommonSubEmotion, l10n),
            _getSubEmotionIcon(_statistics!.mostCommonSubEmotion),
            primaryColor,
            textColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: textColor.withOpacity(0.1), height: 1),
          ),
          _buildCategoryRow(
            l10n.mostCommonReason,
            _getReasonTitle(_statistics!.mostCommonReason, l10n),
            _getReasonIcon(_statistics!.mostCommonReason),
            theme.colorScheme.secondary,
            textColor,
          ),
        ],
      ),
    );
  }

  void _showHistoryEntryActions(MoodEntry entry) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final Color accent = theme.colorScheme.primary;
        final themed = theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(primary: accent),
          appBarTheme: theme.appBarTheme.copyWith(foregroundColor: accent),
          iconTheme: theme.iconTheme.copyWith(color: accent),
        );

        return Theme(
          data: themed,
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text(l10n.delete),
            content: Text(l10n.deleteEntryConfirm),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showEditEntryDialog(entry);
                },
                child: Text(l10n.edit),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await _repository.deleteMoodEntry(entry.id);
                  await _loadData();
                },
                child: Text(
                  l10n.delete,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditEntryDialog(MoodEntry entry) {
    final l10n = AppLocalizations.of(context);
    final noteCtrl = TextEditingController(text: entry.journalText);
    var selectedMood = entry.mood;
    // var selectedSubEmotion = entry.subEmotions.firstOrNull;
    var selectedReason = entry.reason;

    showDialog<void>(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final Color accent = theme.colorScheme.primary;
        final themed = theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(primary: accent),
          appBarTheme: theme.appBarTheme.copyWith(foregroundColor: accent),
          iconTheme: theme.iconTheme.copyWith(color: accent),
        );

        return Theme(
          data: themed,
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text(l10n.edit),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<MoodLevel>(
                    initialValue: selectedMood,
                    decoration: InputDecoration(labelText: l10n.mood),
                    items: MoodLevel.values
                        .map(
                          (m) => DropdownMenuItem(
                            value: m,
                            child: Text(_getMoodTitle(m, l10n)),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) selectedMood = v;
                    },
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<ReasonCategory>(
                    initialValue: selectedReason,
                    decoration: InputDecoration(labelText: l10n.selectReason),
                    items: ReasonCategory.values
                        .map(
                          (r) => DropdownMenuItem(
                            value: r,
                            child: Text(_getReasonTitle(r, l10n)),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) selectedReason = v;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: noteCtrl,
                    decoration: InputDecoration(labelText: l10n.noteOptional),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () async {
                  final updated = MoodEntry(
                    id: entry.id,
                    mood: selectedMood,
                    subEmotions: entry.subEmotions, // Keep existing for now
                    reason: selectedReason,
                    journalText: noteCtrl.text.trim(),
                    timestamp: entry.timestamp,
                  );
                  await _repository.updateMoodEntry(updated);
                  if (mounted) {
                    Navigator.pop(ctx);
                    await _loadData();
                  }
                },
                child: Text(l10n.save),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryRow(
    String label,
    String value,
    IconData icon,
    Color color,
    Color textColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: textColor.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(
    MoodEntry entry,
    ThemeData theme,
    AppLocalizations l10n,
    Color cardColor,
    Color chipColor,
    Color primaryColor,
    Color textColor,
  ) {
    return InkWell(
      onLongPress: () => _showHistoryEntryActions(entry),
      borderRadius: BorderRadius.circular(32),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        _getMoodColor(entry.mood.index + 1.0).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getMoodIcon(entry.mood),
                    color: _getMoodColor(entry.mood.index + 1.0),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getMoodTitle(entry.mood, l10n),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDateTime(entry.timestamp),
                        style: TextStyle(
                          color: textColor.withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (entry.journalText.isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: chipColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  entry.journalText,
                  style: TextStyle(color: textColor, height: 1.4),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...entry.subEmotions.map(
                  (s) => _buildTag(
                      _getSubEmotionTitle(s, l10n), chipColor, textColor),
                ),
                _buildTag(
                    _getReasonTitle(entry.reason, l10n), chipColor, textColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color chipColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor.withOpacity(0.8),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Helper methods
  Color _getMoodColor(double moodScore) {
    if (moodScore <= 1.5) return Colors.red;
    if (moodScore <= 2.5) return Colors.orange;
    if (moodScore <= 3.5) return Colors.blue;
    if (moodScore <= 4.5) return Colors.green;
    return Colors.purple;
  }

  IconData _getMoodIcon(MoodLevel mood) {
    switch (mood) {
      case MoodLevel.terrible:
        return Icons.sentiment_very_dissatisfied;
      case MoodLevel.bad:
        return Icons.sentiment_dissatisfied;
      case MoodLevel.neutral:
        return Icons.sentiment_neutral;
      case MoodLevel.good:
        return Icons.sentiment_satisfied;
      case MoodLevel.excellent:
        return Icons.sentiment_very_satisfied;
    }
  }

  String _getMoodTitle(MoodLevel mood, AppLocalizations l10n) {
    switch (mood) {
      case MoodLevel.terrible:
        return l10n.moodTerrible;
      case MoodLevel.bad:
        return l10n.moodBad;
      case MoodLevel.neutral:
        return l10n.moodNeutral;
      case MoodLevel.good:
        return l10n.moodGood;
      case MoodLevel.excellent:
        return l10n.moodExcellent;
    }
  }

  IconData _getSubEmotionIcon(SubEmotion subEmotion) {
    // Same mapping as in other screens
    switch (subEmotion) {
      case SubEmotion.exhausted:
        return Icons.battery_0_bar;
      case SubEmotion.helpless:
        return Icons.help_outline;
      case SubEmotion.hopeless:
        return Icons.cloud_off;
      case SubEmotion.hurt:
        return Icons.favorite_border;
      case SubEmotion.drained:
        return Icons.water_drop_outlined;
      case SubEmotion.angry:
        return Icons.flash_on;
      case SubEmotion.sad:
        return Icons.sentiment_dissatisfied;
      case SubEmotion.anxious:
        return Icons.psychology;
      case SubEmotion.stressed:
        return Icons.speed;
      case SubEmotion.demoralized:
        return Icons.trending_down;
      case SubEmotion.indecisive:
        return Icons.shuffle;
      case SubEmotion.tired:
        return Icons.bedtime;
      case SubEmotion.ordinary:
        return Icons.remove;
      case SubEmotion.calm:
        return Icons.spa;
      case SubEmotion.empty:
        return Icons.crop_free;
      case SubEmotion.happy:
        return Icons.sentiment_satisfied;
      case SubEmotion.cheerful:
        return Icons.emoji_emotions;
      case SubEmotion.excited:
        return Icons.celebration;
      case SubEmotion.enthusiastic:
        return Icons.local_fire_department;
      case SubEmotion.determined:
        return Icons.flag;
      case SubEmotion.motivated:
        return Icons.trending_up;
      case SubEmotion.amazing:
        return Icons.auto_awesome;
      case SubEmotion.energetic:
        return Icons.bolt;
      case SubEmotion.peaceful:
        return Icons.self_improvement;
      case SubEmotion.grateful:
        return Icons.favorite;
      case SubEmotion.loving:
        return Icons.volunteer_activism;
      case SubEmotion.overwhelmed:
        return Icons.waves;
      case SubEmotion.lonely:
        return Icons.person_off;
      case SubEmotion.regretful:
        return Icons.undo;
      case SubEmotion.insecure:
        return Icons.lock_open;
      case SubEmotion.guilty:
        return Icons.gavel;
      case SubEmotion.bored:
        return Icons.hourglass_empty;
      case SubEmotion.numb:
        return Icons.ac_unit;
      case SubEmotion.confused:
        return Icons.psychology_alt;
      case SubEmotion.distracted:
        return Icons.notifications_off;
      case SubEmotion.proud:
        return Icons.verified;
      case SubEmotion.confident:
        return Icons.shield;
      case SubEmotion.hopeful:
        return Icons.wb_sunny;
      case SubEmotion.euphoric:
        return Icons.rocket_launch;
      case SubEmotion.blessed:
        return Icons.auto_awesome;
      case SubEmotion.unstoppable:
        return Icons.bolt;
    }
  }

  String _getSubEmotionTitle(SubEmotion subEmotion, AppLocalizations l10n) {
    switch (subEmotion) {
      case SubEmotion.exhausted:
        return l10n.subEmotionExhausted;
      case SubEmotion.helpless:
        return l10n.subEmotionHelpless;
      case SubEmotion.hopeless:
        return l10n.subEmotionHopeless;
      case SubEmotion.hurt:
        return l10n.subEmotionHurt;
      case SubEmotion.drained:
        return l10n.subEmotionDrained;
      case SubEmotion.angry:
        return l10n.subEmotionAngry;
      case SubEmotion.sad:
        return l10n.subEmotionSad;
      case SubEmotion.anxious:
        return l10n.subEmotionAnxious;
      case SubEmotion.stressed:
        return l10n.subEmotionStressed;
      case SubEmotion.demoralized:
        return l10n.subEmotionDemoralized;
      case SubEmotion.indecisive:
        return l10n.subEmotionIndecisive;
      case SubEmotion.tired:
        return l10n.subEmotionTired;
      case SubEmotion.ordinary:
        return l10n.subEmotionOrdinary;
      case SubEmotion.calm:
        return l10n.subEmotionCalm;
      case SubEmotion.empty:
        return l10n.subEmotionEmpty;
      case SubEmotion.happy:
        return l10n.subEmotionHappy;
      case SubEmotion.cheerful:
        return l10n.subEmotionCheerful;
      case SubEmotion.excited:
        return l10n.subEmotionExcited;
      case SubEmotion.enthusiastic:
        return l10n.subEmotionEnthusiastic;
      case SubEmotion.determined:
        return l10n.subEmotionDetermined;
      case SubEmotion.motivated:
        return l10n.subEmotionMotivated;
      case SubEmotion.amazing:
        return l10n.subEmotionAmazing;
      case SubEmotion.energetic:
        return l10n.subEmotionEnergetic;
      case SubEmotion.peaceful:
        return l10n.subEmotionPeaceful;
      case SubEmotion.grateful:
        return l10n.subEmotionGrateful;
      case SubEmotion.loving:
        return l10n.subEmotionLoving;
      case SubEmotion.overwhelmed:
        return l10n.subEmotionOverwhelmed;
      case SubEmotion.lonely:
        return l10n.subEmotionLonely;
      case SubEmotion.regretful:
        return l10n.subEmotionRegretful;
      case SubEmotion.insecure:
        return l10n.subEmotionInsecure;
      case SubEmotion.guilty:
        return l10n.subEmotionGuilty;
      case SubEmotion.bored:
        return l10n.subEmotionBored;
      case SubEmotion.numb:
        return l10n.subEmotionNumb;
      case SubEmotion.confused:
        return l10n.subEmotionConfused;
      case SubEmotion.distracted:
        return l10n.subEmotionDistracted;
      case SubEmotion.proud:
        return l10n.subEmotionProud;
      case SubEmotion.confident:
        return l10n.subEmotionConfident;
      case SubEmotion.hopeful:
        return l10n.subEmotionHopeful;
      case SubEmotion.euphoric:
        return l10n.subEmotionEuphoric;
      case SubEmotion.blessed:
        return l10n.subEmotionBlessed;
      case SubEmotion.unstoppable:
        return l10n.subEmotionUnstoppable;
    }
  }

  IconData _getReasonIcon(ReasonCategory reason) {
    switch (reason) {
      case ReasonCategory.academic:
        return Icons.school;
      case ReasonCategory.work:
        return Icons.work;
      case ReasonCategory.relationship:
        return Icons.favorite;
      case ReasonCategory.finance:
        return Icons.attach_money;
      case ReasonCategory.health:
        return Icons.health_and_safety;
      case ReasonCategory.social:
        return Icons.people;
      case ReasonCategory.personalGrowth:
        return Icons.psychology;
      case ReasonCategory.weather:
        return Icons.wb_sunny;
      case ReasonCategory.other:
        return Icons.more_horiz;
    }
  }

  String _getReasonTitle(ReasonCategory reason, AppLocalizations l10n) {
    switch (reason) {
      case ReasonCategory.academic:
        return l10n.reasonAcademic;
      case ReasonCategory.work:
        return l10n.reasonWork;
      case ReasonCategory.relationship:
        return l10n.reasonRelationship;
      case ReasonCategory.finance:
        return l10n.reasonFinance;
      case ReasonCategory.health:
        return l10n.reasonHealth;
      case ReasonCategory.social:
        return l10n.reasonSocial;
      case ReasonCategory.personalGrowth:
        return l10n.reasonPersonalGrowth;
      case ReasonCategory.weather:
        return l10n.reasonWeather;
      case ReasonCategory.other:
        return l10n.reasonOther;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Today ${_formatTime(dateTime)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${_formatTime(dateTime)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

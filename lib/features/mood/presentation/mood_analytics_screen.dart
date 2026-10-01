import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
    with SingleTickerProviderStateMixin {
  final DetailedMoodRepository _repository = DetailedMoodRepository();

  late TabController _tabController;
  List<MoodEntry> _recentEntries = [];
  MoodStatistics? _statistics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
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
      if (mounted) {
        setState(() {
          _recentEntries = entries;
          _statistics = stats;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final Color bgColor = theme.scaffoldBackgroundColor;
    final Color primaryColor = theme.colorScheme.primary;
    final Color textColor = theme.colorScheme.onSurface;
    final bool isDark = theme.brightness == Brightness.dark;

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Outfit',
            letterSpacing: -0.2,
          ),
          title: Text(l10n.moodAnalytics),
          leading: Center(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? const Color(0xFF1E2430) : Colors.white,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.95),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                    BoxShadow(
                      color:
                          Colors.white.withValues(alpha: isDark ? 0.05 : 0.8),
                      blurRadius: 2,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator(color: primaryColor))
            : Column(
                children: [
                  const SizedBox(height: 4),
                  // Floating Capsule Tab Switcher with Real-Time Sliding Indicator
                  _buildCapsuleTabBar(primaryColor, textColor, isDark, l10n),
                  const SizedBox(height: 10),
                  // Tab Views
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildOverviewTab(
                            theme, l10n, primaryColor, textColor, isDark),
                        _buildHistoryTab(
                            theme, l10n, primaryColor, textColor, isDark),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Floating Capsule Segment Switcher with Smooth Sliding Indicator
  Widget _buildCapsuleTabBar(
    Color primaryColor,
    Color textColor,
    bool isDark,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark
              ? Color.alphaBlend(
                  primaryColor.withValues(alpha: 0.08),
                  Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.65),
                )
              : Color.alphaBlend(
                  primaryColor.withValues(alpha: 0.07),
                  Color.alphaBlend(
                    Colors.black.withValues(alpha: 0.04),
                    Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.95),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: isDark ? 0.04 : 0.8),
              blurRadius: 1,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double pillWidth = (constraints.maxWidth - 2) / 2;

            return Stack(
              children: [
                // 1. Sliding Indicator Pill (Synchronous with TabController animation)
                AnimatedBuilder(
                  animation: _tabController.animation!,
                  builder: (context, child) {
                    final animVal = (_tabController.animation?.value ??
                            _tabController.index.toDouble())
                        .clamp(0.0, 1.0);
                    final leftOffset =
                        animVal * (constraints.maxWidth - pillWidth - 2);

                    return Positioned(
                      left: leftOffset,
                      top: 0,
                      bottom: 0,
                      width: pillWidth,
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: isDark ? 0.25 : 0.35,
                            ),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.22),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.20 : 0.04,
                              ),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // 2. Interactive Tab Labels on top
                Row(
                  children: [
                    Expanded(
                      child: _buildSlidingTabItem(
                        index: 0,
                        title: l10n.overview,
                        icon: Icons.insights_rounded,
                        textColor: textColor,
                      ),
                    ),
                    Expanded(
                      child: _buildSlidingTabItem(
                        index: 1,
                        title: l10n.history,
                        icon: Icons.history_rounded,
                        textColor: textColor,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSlidingTabItem({
    required int index,
    required String title,
    required IconData icon,
    required Color textColor,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        _tabController.animateTo(
          index,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
        );
      },
      child: AnimatedBuilder(
        animation: _tabController.animation!,
        builder: (context, child) {
          final animVal = (_tabController.animation?.value ??
                  _tabController.index.toDouble())
              .clamp(0.0, 1.0);
          final weight = index == 0 ? (1.0 - animVal) : animVal;
          final activeColor = Colors.white;
          final inactiveColor = textColor.withValues(alpha: 0.65);
          final itemColor = Color.lerp(inactiveColor, activeColor, weight)!;

          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: itemColor,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: itemColor,
                    fontSize: 13.5,
                    fontWeight:
                        weight > 0.5 ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab(
    ThemeData theme,
    AppLocalizations l10n,
    Color primaryColor,
    Color textColor,
    bool isDark,
  ) {
    if (_statistics == null || _statistics!.totalEntries == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(
                  alpha: isDark ? 0.45 : 0.7,
                ),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child:
                      Icon(Icons.mood_rounded, size: 36, color: primaryColor),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.noMoodData,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.startTrackingMood,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.65),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Hero Emotional Harmony Score Card
          _buildHeroScoreCard(theme, l10n, textColor, isDark),
          const SizedBox(height: 16),

          // 2. Mood Distribution Donut Chart & Visual Progress Breakdown
          _buildMoodDistributionCard(theme, l10n, textColor, isDark),
          const SizedBox(height: 16),

          // 3. Top Patterns Card
          _buildTopPatternsCard(theme, l10n, primaryColor, textColor, isDark),
        ],
      ),
    );
  }

  // 1. Hero Emotional Harmony Score Card
  Widget _buildHeroScoreCard(
    ThemeData theme,
    AppLocalizations l10n,
    Color textColor,
    bool isDark,
  ) {
    final score = _statistics!.averageMoodScore;
    final moodColor = _getMoodColorByScore(score);

    String statusTitle;
    String statusSubtitle;
    if (score >= 4.0) {
      statusTitle = 'Harika Denge ✨';
      statusSubtitle = 'Pozitif enerji ve motivasyonun oldukça yüksek';
    } else if (score >= 3.0) {
      statusTitle = 'Dengeli & Sakin 🌿';
      statusSubtitle = 'Duyguların stabil ve dengeli bir akışta';
    } else {
      statusTitle = 'Yenilenme Vakti 🕊️';
      statusSubtitle = 'Kendine zaman tanı ve dinlenmeye özen göster';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            moodColor.withValues(alpha: isDark ? 0.20 : 0.12),
            moodColor.withValues(alpha: isDark ? 0.06 : 0.02),
          ],
        ),
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: moodColor.withValues(alpha: isDark ? 0.35 : 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: moodColor.withValues(alpha: isDark ? 0.25 : 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.9),
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Avatar Orb + Score + Status Badge
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      moodColor,
                      moodColor.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: moodColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _getMoodIcon(_statistics!.mostCommonMood),
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.averageMood,
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.65),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          score.toStringAsFixed(1),
                          style: TextStyle(
                            color: textColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          ' / 5.0',
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.5),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: moodColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: moodColor.withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),
                child: Text(
                  statusTitle,
                  style: TextStyle(
                    color: moodColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            statusSubtitle,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.7),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          // Bottom Stat Badges Row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.25)
                        : Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          Colors.white.withValues(alpha: isDark ? 0.06 : 0.8),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.event_note_rounded,
                        size: 18,
                        color: moodColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${_statistics!.totalEntries} ${l10n.totalEntries}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.85),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.25)
                        : Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          Colors.white.withValues(alpha: isDark ? 0.06 : 0.8),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getMoodIcon(_statistics!.mostCommonMood),
                        size: 18,
                        color: _getMoodLevelColor(_statistics!.mostCommonMood),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getMoodTitle(_statistics!.mostCommonMood, l10n),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.85),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. Mood Distribution Donut Chart & Visual Progress Breakdown
  Widget _buildMoodDistributionCard(
    ThemeData theme,
    AppLocalizations l10n,
    Color textColor,
    bool isDark,
  ) {
    final total = _statistics!.totalEntries;

    final sections = _statistics!.moodDistribution.entries.map((entry) {
      final mood = entry.key;
      final count = entry.value;
      final color = _getMoodLevelColor(mood);

      return PieChartSectionData(
        color: color,
        value: count.toDouble(),
        showTitle: false,
        radius: 22,
      );
    }).toList();

    const moodOrder = [
      MoodLevel.excellent,
      MoodLevel.good,
      MoodLevel.neutral,
      MoodLevel.bad,
      MoodLevel.terrible,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.95),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.9),
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.moodDistribution,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$total kayıt',
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.65),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Donut Chart with Centered Mood Face
          Center(
            child: SizedBox(
              width: 180,
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: 54,
                      sectionsSpace: 3,
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getMoodIcon(_statistics!.mostCommonMood),
                        size: 32,
                        color: _getMoodLevelColor(_statistics!.mostCommonMood),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getMoodTitle(_statistics!.mostCommonMood, l10n),
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // 5 TactProgress Bars
          Column(
            children: moodOrder.map((mood) {
              final count = _statistics!.moodDistribution[mood] ?? 0;
              final percent = total > 0 ? (count / total) : 0.0;
              final moodColor = _getMoodLevelColor(mood);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: moodColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getMoodIcon(mood),
                        color: moodColor,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 76,
                      child: Text(
                        _getMoodTitle(mood, l10n),
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.85),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          height: 8,
                          color: textColor.withValues(alpha: 0.06),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: percent.clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      moodColor,
                                      moodColor.withValues(alpha: 0.8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 68,
                      child: Text(
                        '$count (%${(percent * 100).toStringAsFixed(0)})',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.65),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // 3. Top Patterns Card
  Widget _buildTopPatternsCard(
    ThemeData theme,
    AppLocalizations l10n,
    Color primaryColor,
    Color textColor,
    bool isDark,
  ) {
    if (_statistics == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(
            alpha: isDark ? 0.45 : 0.7,
          ),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.9),
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.topCategories,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 16),
          _buildPatternItem(
            label: l10n.mostCommonMood,
            value: _getMoodTitle(_statistics!.mostCommonMood, l10n),
            icon: _getMoodIcon(_statistics!.mostCommonMood),
            color: _getMoodLevelColor(_statistics!.mostCommonMood),
            textColor: textColor,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _buildPatternItem(
            label: l10n.mostCommonEmotion,
            value: _getSubEmotionTitle(_statistics!.mostCommonSubEmotion, l10n),
            icon: _getSubEmotionIcon(_statistics!.mostCommonSubEmotion),
            color: primaryColor,
            textColor: textColor,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _buildPatternItem(
            label: l10n.mostCommonReason,
            value: _getReasonTitle(_statistics!.mostCommonReason, l10n),
            icon: _getReasonIcon(_statistics!.mostCommonReason),
            color: const Color(0xFFEC4899), // Pinkish accent
            textColor: textColor,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildPatternItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required Color textColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: isDark ? 0.06 : 0.9),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.55),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // HISTORY TAB
  // ----------------------------------------------------
  Widget _buildHistoryTab(
    ThemeData theme,
    AppLocalizations l10n,
    Color primaryColor,
    Color textColor,
    bool isDark,
  ) {
    if (_recentEntries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.95),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.history_rounded,
                  size: 56,
                  color: textColor.withValues(alpha: 0.25),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.noHistory,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return AnimationLimiter(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        itemCount: _recentEntries.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final entry = _recentEntries[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 280),
            child: SlideAnimation(
              verticalOffset: 20,
              child: FadeInAnimation(
                child: _buildHistoryCard(
                  entry: entry,
                  l10n: l10n,
                  textColor: textColor,
                  isDark: isDark,
                  surfaceColor: theme.colorScheme.surfaceContainerHigh,
                  surfaceMutedColor: theme.colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard({
    required MoodEntry entry,
    required AppLocalizations l10n,
    required Color textColor,
    required bool isDark,
    required Color surfaceColor,
    required Color surfaceMutedColor,
  }) {
    final moodColor = _getMoodLevelColor(entry.mood);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.95),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.8),
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar + Title + Time + Actions Button
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      moodColor,
                      moodColor.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: moodColor.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  _getMoodIcon(entry.mood),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getMoodTitle(entry.mood, l10n),
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: textColor.withValues(alpha: 0.45),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDateTime(entry.timestamp),
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.55),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // More Actions Button
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _showHistoryEntryActions(entry);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: surfaceMutedColor,
                  ),
                  child: Icon(
                    Icons.more_horiz_rounded,
                    size: 18,
                    color: textColor.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
          // Journal Note Box
          if (entry.journalText.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF202735) : const Color(0xFFF7F9FC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: isDark ? 0.06 : 0.8),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 3,
                    height: 28,
                    decoration: BoxDecoration(
                      color: moodColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.journalText,
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.85),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Tags
          if (entry.subEmotions.isNotEmpty ||
              entry.reason != ReasonCategory.other) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ...entry.subEmotions.map(
                  (s) => _buildTactileTag(
                    text: _getSubEmotionTitle(s, l10n),
                    icon: _getSubEmotionIcon(s),
                    color: moodColor,
                    textColor: textColor,
                    isDark: isDark,
                  ),
                ),
                _buildTactileTag(
                  text: _getReasonTitle(entry.reason, l10n),
                  icon: _getReasonIcon(entry.reason),
                  color: const Color(0xFFEC4899),
                  textColor: textColor,
                  isDark: isDark,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTactileTag({
    required String text,
    required IconData icon,
    required Color color,
    required Color textColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.85),
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // ACTION & EDIT SHEETS
  // ----------------------------------------------------
  void _showHistoryEntryActions(MoodEntry entry) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final primaryColor = theme.colorScheme.primary;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF161A22).withValues(alpha: 0.94)
                    : Colors.white.withValues(alpha: 0.94),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.9),
                    width: 1.5,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle pill
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: textColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Entry header preview
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: _getMoodLevelColor(entry.mood)
                              .withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          _getMoodIcon(entry.mood),
                          color: _getMoodLevelColor(entry.mood),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getMoodTitle(entry.mood, l10n),
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _formatDateTime(entry.timestamp),
                              style: TextStyle(
                                color: textColor.withValues(alpha: 0.5),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Edit Action
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _showEditEntrySheet(entry);
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: primaryColor.withValues(alpha: 0.3),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_rounded,
                              color: primaryColor, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            l10n.edit,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Delete Action
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(ctx);
                      _showDeleteConfirmation(entry);
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              const Color(0xFFEF4444).withValues(alpha: 0.25),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.delete_outline_rounded,
                              color: Color(0xFFEF4444), size: 20),
                          const SizedBox(width: 10),
                          Text(
                            l10n.delete,
                            style: const TextStyle(
                              color: Color(0xFFEF4444),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(MoodEntry entry) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 32),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF161A22).withValues(alpha: 0.95)
                    : Colors.white.withValues(alpha: 0.95),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.9),
                    width: 1.5,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: textColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_forever_rounded,
                      color: Color(0xFFEF4444),
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.delete,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.deleteEntryConfirm,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.65),
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF222938)
                                  : const Color(0xFFF1F4F9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              l10n.cancel,
                              style: TextStyle(
                                color: textColor.withValues(alpha: 0.8),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.pop(ctx);
                            await _repository.deleteMoodEntry(entry.id);
                            await _loadData();
                          },
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFEF4444)
                                      .withValues(alpha: 0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              l10n.delete,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditEntrySheet(MoodEntry entry) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final primaryColor = theme.colorScheme.primary;

    final noteCtrl = TextEditingController(text: entry.journalText);
    var selectedMood = entry.mood;
    var selectedReason = entry.reason;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    MediaQuery.of(ctx).viewInsets.bottom + 28,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF161A22).withValues(alpha: 0.96)
                        : Colors.white.withValues(alpha: 0.96),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(32)),
                    border: Border(
                      top: BorderSide(
                        color:
                            Colors.white.withValues(alpha: isDark ? 0.12 : 0.9),
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: textColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          l10n.edit,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // 1. Mood Picker Track (2-Row Layout to avoid horizontal squishing)
                        Builder(
                          builder: (context) {
                            Widget buildMoodBtn(MoodLevel m) {
                              final isSel = selectedMood == m;
                              final mColor = _getMoodLevelColor(m);
                              return Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: _AnalyticsBouncingTapWrapper(
                                    lowerBound: 0.93,
                                    duration: const Duration(milliseconds: 110),
                                    onTap: () {
                                      HapticFeedback.selectionClick();
                                      setModalState(() => selectedMood = m);
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 220),
                                      curve: Curves.easeOutCubic,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: isSel
                                            ? (isDark
                                                ? mColor.withValues(alpha: 0.18)
                                                : mColor.withValues(
                                                    alpha: 0.10))
                                            : (isDark
                                                ? const Color(0xFF222938)
                                                : const Color(0xFFF6F8FB)),
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: isSel
                                              ? mColor.withValues(
                                                  alpha: isDark ? 0.70 : 0.85)
                                              : Colors.white.withValues(
                                                  alpha: isDark ? 0.06 : 0.95),
                                          width: isSel ? 1.6 : 1.2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: isDark
                                                  ? (isSel ? 0.22 : 0.12)
                                                  : (isSel ? 0.05 : 0.02),
                                            ),
                                            blurRadius: isSel ? 6 : 3,
                                            offset: const Offset(0, 2),
                                          ),
                                          BoxShadow(
                                            color: Colors.white.withValues(
                                                alpha: isDark ? 0.03 : 0.8),
                                            blurRadius: 1,
                                            offset: const Offset(0, -1),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _getMoodIcon(m),
                                            size: 24,
                                            color: isSel
                                                ? mColor
                                                : textColor.withValues(
                                                    alpha: 0.5),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            _getMoodTitle(m, l10n),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: isSel
                                                  ? mColor
                                                  : textColor.withValues(
                                                      alpha: 0.7),
                                              fontSize: 12,
                                              fontWeight: isSel
                                                  ? FontWeight.bold
                                                  : FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    buildMoodBtn(MoodLevel.excellent),
                                    buildMoodBtn(MoodLevel.good),
                                    buildMoodBtn(MoodLevel.neutral),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    buildMoodBtn(MoodLevel.bad),
                                    buildMoodBtn(MoodLevel.terrible),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 18),
                        // 2. Reason Category Chips
                        Text(
                          l10n.selectReason,
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ReasonCategory.values.map((r) {
                            final isSel = selectedReason == r;
                            return _AnalyticsBouncingTapWrapper(
                              lowerBound: 0.93,
                              duration: const Duration(milliseconds: 110),
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setModalState(() => selectedReason = r);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeOutCubic,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSel
                                      ? primaryColor
                                      : (isDark
                                          ? const Color(0xFF222938)
                                          : const Color(0xFFF4F6F9)),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSel
                                        ? Colors.white.withValues(alpha: 0.35)
                                        : Colors.white.withValues(
                                            alpha: isDark ? 0.06 : 0.9),
                                    width: 1.2,
                                  ),
                                  boxShadow: isSel
                                      ? [
                                          BoxShadow(
                                            color: primaryColor.withValues(
                                                alpha: 0.20),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                                alpha: isDark ? 0.1 : 0.02),
                                            blurRadius: 3,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedSize(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeOutCubic,
                                      child: isSel
                                          ? const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.check_rounded,
                                                  size: 14,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 4),
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                    Text(
                                      _getReasonTitle(r, l10n),
                                      style: TextStyle(
                                        color: isSel
                                            ? Colors.white
                                            : textColor.withValues(alpha: 0.8),
                                        fontSize: 12.5,
                                        fontWeight: isSel
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 18),
                        // 3. Note Field
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF222938)
                                : const Color(0xFFF4F6FA),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: TextField(
                            controller: noteCtrl,
                            maxLines: 3,
                            style: TextStyle(color: textColor, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: l10n.noteOptional,
                              hintStyle: TextStyle(
                                color: textColor.withValues(alpha: 0.4),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        // 4. Save Button
                        _AnalyticsBouncingTapWrapper(
                          lowerBound: 0.96,
                          duration: const Duration(milliseconds: 110),
                          onTap: () async {
                            HapticFeedback.mediumImpact();
                            final updated = MoodEntry(
                              id: entry.id,
                              mood: selectedMood,
                              subEmotions: entry.subEmotions,
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
                          child: Container(
                            height: 52,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  primaryColor,
                                  primaryColor.withValues(alpha: 0.85),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.20),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                                BoxShadow(
                                  color: Colors.black
                                      .withValues(alpha: isDark ? 0.2 : 0.04),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              l10n.save,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Helper methods
  Color _getMoodLevelColor(MoodLevel m) {
    switch (m) {
      case MoodLevel.excellent:
        return const Color(0xFF3B82F6); // Vibrant Blue
      case MoodLevel.good:
        return const Color(0xFF10B981); // Emerald Green
      case MoodLevel.neutral:
        return const Color(0xFFF59E0B); // Warm Amber
      case MoodLevel.bad:
        return const Color(0xFFF97316); // Bright Orange
      case MoodLevel.terrible:
        return const Color(0xFFEF4444); // Crimson Red
    }
  }

  Color _getMoodScoreColor(double score) {
    if (score >= 4.5) return const Color(0xFF3B82F6);
    if (score >= 3.5) return const Color(0xFF10B981);
    if (score >= 2.5) return const Color(0xFFF59E0B);
    if (score >= 1.5) return const Color(0xFFF97316);
    return const Color(0xFFEF4444);
  }

  Color _getMoodColorByScore(double score) => _getMoodScoreColor(score);

  IconData _getMoodIcon(MoodLevel mood) {
    switch (mood) {
      case MoodLevel.terrible:
        return Icons.sentiment_very_dissatisfied_rounded;
      case MoodLevel.bad:
        return Icons.sentiment_dissatisfied_rounded;
      case MoodLevel.neutral:
        return Icons.sentiment_neutral_rounded;
      case MoodLevel.good:
        return Icons.sentiment_satisfied_alt_rounded;
      case MoodLevel.excellent:
        return Icons.sentiment_very_satisfied_rounded;
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
    switch (subEmotion) {
      case SubEmotion.exhausted:
        return Icons.battery_0_bar_rounded;
      case SubEmotion.helpless:
        return Icons.help_outline_rounded;
      case SubEmotion.hopeless:
        return Icons.cloud_off_rounded;
      case SubEmotion.hurt:
        return Icons.favorite_border_rounded;
      case SubEmotion.drained:
        return Icons.water_drop_outlined;
      case SubEmotion.angry:
        return Icons.flash_on_rounded;
      case SubEmotion.sad:
        return Icons.sentiment_dissatisfied_rounded;
      case SubEmotion.anxious:
        return Icons.psychology_rounded;
      case SubEmotion.stressed:
        return Icons.speed_rounded;
      case SubEmotion.demoralized:
        return Icons.trending_down_rounded;
      case SubEmotion.indecisive:
        return Icons.shuffle_rounded;
      case SubEmotion.tired:
        return Icons.bedtime_rounded;
      case SubEmotion.ordinary:
        return Icons.remove_rounded;
      case SubEmotion.calm:
        return Icons.spa_rounded;
      case SubEmotion.empty:
        return Icons.crop_free_rounded;
      case SubEmotion.happy:
        return Icons.sentiment_satisfied_rounded;
      case SubEmotion.cheerful:
        return Icons.emoji_emotions_rounded;
      case SubEmotion.excited:
        return Icons.celebration_rounded;
      case SubEmotion.enthusiastic:
        return Icons.local_fire_department_rounded;
      case SubEmotion.determined:
        return Icons.flag_rounded;
      case SubEmotion.motivated:
        return Icons.trending_up_rounded;
      case SubEmotion.amazing:
        return Icons.auto_awesome_rounded;
      case SubEmotion.energetic:
        return Icons.bolt_rounded;
      case SubEmotion.peaceful:
        return Icons.self_improvement_rounded;
      case SubEmotion.grateful:
        return Icons.favorite_rounded;
      case SubEmotion.loving:
        return Icons.volunteer_activism_rounded;
      case SubEmotion.overwhelmed:
        return Icons.waves_rounded;
      case SubEmotion.lonely:
        return Icons.person_off_rounded;
      case SubEmotion.regretful:
        return Icons.undo_rounded;
      case SubEmotion.insecure:
        return Icons.lock_open_rounded;
      case SubEmotion.guilty:
        return Icons.gavel_rounded;
      case SubEmotion.bored:
        return Icons.hourglass_empty_rounded;
      case SubEmotion.numb:
        return Icons.ac_unit_rounded;
      case SubEmotion.confused:
        return Icons.psychology_alt_rounded;
      case SubEmotion.distracted:
        return Icons.notifications_off_rounded;
      case SubEmotion.proud:
        return Icons.verified_rounded;
      case SubEmotion.confident:
        return Icons.shield_rounded;
      case SubEmotion.hopeful:
        return Icons.wb_sunny_rounded;
      case SubEmotion.euphoric:
        return Icons.rocket_launch_rounded;
      case SubEmotion.blessed:
        return Icons.auto_awesome_rounded;
      case SubEmotion.unstoppable:
        return Icons.bolt_rounded;
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
        return Icons.school_rounded;
      case ReasonCategory.work:
        return Icons.work_rounded;
      case ReasonCategory.relationship:
        return Icons.favorite_rounded;
      case ReasonCategory.finance:
        return Icons.attach_money_rounded;
      case ReasonCategory.health:
        return Icons.health_and_safety_rounded;
      case ReasonCategory.social:
        return Icons.people_rounded;
      case ReasonCategory.personalGrowth:
        return Icons.psychology_rounded;
      case ReasonCategory.weather:
        return Icons.wb_sunny_rounded;
      case ReasonCategory.other:
        return Icons.more_horiz_rounded;
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

    if (difference.inDays == 0 && now.day == dateTime.day) {
      return 'Bugün ${_formatTime(dateTime)}';
    } else if (difference.inDays <= 1 ||
        (now.day - dateTime.day == 1 && now.month == dateTime.month)) {
      return 'Dün ${_formatTime(dateTime)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return '${dateTime.day}.${dateTime.month}.${dateTime.year}';
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _AnalyticsBouncingTapWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double lowerBound;
  final Duration duration;

  const _AnalyticsBouncingTapWrapper({
    required this.child,
    required this.onTap,
    this.lowerBound = 0.94,
    this.duration = const Duration(milliseconds: 120),
  });

  @override
  State<_AnalyticsBouncingTapWrapper> createState() =>
      _AnalyticsBouncingTapWrapperState();
}

class _AnalyticsBouncingTapWrapperState
    extends State<_AnalyticsBouncingTapWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: const Duration(milliseconds: 220),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.lowerBound,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}

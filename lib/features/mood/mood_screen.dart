
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:mira/l10n/app_localizations.dart';

import '../../design_system/theme/theme_variations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'data/detailed_mood_repository.dart';
import 'data/mood_models.dart';
import 'presentation/mood_analytics_screen.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key, required this.variant});

  final ThemeVariant variant;

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  final _repo = DetailedMoodRepository();

  bool _loading = true;

  // Selected state
  MoodLevel? _selectedMood;
  Set<SubEmotion> _selectedSubEmotions = {};
  ReasonCategory? _selectedReason;
  final _noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final today = DateTime.now();
    // Pre-select if there's already an entry for today
    final existingEntries = await _repo.getMoodEntriesForDate(today);
    if (existingEntries.isNotEmpty) {
      final existing = existingEntries.first;
      _selectedMood = existing.mood;
      _selectedSubEmotions = existing.subEmotions.toSet();
      _selectedReason = existing.reason;
      _noteCtrl.text = existing.journalText;
    }

    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveToday() async {
    if (_selectedMood == null) return;

    // Default reason if not selected
    final reason = _selectedReason ?? ReasonCategory.other;

    final entry = MoodEntry(
      id: const Uuid().v4(),
      timestamp: DateTime.now(),
      mood: _selectedMood!,
      subEmotions: _selectedSubEmotions.toList(),
      reason: reason,
      journalText: _noteCtrl.text.trim(),
    );

    await _repo.saveMoodEntry(entry);

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  // Define full sub-emotion list for each mood category so all 41 are available
  List<SubEmotion> _getExpandedSubEmotionsForMood(MoodLevel mood) {
    if (mood == MoodLevel.terrible || mood == MoodLevel.bad) {
      // Grouping all negative emotions
      return [
        SubEmotion.exhausted,
        SubEmotion.helpless,
        SubEmotion.hopeless,
        SubEmotion.hurt,
        SubEmotion.drained,
        SubEmotion.angry,
        SubEmotion.sad,
        SubEmotion.anxious,
        SubEmotion.stressed,
        SubEmotion.demoralized,
        SubEmotion.overwhelmed,
        SubEmotion.lonely,
        SubEmotion.regretful,
        SubEmotion.insecure,
        SubEmotion.guilty,
      ];
    } else if (mood == MoodLevel.neutral) {
      // Grouping all neutral emotions
      return [
        SubEmotion.indecisive,
        SubEmotion.tired,
        SubEmotion.ordinary,
        SubEmotion.calm,
        SubEmotion.empty,
        SubEmotion.bored,
        SubEmotion.numb,
        SubEmotion.confused,
        SubEmotion.distracted,
      ];
    } else {
      // Grouping all positive emotions (good, excellent)
      return [
        SubEmotion.happy,
        SubEmotion.cheerful,
        SubEmotion.excited,
        SubEmotion.enthusiastic,
        SubEmotion.determined,
        SubEmotion.motivated,
        SubEmotion.proud,
        SubEmotion.confident,
        SubEmotion.hopeful,
        SubEmotion.amazing,
        SubEmotion.energetic,
        SubEmotion.peaceful,
        SubEmotion.grateful,
        SubEmotion.loving,
        SubEmotion.euphoric,
        SubEmotion.blessed,
        SubEmotion.unstoppable,
      ];
    }
  }

  Color _getMoodColor(MoodLevel m) {
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

  IconData _getMoodIconData(MoodLevel m) {
    switch (m) {
      case MoodLevel.excellent:
        return Icons.sentiment_very_satisfied_rounded;
      case MoodLevel.good:
        return Icons.sentiment_satisfied_alt_rounded;
      case MoodLevel.neutral:
        return Icons.sentiment_neutral_rounded;
      case MoodLevel.bad:
        return Icons.sentiment_dissatisfied_rounded;
      case MoodLevel.terrible:
        return Icons.sentiment_very_dissatisfied_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final ThemeData theme = Theme.of(context);
    final Color bgColor = theme.scaffoldBackgroundColor;
    final Color primaryColor = theme.colorScheme.primary;
    final Color textColor = theme.colorScheme.onSurface;

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
          title: Text(AppLocalizations.of(context).moodScreenTitle),
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
                      color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                    BoxShadow(
                      color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.8),
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MoodAnalyticsScreen(variant: widget.variant),
                      ),
                    );
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
                          color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                        BoxShadow(
                          color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.8),
                          blurRadius: 2,
                          offset: const Offset(0, -1),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.history_rounded,
                      size: 20,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator(color: primaryColor))
            : _buildInputContent(context, primaryColor, textColor, isDark),
      ),
    );
  }

  Widget _buildInputContent(
    BuildContext context,
    Color primaryColor,
    Color textColor,
    bool isDark,
  ) {
    List<SubEmotion> availableSubEmotions = [];
    if (_selectedMood != null) {
      availableSubEmotions = _getExpandedSubEmotionsForMood(_selectedMood!);
    }

    final Color hintColor = textColor.withValues(alpha: 0.5);
    final cardBg = isDark ? const Color(0xFF181D27) : Colors.white;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.white.withValues(alpha: isDark ? 0.10 : 0.95),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
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
              child: AnimationLimiter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).howAreYouFeeling,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Hero Expressive Mood Showcase Card
                    _buildMoodHeroCard(context, textColor, isDark),
                    const SizedBox(height: 18),

                    // Tactile Claymorphic Mood Selector Track
                    _buildMoodSelectorTrack(context, textColor, isDark),

                    if (_selectedMood != null) ...[
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context).whichEmotionsExpress,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),
                          if (_selectedSubEmotions.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: primaryColor.withValues(alpha: 0.35),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                '${_selectedSubEmotions.length}',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: availableSubEmotions.map((sub) {
                          final isSelected = _selectedSubEmotions.contains(sub);
                          return _buildCustomChip(
                            label: _getSubEmotionLabel(sub),
                            isSelected: isSelected,
                            primaryColor: primaryColor,
                            textColor: textColor,
                            isDark: isDark,
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedSubEmotions.remove(sub);
                                } else {
                                  _selectedSubEmotions.add(sub);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context).emotionDescription,
                        style: TextStyle(
                          color: hintColor,
                          fontSize: 12.5,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context).whyDoYouFeelThisWay,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),
                          if (_selectedReason != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: primaryColor.withValues(alpha: 0.35),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _getReasonLabel(_selectedReason!),
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ReasonCategory.values.map((reason) {
                          final isSelected = _selectedReason == reason;
                          return _buildCustomChip(
                            label: _getReasonLabel(reason),
                            isSelected: isSelected,
                            primaryColor: primaryColor,
                            textColor: textColor,
                            isDark: isDark,
                            onTap: () {
                              setState(() {
                                _selectedReason = isSelected ? null : reason;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        AppLocalizations.of(context).anythingElseToAdd,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E2430)
                              : const Color(0xFFF6F8FB),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: isDark ? 0.08 : 0.95,
                            ),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.2 : 0.03,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _noteCtrl,
                          maxLines: 4,
                          style: TextStyle(color: textColor, fontSize: 15),
                          decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context).addMoodNoteHint,
                            hintStyle: TextStyle(color: hintColor, height: 1.4),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(20),
                          ),
                        ),
                      ),
                    ],
                  ].asMap().entries.map((e) {
                    return AnimationConfiguration.staggeredList(
                      position: e.key,
                      duration: const Duration(milliseconds: 320),
                      child: SlideAnimation(
                        verticalOffset: 30.0,
                        child: FadeInAnimation(
                          child: e.value,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
        // Bottom Action Area
        Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 28),
          color: Colors.transparent,
          child: _BouncingTapWrapper(
            lowerBound: 0.96,
            duration: const Duration(milliseconds: 110),
            onTap: _selectedMood == null
                ? () {}
                : () {
                    HapticFeedback.mediumImpact();
                    _saveToday();
                  },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              height: 54,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: _selectedMood != null
                    ? LinearGradient(
                        colors: [
                          primaryColor,
                          primaryColor.withValues(alpha: 0.85),
                        ],
                      )
                    : null,
                color: _selectedMood == null
                    ? (isDark
                        ? Colors.white10
                        : Colors.black.withValues(alpha: 0.08))
                    : null,
                borderRadius: BorderRadius.circular(27),
                border: Border.all(
                  color: _selectedMood != null
                      ? Colors.white.withValues(alpha: 0.35)
                      : Colors.transparent,
                  width: 1.2,
                ),
                boxShadow: _selectedMood != null
                    ? [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.22),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                _selectedMood == null
                    ? AppLocalizations.of(context).moodNext
                    : AppLocalizations.of(context).moodSave,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _selectedMood == null
                      ? textColor.withValues(alpha: 0.4)
                      : Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomChip({
    required String label,
    required bool isSelected,
    required Color primaryColor,
    required Color textColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return _BouncingTapWrapper(
      lowerBound: 0.93,
      duration: const Duration(milliseconds: 110),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor
              : (isDark ? const Color(0xFF222938) : const Color(0xFFF4F6F9)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.35)
                : Colors.white.withValues(alpha: isDark ? 0.08 : 0.95),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.20),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: isDark ? 0.04 : 0.8),
                    blurRadius: 1,
                    offset: const Offset(0, -1),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              child: isSelected
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_rounded,
                          size: 15,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : textColor.withValues(alpha: 0.85),
                fontSize: 13.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMoodFace(MoodLevel m) {
    return Icon(_getMoodIconData(m), color: _getMoodColor(m), size: 36);
  }

  Widget _buildMoodHeroCard(BuildContext context, Color textColor, bool isDark) {
    final l10n = AppLocalizations.of(context);
    final bool hasSelection = _selectedMood != null;
    final Color activeColor =
        hasSelection ? _getMoodColor(_selectedMood!) : const Color(0xFF6366F1);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: hasSelection
            ? (isDark
                ? activeColor.withValues(alpha: 0.12)
                : activeColor.withValues(alpha: 0.06))
            : (isDark ? const Color(0xFF1E2430) : const Color(0xFFF7F9FC)),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: hasSelection
              ? activeColor.withValues(alpha: isDark ? 0.35 : 0.45)
              : Colors.white.withValues(alpha: isDark ? 0.08 : 0.95),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: isDark ? 0.03 : 0.8),
            blurRadius: 1,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: hasSelection
          ? Row(
              children: [
                // Clean Avatar Orb (Matte, refined, no neon glare)
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: activeColor.withValues(alpha: isDark ? 0.22 : 0.14),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: activeColor.withValues(alpha: 0.4),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getMoodIconData(_selectedMood!),
                    color: activeColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                // Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            _getMoodTitle(_selectedMood!),
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Outfit',
                              letterSpacing: -0.3,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 3.5,
                            ),
                            decoration: BoxDecoration(
                              color: activeColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: activeColor.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              _getMoodLevelScoreLabel(_selectedMood!),
                              style: TextStyle(
                                color: activeColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _getMoodDescription(_selectedMood!),
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.8),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _getMoodPoeticNote(_selectedMood!),
                        style: TextStyle(
                          color: activeColor,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF222938)
                        : const Color(0xFFEDF2F7),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.8),
                      width: 1.2,
                    ),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: isDark ? Colors.white70 : const Color(0xFF64748B),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.howAreYouFeeling,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Outfit',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.moodFlowSubtitle,
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  // 2-Row Tactile Mood Buttons (Spacious, perfectly fits emoji and text, fluid & no glare)
  Widget _buildMoodSelectorTrack(
    BuildContext context,
    Color textColor,
    bool isDark,
  ) {
    const row1Moods = [
      MoodLevel.excellent,
      MoodLevel.good,
      MoodLevel.neutral,
    ];
    const row2Moods = [
      MoodLevel.bad,
      MoodLevel.terrible,
    ];

    return Column(
      children: [
        // Satır 1: Mükemmel, İyi, Normal (3 öğe - rahat genişlik)
        Row(
          children: row1Moods.map((m) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _buildMoodButton(m, textColor, isDark),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        // Satır 2: Kötü, Berbat (2 öğe - ferah ve tam oturan genişlik)
        Row(
          children: row2Moods.map((m) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _buildMoodButton(m, textColor, isDark),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMoodButton(
    MoodLevel m,
    Color textColor,
    bool isDark,
  ) {
    final isSelected = _selectedMood == m;
    final moodColor = _getMoodColor(m);

    return _BouncingTapWrapper(
        lowerBound: 0.93,
        duration: const Duration(milliseconds: 110),
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() {
            _selectedMood = m;
            _selectedSubEmotions.clear();
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                    ? moodColor.withValues(alpha: 0.18)
                    : moodColor.withValues(alpha: 0.10))
                : (isDark ? const Color(0xFF1E2430) : const Color(0xFFF6F8FB)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? moodColor.withValues(alpha: isDark ? 0.70 : 0.85)
                  : Colors.white.withValues(alpha: isDark ? 0.06 : 0.95),
              width: isSelected ? 1.6 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? (isSelected ? 0.25 : 0.15) : (isSelected ? 0.05 : 0.02),
                ),
                blurRadius: isSelected ? 8 : 4,
                offset: const Offset(0, 2),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: isDark ? 0.03 : 0.8),
                blurRadius: 1,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getMoodIconData(m),
                color: isSelected ? moodColor : textColor.withValues(alpha: 0.5),
                size: 26,
              ),
              const SizedBox(height: 6),
              Text(
                _getMoodTitle(m),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected
                      ? (isDark ? Colors.white : moodColor)
                      : textColor.withValues(alpha: 0.75),
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      );
  }

  String _getMoodLevelScoreLabel(MoodLevel m) {
    switch (m) {
      case MoodLevel.excellent:
        return '5/5';
      case MoodLevel.good:
        return '4/5';
      case MoodLevel.neutral:
        return '3/5';
      case MoodLevel.bad:
        return '2/5';
      case MoodLevel.terrible:
        return '1/5';
    }
  }

  String _getMoodDescription(MoodLevel m) {
    final l10n = AppLocalizations.of(context);
    switch (m) {
      case MoodLevel.excellent:
        return l10n.moodExcellentDesc;
      case MoodLevel.good:
        return l10n.moodGoodDesc;
      case MoodLevel.neutral:
        return l10n.moodNeutralDesc;
      case MoodLevel.bad:
        return l10n.moodBadDesc;
      case MoodLevel.terrible:
        return l10n.moodTerribleDesc;
    }
  }

  String _getMoodPoeticNote(MoodLevel m) {
    switch (m) {
      case MoodLevel.excellent:
        return '✨ Enerjin parlıyor, anın tadını çıkar';
      case MoodLevel.good:
        return '🌱 Huzurlu ve dengeli bir akıştasın';
      case MoodLevel.neutral:
        return '☕ Durgun ve sakin bir gün, dinlen';
      case MoodLevel.bad:
        return '🌧️ Kendine nazik davran, dinlenmeye vakit ayır';
      case MoodLevel.terrible:
        return '⚡ Her fırtına diner, kendine zaman tanı';
    }
  }

  String _getMoodTitle(MoodLevel m) {
    final l10n = AppLocalizations.of(context);
    switch (m) {
      case MoodLevel.excellent:
        return l10n.moodExcellent;
      case MoodLevel.good:
        return l10n.moodGood;
      case MoodLevel.neutral:
        return l10n.moodNeutral;
      case MoodLevel.bad:
        return l10n.moodBad;
      case MoodLevel.terrible:
        return l10n.moodTerrible;
    }
  }

  String _getSubEmotionLabel(SubEmotion emotion) {
    final l10n = AppLocalizations.of(context);
    switch (emotion) {
      // Positives
      case SubEmotion.cheerful:
        return l10n.subEmotionCheerful;
      case SubEmotion.hopeful:
        return l10n.subEmotionHopeful;
      case SubEmotion.amazing:
        return l10n.subEmotionAmazing;
      case SubEmotion.peaceful:
        return l10n.subEmotionPeaceful;
      case SubEmotion.confident:
        return l10n.subEmotionConfident;
      case SubEmotion.happy:
        return l10n.subEmotionHappy;
      case SubEmotion.euphoric:
        return l10n.subEmotionEuphoric;
      case SubEmotion.blessed:
        return l10n.subEmotionBlessed;
      case SubEmotion.unstoppable:
        return l10n.subEmotionUnstoppable;
      case SubEmotion.enthusiastic:
        return l10n.subEmotionEnthusiastic;
      case SubEmotion.excited:
        return l10n.subEmotionExcited;
      case SubEmotion.determined:
        return l10n.subEmotionDetermined;
      case SubEmotion.proud:
        return l10n.subEmotionProud;
      case SubEmotion.calm:
        return l10n.subEmotionCalm;
      case SubEmotion.motivated:
        return l10n.subEmotionMotivated;
      case SubEmotion.grateful:
        return l10n.subEmotionGrateful;
      case SubEmotion.loving:
        return l10n.subEmotionLoving;

      // Negatives/Neutrals
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
      case SubEmotion.empty:
        return l10n.subEmotionEmpty;
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
      case SubEmotion.energetic:
        return l10n.subEmotionEnergetic;
    }
  }

  String _getReasonLabel(ReasonCategory reason) {
    final l10n = AppLocalizations.of(context);
    switch (reason) {
      case ReasonCategory.health:
        return l10n.reasonHealth;
      case ReasonCategory.academic:
        return l10n.reasonAcademic;
      case ReasonCategory.work:
        return l10n.reasonWork;
      case ReasonCategory.finance:
        return l10n.reasonFinance;
      case ReasonCategory.relationship:
        return l10n.reasonRelationship;
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
}

class _BouncingTapWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double lowerBound;
  final Duration duration;

  const _BouncingTapWrapper({
    required this.child,
    required this.onTap,
    this.lowerBound = 0.94,
    this.duration = const Duration(milliseconds: 120),
  });

  @override
  State<_BouncingTapWrapper> createState() => _BouncingTapWrapperState();
}

class _BouncingTapWrapperState extends State<_BouncingTapWrapper>
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

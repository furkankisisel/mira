import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/onboarding_result.dart';
import '../domain/character_type.dart';
import '../domain/habit_recommendation.dart';
import '../../habit/domain/habit_model.dart';
import '../../habit/domain/habit_types.dart';
import '../../habit/domain/habit_repository.dart';
import '../../rhythm/presentation/rhythm_teaser_screen.dart';

/// Character result screen showing personality type and habit recommendations
class CharacterResultScreen extends StatefulWidget {
  final OnboardingResult result;

  const CharacterResultScreen({super.key, required this.result});

  @override
  State<CharacterResultScreen> createState() => _CharacterResultScreenState();
}

class _CharacterResultScreenState extends State<CharacterResultScreen> {
  final Set<int> _selectedHabitIndices = {};
  bool _isAdding = false;

  String _dateStr(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Get color based on emoji/category
  Color _getColorForEmoji(String emoji) {
    // Map emojis to colors from the app's color palette
    final emojiColorMap = {
      '☀️': Colors.orange,
      '📊': Colors.blue,
      '🎯': Colors.red,
      '✅': Colors.green,
      '⏰': Colors.purple,
      '📚': Colors.indigo,
      '🎨': Colors.pink,
      '📖': Colors.brown,
      '🎭': Colors.deepPurple,
      '🗺️': Colors.teal,
      '📞': Colors.cyan,
      '👥': Colors.lightBlue,
      '🤲': Colors.amber,
      '👨‍👩‍👧': Colors.deepOrange,
      '💬': Colors.lightGreen,
      '🧘': Colors.purple,
      '🙏': Colors.amber,
      '🌳': Colors.green,
      '🌬️': Colors.lightBlue,
      '✍️': Colors.blueGrey,
    };
    return emojiColorMap[emoji] ?? Colors.blue;
  }

  /// Get IconData based on emoji
  IconData _getIconForEmoji(String emoji) {
    final emojiIconMap = {
      '☀️': Icons.wb_sunny,
      '📊': Icons.bar_chart,
      '🎯': Icons.track_changes,
      '✅': Icons.check_circle,
      '⏰': Icons.access_time,
      '📚': Icons.menu_book,
      '🎨': Icons.palette,
      '📖': Icons.import_contacts,
      '🎭': Icons.theater_comedy,
      '🗺️': Icons.explore,
      '📞': Icons.phone,
      '👥': Icons.group,
      '🤲': Icons.volunteer_activism,
      '👨‍👩‍👧': Icons.family_restroom,
      '💬': Icons.chat_bubble,
      '🧘': Icons.self_improvement,
      '🙏': Icons.spa,
      '🌳': Icons.park,
      '🌬️': Icons.air,
      '✍️': Icons.edit_note,
    };
    return emojiIconMap[emoji] ?? Icons.star;
  }

  String _getCharacterName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (widget.result.characterType.nameKey) {
      case 'characterTypePlanner':
        return l10n.characterTypePlanner;
      case 'characterTypeExplorer':
        return l10n.characterTypeExplorer;
      case 'characterTypeSocialConnector':
        return l10n.characterTypeSocialConnector;
      case 'characterTypeBalancedMindful':
        return l10n.characterTypeBalancedMindful;
      default:
        return widget.result.characterType.nameKey;
    }
  }

  String _getCharacterDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (widget.result.characterType.descriptionKey) {
      case 'characterDescPlanner':
        return l10n.characterDescPlanner;
      case 'characterDescExplorer':
        return l10n.characterDescExplorer;
      case 'characterDescSocialConnector':
        return l10n.characterDescSocialConnector;
      case 'characterDescBalancedMindful':
        return l10n.characterDescBalancedMindful;
      default:
        return widget.result.characterType.descriptionKey;
    }
  }

  String _getHabitName(BuildContext context, String nameKey) {
    final l10n = AppLocalizations.of(context);
    switch (nameKey) {
      case 'habitPlannerMorningRoutine':
        return l10n.habitPlannerMorningRoutine;
      case 'habitPlannerWeeklyReview':
        return l10n.habitPlannerWeeklyReview;
      case 'habitPlannerGoalSetting':
        return l10n.habitPlannerGoalSetting;
      case 'habitPlannerTaskPrioritization':
        return l10n.habitPlannerTaskPrioritization;
      case 'habitPlannerTimeBlocking':
        return l10n.habitPlannerTimeBlocking;
      case 'habitExplorerLearnNewSkill':
        return l10n.habitExplorerLearnNewSkill;
      case 'habitExplorerTryNewActivity':
        return l10n.habitExplorerTryNewActivity;
      case 'habitExplorerReadDiverse':
        return l10n.habitExplorerReadDiverse;
      case 'habitExplorerCreativeProject':
        return l10n.habitExplorerCreativeProject;
      case 'habitExplorerExplorePlace':
        return l10n.habitExplorerExplorePlace;
      case 'habitSocialCallFriend':
        return l10n.habitSocialCallFriend;
      case 'habitSocialGroupActivity':
        return l10n.habitSocialGroupActivity;
      case 'habitSocialVolunteer':
        return l10n.habitSocialVolunteer;
      case 'habitSocialFamilyTime':
        return l10n.habitSocialFamilyTime;
      case 'habitSocialCompliment':
        return l10n.habitSocialCompliment;
      case 'habitMindfulMeditation':
        return l10n.habitMindfulMeditation;
      case 'habitMindfulGratitude':
        return l10n.habitMindfulGratitude;
      case 'habitMindfulNatureWalk':
        return l10n.habitMindfulNatureWalk;
      case 'habitMindfulBreathing':
        return l10n.habitMindfulBreathing;
      case 'habitMindfulJournaling':
        return l10n.habitMindfulJournaling;
      default:
        return nameKey;
    }
  }

  String _getHabitDescription(BuildContext context, String descKey) {
    final l10n = AppLocalizations.of(context);
    switch (descKey) {
      case 'habitPlannerMorningRoutineDesc':
        return l10n.habitPlannerMorningRoutineDesc;
      case 'habitPlannerWeeklyReviewDesc':
        return l10n.habitPlannerWeeklyReviewDesc;
      case 'habitPlannerGoalSettingDesc':
        return l10n.habitPlannerGoalSettingDesc;
      case 'habitPlannerTaskPrioritizationDesc':
        return l10n.habitPlannerTaskPrioritizationDesc;
      case 'habitPlannerTimeBlockingDesc':
        return l10n.habitPlannerTimeBlockingDesc;
      case 'habitExplorerLearnNewSkillDesc':
        return l10n.habitExplorerLearnNewSkillDesc;
      case 'habitExplorerTryNewActivityDesc':
        return l10n.habitExplorerTryNewActivityDesc;
      case 'habitExplorerReadDiverseDesc':
        return l10n.habitExplorerReadDiverseDesc;
      case 'habitExplorerCreativeProjectDesc':
        return l10n.habitExplorerCreativeProjectDesc;
      case 'habitExplorerExplorePlaceDesc':
        return l10n.habitExplorerExplorePlaceDesc;
      case 'habitSocialCallFriendDesc':
        return l10n.habitSocialCallFriendDesc;
      case 'habitSocialGroupActivityDesc':
        return l10n.habitSocialGroupActivityDesc;
      case 'habitSocialVolunteerDesc':
        return l10n.habitSocialVolunteerDesc;
      case 'habitSocialFamilyTimeDesc':
        return l10n.habitSocialFamilyTimeDesc;
      case 'habitSocialComplimentDesc':
        return l10n.habitSocialComplimentDesc;
      case 'habitMindfulMeditationDesc':
        return l10n.habitMindfulMeditationDesc;
      case 'habitMindfulGratitudeDesc':
        return l10n.habitMindfulGratitudeDesc;
      case 'habitMindfulNatureWalkDesc':
        return l10n.habitMindfulNatureWalkDesc;
      case 'habitMindfulBreathingDesc':
        return l10n.habitMindfulBreathingDesc;
      case 'habitMindfulJournalingDesc':
        return l10n.habitMindfulJournalingDesc;
      default:
        return descKey;
    }
  }

  Future<void> _addSelectedHabits() async {
    if (_selectedHabitIndices.isEmpty) {
      // Navigate to home without adding habits
      _navigateToHome();
      return;
    }

    setState(() {
      _isAdding = true;
    });

    try {
      final recommendations = HabitRecommendations.getRecommendations(
        widget.result.characterType,
      );
      final repository = HabitRepository.instance;

      for (final index in _selectedHabitIndices) {
        if (index < recommendations.length) {
          final recommendation = recommendations[index];
          final habitName = _getHabitName(context, recommendation.nameKey);
          final habitEmoji = recommendation.icon;
          final habitColor = _getColorForEmoji(habitEmoji);
          final habitIcon = _getIconForEmoji(habitEmoji);

          // Create habit from recommendation using existing repository method
          // The repository will handle all the required fields
          final habit = Habit(
            id: '${DateTime.now().millisecondsSinceEpoch}_$index',
            title: habitName,
            description: _getHabitDescription(
              context,
              recommendation.descriptionKey,
            ),
            icon: habitIcon,
            emoji: habitEmoji,
            color: habitColor,
            targetCount: 1,
            habitType: HabitType.simple,
            unit: null,
            frequency: recommendation.frequency,
            currentStreak: 0,
            isCompleted: false,
            progressDate: _dateStr(DateTime.now()),
            startDate: _dateStr(DateTime.now()),
          );

          await repository.addHabit(habit);
        }
      }

      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.habitAddSuccess(_selectedHabitIndices.length)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.habitAddError('$e')),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      setState(() {
        _isAdding = false;
      });
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    // Navigate to Rhythm Teaser screen after personality test
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const RhythmTeaserScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final recommendations = HabitRecommendations.getRecommendations(
      widget.result.characterType,
    );

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Character type header
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(32, 48, 32, 40),
                color: theme.colorScheme.surface,
                child: Column(
                  children: [
                    // Label badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        l10n.yourCharacterType,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Character emoji with animation
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                widget.result.characterType.emoji,
                                style: const TextStyle(fontSize: 64),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Character name
                    Text(
                      _getCharacterName(context),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    // Character description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _getCharacterDescription(context),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Recommended habits section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: theme.colorScheme.onPrimaryContainer,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.recommendedHabits,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.selectHabitsToAdd,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Habit list
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final recommendation = recommendations[index];
                  final isSelected = _selectedHabitIndices.contains(index);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedHabitIndices.remove(index);
                          } else {
                            _selectedHabitIndices.add(index);
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            // Icon
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? theme.colorScheme.primaryContainer
                                    : theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                recommendation.icon,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),

                            const SizedBox(width: 14),

                            // Name and description
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getHabitName(
                                      context,
                                      recommendation.nameKey,
                                    ),
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _getHabitDescription(
                                      context,
                                      recommendation.descriptionKey,
                                    ),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                      height: 1.3,
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Check indicator
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.surfaceContainerHighest,
                                shape: BoxShape.circle,
                              ),
                              child: isSelected
                                  ? Icon(
                                      Icons.check_rounded,
                                      size: 14,
                                      color: theme.colorScheme.onPrimary,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }, childCount: recommendations.length),
              ),
            ),

            // Bottom spacing
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),

      // Bottom action button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: FilledButton.icon(
            onPressed: _isAdding ? null : _addSelectedHabits,
            icon: _isAdding
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : _selectedHabitIndices.isNotEmpty
                    ? const Icon(Icons.rocket_launch_rounded, size: 20)
                    : const Icon(Icons.skip_next_rounded, size: 20),
            label: Text(
              _selectedHabitIndices.isEmpty
                  ? l10n.skipOnboarding
                  : '${l10n.startJourney} (${_selectedHabitIndices.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

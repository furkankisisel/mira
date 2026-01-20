import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/rhythm_questions.dart';
import '../domain/rhythm_question.dart';
import '../domain/rhythm_analyzer_service.dart';
import '../domain/live_rhythm_repository.dart';

/// Rhythm onboarding screen with 11 biological clock questions
/// Only shown to premium users
class RhythmOnboardingScreen extends StatefulWidget {
  const RhythmOnboardingScreen({super.key});

  @override
  State<RhythmOnboardingScreen> createState() => _RhythmOnboardingScreenState();
}

class _RhythmOnboardingScreenState extends State<RhythmOnboardingScreen> {
  int _currentQuestionIndex = 0;
  final Map<String, int> _answers = {};
  bool _isAnalyzing = false;

  List<RhythmQuestion> get _questions => RhythmQuestions.questions;

  RhythmQuestion get _currentQuestion => _questions[_currentQuestionIndex];

  double get _progress => (_currentQuestionIndex + 1) / _questions.length;

  void _selectAnswer(int answerIndex) {
    setState(() {
      _answers[_currentQuestion.id] = answerIndex;
    });

    // Auto-advance after selection with small delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _finishOnboarding();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  Future<void> _finishOnboarding() async {
    setState(() => _isAnalyzing = true);

    try {
      // Analyze answers and create rhythm profile
      final analyzer = RhythmAnalyzerService();
      final profile = analyzer.analyze(_answers);

      // Save profile
      await LiveRhythmRepository.instance.saveProfile(profile);

      if (mounted) {
        // Navigate to home
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    }
  }

  String _getQuestionText(BuildContext context, RhythmQuestion question) {
    final l10n = AppLocalizations.of(context);
    switch (question.id) {
      case 'sleep_time':
        return l10n.rhythmQ1;
      case 'wake_time':
        return l10n.rhythmQ2;
      case 'hard_work_time':
        return l10n.rhythmQ3;
      case 'learning_clarity':
        return l10n.rhythmQ4;
      case 'energy_peak':
        return l10n.rhythmQ5;
      case 'exercise_ease':
        return l10n.rhythmQ6;
      case 'procrastination_time':
        return l10n.rhythmQ7;
      case 'low_energy_behavior':
        return l10n.rhythmQ8;
      case 'evening_activity':
        return l10n.rhythmQ9;
      case 'evening_mind':
        return l10n.rhythmQ10;
      case 'chrono_type':
        return l10n.rhythmQ11;
      default:
        return question.questionKey;
    }
  }

  List<String> _getAnswerTexts(BuildContext context, RhythmQuestion question) {
    final l10n = AppLocalizations.of(context);
    switch (question.id) {
      case 'sleep_time':
        return [
          l10n.rhythmA1_1,
          l10n.rhythmA1_2,
          l10n.rhythmA1_3,
          l10n.rhythmA1_4,
        ];
      case 'wake_time':
        return [
          l10n.rhythmA2_1,
          l10n.rhythmA2_2,
          l10n.rhythmA2_3,
          l10n.rhythmA2_4,
        ];
      case 'hard_work_time':
        return [
          l10n.rhythmA3_1,
          l10n.rhythmA3_2,
          l10n.rhythmA3_3,
          l10n.rhythmA3_4,
          l10n.rhythmA3_5,
        ];
      case 'learning_clarity':
        return [
          l10n.rhythmA4_1,
          l10n.rhythmA4_2,
          l10n.rhythmA4_3,
          l10n.rhythmA4_4,
          l10n.rhythmA4_5,
        ];
      case 'energy_peak':
        return [
          l10n.rhythmA5_1,
          l10n.rhythmA5_2,
          l10n.rhythmA5_3,
          l10n.rhythmA5_4,
          l10n.rhythmA5_5,
        ];
      case 'exercise_ease':
        return [
          l10n.rhythmA6_1,
          l10n.rhythmA6_2,
          l10n.rhythmA6_3,
          l10n.rhythmA6_4,
        ];
      case 'procrastination_time':
        return [
          l10n.rhythmA7_1,
          l10n.rhythmA7_2,
          l10n.rhythmA7_3,
          l10n.rhythmA7_4,
        ];
      case 'low_energy_behavior':
        return [
          l10n.rhythmA8_1,
          l10n.rhythmA8_2,
          l10n.rhythmA8_3,
          l10n.rhythmA8_4,
        ];
      case 'evening_activity':
        return [
          l10n.rhythmA9_1,
          l10n.rhythmA9_2,
          l10n.rhythmA9_3,
          l10n.rhythmA9_4,
        ];
      case 'evening_mind':
        return [
          l10n.rhythmA10_1,
          l10n.rhythmA10_2,
          l10n.rhythmA10_3,
          l10n.rhythmA10_4,
        ];
      case 'chrono_type':
        return [
          l10n.rhythmA11_1,
          l10n.rhythmA11_2,
          l10n.rhythmA11_3,
          l10n.rhythmA11_4,
        ];
      default:
        return question.answerKeys;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final colorScheme = theme.colorScheme;

    if (_isAnalyzing) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                l10n.rhythmAnalyzing,
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
    }

    final answerTexts = _getAnswerTexts(context, _currentQuestion);
    final selectedAnswer = _answers[_currentQuestion.id];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentQuestionIndex > 0
            ? IconButton(
                onPressed: _previousQuestion,
                icon: const Icon(Icons.arrow_back_rounded),
              )
            : null,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: Text(l10n.rhythmTeaserSkip),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),

              const SizedBox(height: 8),

              // Question counter
              Text(
                '${_currentQuestionIndex + 1} / ${_questions.length}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 24),

              // Disclaimer on first question
              if (_currentQuestionIndex == 0)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.rhythmDisclaimer,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Question text
              Text(
                _getQuestionText(context, _currentQuestion),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 32),

              // Answer options
              Expanded(
                child: ListView.separated(
                  itemCount: answerTexts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final isSelected = selectedAnswer == index;
                    return InkWell(
                      onTap: () => _selectAnswer(index),
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primaryContainer
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                answerTexts[index],
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? colorScheme.onPrimaryContainer
                                      : colorScheme.onSurface,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle_rounded,
                                color: colorScheme.primary,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

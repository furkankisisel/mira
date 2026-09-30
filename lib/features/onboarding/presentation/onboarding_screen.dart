import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/onboarding_question.dart';
import '../domain/onboarding_result.dart';
import '../data/onboarding_repository.dart';
import '../../habit/data/server_ai_habit_service.dart';
import 'ai_character_result_screen.dart';
import '../../../core/config/api_config.dart';
import 'onboarding_story_widgets.dart';
import '../domain/starter_plan.dart';
import '../../vision/domain/ai_vision_dto.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen(
      {super.key, this.isRetake = false, this.showWelcome = true});
  final bool isRetake;
  final bool showWelcome;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final Map<String, int> _answers = {};
  late int _currentPage = widget.showWelcome ? 0 : 1;
  bool _busy = false;
  bool _transitioning = false;
  bool _backwards = false;
  static const _stories = [
    OnboardingStory.vision,
    OnboardingStory.routine,
    OnboardingStory.connection,
    OnboardingStory.connection,
    OnboardingStory.balance,
    OnboardingStory.vision,
    OnboardingStory.routine,
    OnboardingStory.connection,
    OnboardingStory.balance,
    OnboardingStory.routine,
    OnboardingStory.vision,
    OnboardingStory.balance,
  ];

  Future<void> _goTo(int page) async {
    if (_busy ||
        _transitioning ||
        page < 0 ||
        page > OnboardingQuestions.questions.length) return;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    setState(() {
      _backwards = page < _currentPage;
      _currentPage = page;
      _transitioning = true;
    });
    await Future<void>.delayed(Duration(milliseconds: reduceMotion ? 0 : 360));
    if (mounted) setState(() => _transitioning = false);
  }

  void _back() {
    if (_busy || _transitioning) return;
    if (_currentPage == 1 && !widget.showWelcome) {
      Navigator.of(context).maybePop();
    } else {
      _goTo(_currentPage - 1);
    }
  }

  String _getQuestionText(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context);
    switch (key) {
      case 'onboardingQ1':
        return l10n.onboardingQ1;
      case 'onboardingQ2':
        return l10n.onboardingQ2;
      case 'onboardingQ3':
        return l10n.onboardingQ3;
      case 'onboardingQ4':
        return l10n.onboardingQ4;
      case 'onboardingQ5':
        return l10n.onboardingQ5;
      case 'onboardingQ6':
        return l10n.onboardingQ6;
      case 'onboardingQ7':
        return l10n.onboardingQ7;
      case 'onboardingQ8':
        return l10n.onboardingQ8;
      case 'onboardingQ9':
        return l10n.onboardingQ9;
      case 'onboardingQ10':
        return l10n.onboardingQ10;
      case 'onboardingQ11':
        return l10n.onboardingQ11;
      case 'onboardingQ12':
        return l10n.onboardingQ12;
      default:
        return key;
    }
  }

  String _getAnswerText(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context);
    switch (key) {
      case 'likertStronglyDisagree':
        return l10n.likertStronglyDisagree;
      case 'likertDisagree':
        return l10n.likertDisagree;
      case 'likertNeutral':
        return l10n.likertNeutral;
      case 'likertAgree':
        return l10n.likertAgree;
      case 'likertStronglyAgree':
        return l10n.likertStronglyAgree;
      default:
        return key;
    }
  }

  Future<void> _finishOnboarding() async {
    if (_busy || _answers.length != OnboardingQuestions.questions.length)
      return;
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    setState(() => _busy = true);
    try {
      final buffer =
          StringBuffer('Analyze the following personality test answers:\n');
      for (final question in OnboardingQuestions.questions) {
        final answerIndex = _answers[question.id]!;
        buffer.writeln('Q: ${_getQuestionText(context, question.questionKey)}');
        buffer.writeln(
            'A: ${_getAnswerText(context, question.answerKeys[answerIndex])}');
        buffer.writeln();
      }
      final starter = StarterPlan.build(
        OnboardingQuestions.questions.map((q) => _answers[q.id]!).toList(),
        languageCode: languageCode,
      );
      var aiPdf = AiVisionDto.tryFromJson(starter)!;
      var usesStarterPlan = true;
      if (ApiConfig.isGroqConfigured) {
        try {
          final service = ServerAiHabitService(apiKey: ApiConfig.groqApiKey);
          aiPdf = await service.analyzePersonality(
            '${buffer.toString()}\nAnswer-based starter plan:\n${jsonEncode(starter)}',
            languageCode: languageCode,
          );
          usesStarterPlan = false;
        } catch (_) {
          // A missing connection, timeout or invalid response must not lose answers.
          // Show the answer-based local plan and identify its source in the UI.
        }
      }
      final traitScores = OnboardingResult.calculateTraitScores(
          OnboardingQuestions.questions, _answers);
      await OnboardingRepository().saveOnboardingResult(OnboardingResult(
        characterType: OnboardingResult.calculateCharacterType(traitScores),
        traitScores: traitScores,
        completedAt: DateTime.now(),
      ));
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => AiCharacterResultScreen(
            result: aiPdf, usesStarterPlan: usesStarterPlan),
      ));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.onboardingStoryError)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = OnboardingPalette(context);
    final l10n = AppLocalizations.of(context);
    final firstPage = widget.showWelcome ? 0 : 1;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return PopScope(
      canPop: !_busy && !_transitioning && _currentPage == firstPage,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !_busy) _back();
      },
      child: _currentPage == 0
          ? OnboardingWelcome(onStart: () => _goTo(1))
          : Scaffold(
              backgroundColor: palette.background,
              body: SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 24, 0),
                          child: Row(children: [
                            IconButton(
                              tooltip: l10n.back,
                              onPressed: _busy || _transitioning ? null : _back,
                              icon: Icon(Icons.arrow_back_rounded,
                                  color: palette.ink),
                            ),
                            const Spacer(),
                            Text('mira',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -.8,
                                    color: palette.ink)),
                            const Spacer(),
                            Text(
                                '${_currentPage.toString().padLeft(2, '0')} / ${OnboardingQuestions.questions.length}',
                                style: TextStyle(
                                    fontSize: 12, color: palette.muted)),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(28, 8, 28, 4),
                          child: Semantics(
                            value:
                                '$_currentPage / ${OnboardingQuestions.questions.length}',
                            child: Row(
                                children: List.generate(
                                    OnboardingQuestions.questions.length,
                                    (i) => Expanded(
                                          child: AnimatedContainer(
                                            duration: Duration(
                                                milliseconds:
                                                    reduceMotion ? 0 : 250),
                                            height: 3,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: i < _currentPage
                                                  ? palette.accent
                                                  : palette.line,
                                            ),
                                          ),
                                        ))),
                          ),
                        ),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration:
                                Duration(milliseconds: reduceMotion ? 0 : 350),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                        begin:
                                            Offset(_backwards ? -.06 : .06, 0),
                                        end: Offset.zero)
                                    .animate(animation),
                                child: child,
                              ),
                            ),
                            child: _questionBody(context,
                                key: ValueKey(_currentPage)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(28, 10, 28, 20),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            if (_busy) ...[
                              Text(l10n.onboardingStoryLoading,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: palette.muted, fontSize: 13)),
                              const SizedBox(height: 12),
                            ],
                            OnboardingAction(
                              label: _currentPage ==
                                      OnboardingQuestions.questions.length
                                  ? l10n.onboardingStoryResult
                                  : l10n.continueButton,
                              busy: _busy,
                              onPressed: _transitioning ||
                                      !_answers.containsKey(OnboardingQuestions
                                          .questions[_currentPage - 1].id)
                                  ? null
                                  : () {
                                      if (_currentPage ==
                                          OnboardingQuestions
                                              .questions.length) {
                                        _finishOnboarding();
                                      } else {
                                        _goTo(_currentPage + 1);
                                      }
                                    },
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _questionBody(BuildContext context, {required Key key}) {
    final palette = OnboardingPalette(context);
    final l10n = AppLocalizations.of(context);
    final index = _currentPage - 1;
    final question = OnboardingQuestions.questions[index];
    final story = _stories[index];
    return LayoutBuilder(
      key: key,
      builder: (context, constraints) => SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.fromLTRB(28, 0, 28, 12),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          OnboardingScene(
              story: story,
              height: (constraints.maxHeight * .32).clamp(140, 230)),
          Text(story.title(l10n),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  height: 1.2,
                  letterSpacing: -.6,
                  fontWeight: FontWeight.w600,
                  color: palette.ink)),
          const SizedBox(height: 8),
          Text(story.body(l10n),
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 13, height: 1.5, color: palette.muted)),
          const SizedBox(height: 20),
          Divider(height: 1, color: palette.line),
          const SizedBox(height: 18),
          Text(_getQuestionText(context, question.questionKey),
              style: TextStyle(
                  fontSize: 17,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: palette.ink)),
          const SizedBox(height: 6),
          Text(l10n.onboardingStoryAnswerHint,
              style: TextStyle(fontSize: 12, color: palette.muted)),
          const SizedBox(height: 14),
          OnboardingAnswerScale(
            questionId: question.id,
            answers: question.answerKeys
                .map((key) => _getAnswerText(context, key))
                .toList(),
            selected: _answers[question.id],
            onSelected: _busy || _transitioning
                ? null
                : (answerIndex) {
                    HapticFeedback.selectionClick();
                    setState(() => _answers[question.id] = answerIndex);
                  },
          ),
        ]),
      ),
    );
  }
}

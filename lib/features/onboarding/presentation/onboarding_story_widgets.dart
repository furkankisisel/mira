import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// The same editorial scenes introduce Mira and accompany related questions.
enum OnboardingStory { vision, routine, connection, balance }

extension OnboardingStoryContent on OnboardingStory {
  String get asset => 'assets/images/onboarding_${name}_v2.png';

  String title(AppLocalizations l10n) => switch (this) {
        OnboardingStory.vision => l10n.onboardingStoryVisionTitle,
        OnboardingStory.routine => l10n.onboardingStoryRoutineTitle,
        OnboardingStory.connection => l10n.onboardingStoryConnectionTitle,
        OnboardingStory.balance => l10n.onboardingStoryBalanceTitle,
      };

  String body(AppLocalizations l10n) => switch (this) {
        OnboardingStory.vision => l10n.onboardingStoryVisionBody,
        OnboardingStory.routine => l10n.onboardingStoryRoutineBody,
        OnboardingStory.connection => l10n.onboardingStoryConnectionBody,
        OnboardingStory.balance => l10n.onboardingStoryBalanceBody,
      };

  IconData get icon => switch (this) {
        OnboardingStory.vision => Icons.auto_awesome_outlined,
        OnboardingStory.routine => Icons.check_rounded,
        OnboardingStory.connection => Icons.people_outline_rounded,
        OnboardingStory.balance => Icons.favorite_border_rounded,
      };
}

class OnboardingPalette {
  OnboardingPalette(BuildContext context)
      : dark = Theme.of(context).brightness == Brightness.dark;
  final bool dark;
  Color get background =>
      dark ? const Color(0xFF1D2423) : const Color(0xFFF8FAF9);
  Color get ink => dark ? const Color(0xFFF0F2ED) : const Color(0xFF252C29);
  Color get muted => dark ? const Color(0xFFB3BDB7) : const Color(0xFF717A74);
  Color get line => dark ? const Color(0xFF3D4741) : const Color(0xFFE2E7E2);
  Color get selected =>
      dark ? const Color(0xFF3C4A3F) : const Color(0xFFE9EFE6);
  Color get accent => dark ? const Color(0xFFC5D6B9) : const Color(0xFF5C7355);
}

class OnboardingScene extends StatefulWidget {
  const OnboardingScene({super.key, required this.story, required this.height});
  final OnboardingStory story;
  final double height;

  @override
  State<OnboardingScene> createState() => _OnboardingSceneState();
}

class _OnboardingSceneState extends State<OnboardingScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _float.stop();
      _float.value = 0;
    } else if (!_float.isAnimating) {
      _float.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = OnboardingPalette(context);
    return ExcludeSemantics(
      child: SizedBox(
        height: widget.height,
        child: Center(
          child: SizedBox(
            width: widget.height * 1.2,
            child: AnimatedBuilder(
              animation: _float,
              builder: (context, child) => Transform.translate(
                offset:
                    Offset(0, -4 * Curves.easeInOut.transform(_float.value)),
                child: child,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    widget.story.asset,
                    fit: BoxFit.contain,
                    height: widget.height,
                    cacheWidth: 640,
                    gaplessPlayback: true,
                  ),
                  PositionedDirectional(
                    top: widget.height * .16,
                    end: widget.height * .08,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: palette.background,
                        shape: BoxShape.circle,
                        border: Border.all(color: palette.line),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(11),
                        child: Icon(widget.story.icon,
                            color: palette.accent, size: 21),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingAnswerScale extends StatelessWidget {
  const OnboardingAnswerScale(
      {super.key,
      required this.questionId,
      required this.answers,
      required this.selected,
      required this.onSelected});
  final String questionId;
  final List<String> answers;
  final int? selected;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    final palette = OnboardingPalette(context);
    return Column(children: [
      Row(
          children: List.generate(answers.length, (index) {
        final active = selected == index;
        return Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(
                end: index == answers.length - 1 ? 0 : 4),
            child: Semantics(
              label: answers[index],
              enabled: onSelected != null,
              onTap: onSelected == null ? null : () => onSelected!(index),
              selected: active,
              inMutuallyExclusiveGroup: true,
              button: true,
              child: ExcludeSemantics(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: ValueKey('answer_${questionId}_$index'),
                    onTap: onSelected == null ? null : () => onSelected!(index),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: Duration(
                          milliseconds: MediaQuery.disableAnimationsOf(context)
                              ? 0
                              : 180),
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(minHeight: 54),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: active
                            ? palette.ink
                            : palette.selected.withValues(alpha: .4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: active ? palette.ink : palette.line),
                      ),
                      child: Text('${index + 1}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color:
                                  active ? palette.background : palette.ink)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      })),
      const SizedBox(height: 9),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
            child: Text(answers.first,
                style: TextStyle(
                    color: palette.muted, fontSize: 11, height: 1.4))),
        const SizedBox(width: 44),
        Expanded(
            child: Text(answers.last,
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: palette.muted, fontSize: 11, height: 1.4))),
      ]),
      const SizedBox(height: 12),
      Semantics(
        liveRegion: true,
        child: Text(selected == null ? '—' : answers[selected!],
            textAlign: TextAlign.center,
            style: TextStyle(
                color: palette.accent,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
      ),
    ]);
  }
}

class OnboardingAction extends StatelessWidget {
  const OnboardingAction(
      {super.key, required this.label, this.onPressed, this.busy = false});
  final String label;
  final VoidCallback? onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final palette = OnboardingPalette(context);
    return FilledButton(
      onPressed: busy ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: palette.ink,
        foregroundColor: palette.background,
        disabledBackgroundColor: palette.line,
        disabledForegroundColor: palette.muted,
        minimumSize: const Size(double.infinity, 54),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      child: busy
          ? SizedBox(
              width: 20,
              height: 20,
              child:
                  CircularProgressIndicator(strokeWidth: 2, color: palette.ink))
          : Text(label, textAlign: TextAlign.center),
    );
  }
}

/// Shared entry point for first launch and for retaking the questionnaire.
class OnboardingWelcome extends StatelessWidget {
  const OnboardingWelcome({super.key, required this.onStart, this.onSkip});
  final VoidCallback onStart;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final palette = OnboardingPalette(context);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
                  child: Row(children: [
                    Text('mira',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1,
                            color: palette.ink)),
                    const Spacer(),
                    if (onSkip != null)
                      TextButton(
                          onPressed: onSkip,
                          child: Text(l10n.skipTest,
                              style: TextStyle(color: palette.muted))),
                  ]),
                ),
                Expanded(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: (constraints.maxHeight - 24)
                                .clamp(0, double.infinity)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OnboardingScene(
                                story: OnboardingStory.vision,
                                height: (constraints.maxHeight * .49)
                                    .clamp(180, 300)),
                            const SizedBox(height: 22),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                    3,
                                    (index) => Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          width: index == 0 ? 20 : 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                              color: index == 0
                                                  ? palette.ink
                                                  : palette.line,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ))),
                            const SizedBox(height: 22),
                            Text(l10n.onboardingStoryWelcomeTitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 29,
                                    height: 1.22,
                                    letterSpacing: -.8,
                                    fontWeight: FontWeight.w600,
                                    color: palette.ink)),
                            const SizedBox(height: 16),
                            Text(l10n.onboardingStoryWelcomeBody,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    height: 1.65,
                                    color: palette.muted)),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
                  child: Column(children: [
                    Text(l10n.onboardingStoryNote,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: palette.muted)),
                    const SizedBox(height: 18),
                    OnboardingAction(
                        label: l10n.startJourney, onPressed: onStart),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

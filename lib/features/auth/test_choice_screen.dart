import 'package:flutter/material.dart';
import '../onboarding/presentation/onboarding_screen.dart';
import '../onboarding/data/onboarding_repository.dart';
import '../onboarding/presentation/onboarding_story_widgets.dart';

/// Screen shown after successful sign-in to choose whether to start the test or skip it.
class TestChoiceScreen extends StatelessWidget {
  const TestChoiceScreen({super.key, this.onSkip, this.onStart});

  final VoidCallback? onSkip;
  final VoidCallback? onStart;

  Future<void> _skipTest(BuildContext context) async {
    await OnboardingRepository().setOnboardingCompleted(true);
    onSkip?.call();
  }

  void _startTest(BuildContext context) {
    onStart?.call();
    Navigator.of(
      context,
    ).push(MaterialPageRoute(
        builder: (_) => const OnboardingScreen(showWelcome: false)));
  }

  @override
  Widget build(BuildContext context) => OnboardingWelcome(
        onStart: () => _startTest(context),
        onSkip: () => _skipTest(context),
      );
}

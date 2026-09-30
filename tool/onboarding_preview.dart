import 'package:flutter/material.dart';
import 'package:mira/features/onboarding/presentation/onboarding_screen.dart';
import 'package:mira/l10n/app_localizations.dart';

/// Standalone visual preview: no sign-in, backend call, or saved state is needed.
void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('tr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(useMaterial3: true),
      home: const OnboardingScreen(),
    ));

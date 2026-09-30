import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mira/features/onboarding/presentation/onboarding_screen.dart';
import 'package:mira/features/onboarding/presentation/onboarding_story_widgets.dart';
import 'package:mira/l10n/app_localizations.dart';

const _preview = bool.fromEnvironment('ONBOARDING_PREVIEW');
final _boundary = GlobalKey();

Future<void> _mount(WidgetTester tester,
    {bool welcome = false,
    bool dark = false,
    double textScale = 1,
    Size size = const Size(390, 844)}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  if (_preview) {
    final bytes = File('C:/Windows/Fonts/segoeui.ttf').readAsBytesSync();
    await (FontLoader('PreviewSans')
          ..addFont(Future.value(ByteData.sublistView(bytes))))
        .load();
  }
  await tester.pumpWidget(MaterialApp(
    locale: const Locale('tr'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData(
        brightness: dark ? Brightness.dark : Brightness.light,
        fontFamily: _preview ? 'PreviewSans' : null),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
          disableAnimations: true, textScaler: TextScaler.linear(textScale)),
      child: RepaintBoundary(key: _boundary, child: child!),
    ),
    home: OnboardingScreen(showWelcome: welcome),
  ));
  await tester.pumpAndSettle();
}

Future<void> _capture(WidgetTester tester, String name) async {
  if (!_preview) return;
  // Decode each visible asset before capturing the actual Flutter layout.
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      final widget = element.widget as Image;
      await precacheImage(widget.image, element);
    }
  });
  await tester.pumpAndSettle();
  final render =
      _boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  await tester.runAsync(() async {
    final image = await render.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    await File('docs/screenshots/onboarding-v2-$name.png')
        .writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

FilledButton _next(WidgetTester tester) =>
    tester.widget<FilledButton>(find.byType(FilledButton).last);

Future<void> _answer(WidgetTester tester, int index) async {
  final scale =
      tester.widget<OnboardingAnswerScale>(find.byType(OnboardingAnswerScale));
  final option = find.byKey(ValueKey('answer_${scale.questionId}_$index'));
  await tester.ensureVisible(option);
  await tester.tap(option);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('welcome opens the illustrated test without overflow',
      (tester) async {
    await _mount(tester, welcome: true);
    expect(tester.takeException(), isNull);
    await _capture(tester, 'welcome');
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingAnswerScale), findsOneWidget);
    expect(_next(tester).onPressed, isNull);
  });

  testWidgets(
      'answers require confirmation, survive back, and rapid next cannot skip a question',
      (tester) async {
    await _mount(tester);
    expect(_next(tester).onPressed, isNull);
    await _answer(tester, 3);
    expect(
        tester
            .widget<OnboardingAnswerScale>(find.byType(OnboardingAnswerScale))
            .selected,
        3);
    final advance = _next(tester).onPressed!;
    advance();
    advance();
    await tester.pumpAndSettle();
    expect(find.text('02 / 12'), findsOneWidget);
    expect(_next(tester).onPressed, isNull);
    await _capture(tester, 'routine');
    await tester.tap(find.byTooltip('Geri'));
    await tester.pumpAndSettle();
    expect(find.text('01 / 12'), findsOneWidget);
    expect(
        tester
            .widget<OnboardingAnswerScale>(find.byType(OnboardingAnswerScale))
            .selected,
        3);
  });

  testWidgets('all twelve steps map to scenes and final action needs an answer',
      (tester) async {
    await _mount(tester);
    for (var step = 1; step <= 12; step++) {
      expect(
          find.text('${step.toString().padLeft(2, '0')} / 12'), findsOneWidget);
      expect(_next(tester).onPressed, isNull);
      if (step == 5) await _capture(tester, 'balance');
      await _answer(tester, 2);
      expect(_next(tester).onPressed, isNotNull);
      if (step < 12) {
        await tester.tap(find.byType(FilledButton));
        await tester.pumpAndSettle();
      }
    }
    expect(find.text('Kendimi keşfet'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'small dark screen with large text remains scrollable and actionable',
      (tester) async {
    await _mount(tester,
        dark: true, textScale: 1.6, size: const Size(320, 640));
    expect(tester.takeException(), isNull);
    await _answer(tester, 4);
    expect(_next(tester).onPressed, isNotNull);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.text('02 / 12'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

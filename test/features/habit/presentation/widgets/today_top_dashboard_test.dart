import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mira/features/habit/presentation/widgets/today_top_dashboard.dart';
import 'package:mira/features/vision/data/vision_model.dart';
import 'package:mira/features/vision/data/vision_repository.dart';
import 'package:mira/l10n/app_localizations.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('TodayTopDashboard renders Vision card with image and Notebook cover',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    // Setup test vision with cover image
    final testVision = Vision(
      id: 'test_vision_1',
      title: 'Fitness Goals',
      colorValue: Colors.indigo.value,
      linkedHabitIds: [],
      createdAt: DateTime.now(),
      coverImage: 'assets/images/placeholder.png',
    );
    await VisionRepository.instance.add(testVision);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('tr'),
        home: Scaffold(
          body: TodayTopDashboard(date: DateTime.now()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Verify Vision card displays title
    expect(find.text('Fitness Goals'), findsOneWidget);

    // 2. Verify Notebook Cover is displayed initially with "GÜNLÜK GÖREV" and "Açmak için dokun"
    expect(find.text('GÜNLÜK GÖREV'), findsOneWidget);
    expect(find.text('Açmak için dokun'), findsOneWidget);

    // 3. Tap notebook cover to open
    await tester.tap(find.text('GÜNLÜK GÖREV'));
    await tester.pumpAndSettle();

    // 4. Verify inside notebook is revealed and close cover button exists
    expect(find.byIcon(Icons.menu_book_rounded), findsOneWidget);

    // 5. Tap close cover button to fold the notebook shut
    await tester.tap(find.byIcon(Icons.menu_book_rounded));
    await tester.pumpAndSettle();

    // 6. Verify cover is shut again
    expect(find.text('GÜNLÜK GÖREV'), findsOneWidget);
    expect(find.text('Açmak için dokun'), findsOneWidget);
  });

  testWidgets('TodayTopDashboard renders Notebook cover in English',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: TodayTopDashboard(date: DateTime.now()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify English text on Notebook cover
    expect(find.text('DAILY TASK'), findsOneWidget);
    expect(find.text('Tap to open'), findsOneWidget);
  });
}

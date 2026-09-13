import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mira/features/habit/presentation/simple_habit_screen.dart';
import 'package:mira/features/habit/domain/habit_model.dart';
import 'package:mira/providers/premium_provider.dart';
import 'package:mira/l10n/app_localizations.dart';

class MockPremiumProvider extends ChangeNotifier implements PremiumProvider {
  @override
  bool get isPremium => false;

  @override
  bool get isLoading => false;

  @override
  Future<void> loadPremiumStatus() async {}

  @override
  Future<void> refreshPremium() async {}

  @override
  void reset() {}
}

void main() {
  testWidgets('Weekly frequency config generates correct scheduledDates', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    SharedPreferences.setMockInitialValues({});
    final results = <dynamic>[];

    await tester.pumpWidget(
      ChangeNotifierProvider<PremiumProvider>(
        create: (_) => MockPremiumProvider(),
        child: MaterialApp(
          locale: const Locale('tr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final res = await Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (_) => const SimpleHabitScreen(),
                          ),
                        );
                    if (res != null) results.add(res);
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Open the create habit screen
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Fill required title field
    final titleField = find.byType(TextField).first;
    expect(titleField, findsOneWidget);
    await tester.enterText(titleField, 'Test Weekly Habit');
    await tester.pump();

    // Select weekly option
    await tester.tap(find.text('Haftalık'));
    await tester.pumpAndSettle();

    // Pick specific weekdays: Monday (1. gün) and Wednesday (3. gün)
    final days = AppLocalizations.of(tester.element(find.byType(SimpleHabitScreen))).weekDaysShort.split(',');
    await tester.tap(find.text(days[0])); // Mon
    await tester.pump();
    await tester.tap(find.text(days[2])); // Wed
    await tester.pumpAndSettle();

    // Submit: scroll until 'Alışkanlık Oluştur' button is visible and tap
    final saveButtonText = AppLocalizations.of(tester.element(find.byType(SimpleHabitScreen))).createHabit;
    final submitButton = find.text(saveButtonText);
    await tester.scrollUntilVisible(
      submitButton,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(submitButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    // Validate result captured from Navigator.pop
    expect(results, isNotEmpty);
    final res = results.first as Habit;

    expect(res.frequency, 'weekly');
    expect(
      res.frequencyType?.toLowerCase() ?? '',
      contains('specificweekdays'),
    );
    // Mon=1, Wed=3
    expect(res.selectedWeekdays, containsAll([1, 3]));

    // scheduledDates should be a non-empty List<String>
    final dates = res.scheduledDates;
    expect(dates, isNotNull);
    expect(dates!, isNotEmpty);

    // All scheduled dates must fall on Monday or Wednesday
    bool isMonOrWed(String ymd) {
      final parts = ymd.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);
      final d = DateTime(year, month, day);
      return d.weekday == DateTime.monday || d.weekday == DateTime.wednesday;
    }

    expect(dates.every(isMonOrWed), isTrue);

    // Dates should be unique and sorted ascending
    final sorted = [...dates]..sort();
    expect(dates, sorted);
    expect(dates.toSet().length, dates.length);
  });
}

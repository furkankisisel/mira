import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mira/features/habit/domain/habit_types.dart';
import 'package:mira/features/onboarding/domain/starter_plan.dart';
import 'package:mira/features/habit/domain/ai_habit_dto.dart';
import 'package:mira/features/habit/domain/habit_model.dart';
import 'package:mira/features/habit/domain/habit_repository.dart';
import 'package:mira/features/habit/presentation/widgets/active_goal_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding and Starter Plan Habits Scheduling', () {
    test('StarterPlan generates daily habits for all answers', () {
      // Test different answer profiles
      final answersList = [
        List.filled(12, 4), // High scores (structure, company, variety)
        List.filled(12, 0), // Low scores
        [4, 0, 4, 0, 4, 0, 4, 0, 4, 0, 4, 0], // Mixed scores
      ];

      for (final answers in answersList) {
        final plan = StarterPlan.build(answers, languageCode: 'tr');
        expect(StarterPlan.isUsable(plan), isTrue);

        final habits = (plan['vision']['habits'] as List).cast<Map<String, dynamic>>();
        expect(habits.length, inInclusiveRange(3, 4));

        for (final h in habits) {
          expect(h['frequency'], equals('daily'));
          final days = (h['days'] as List).cast<String>();
          expect(days.length, equals(7));
          expect(days, containsAll(['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']));
        }
      }
    });

    test('AiHabitDto.toHabit ensures today is always scheduled even if frequency is weekly', () {
      final now = DateTime.now();
      final todayIndex = now.weekday - 1; // 0=Mon..6=Sun

      // Suppose the AI provided days that do NOT include today
      final otherDay = todayIndex == 6 ? 'mon' : 'sun';
      final dto = AiHabitDto(
        title: 'Weekly Habit',
        description: 'Test weekly habit',
        category: 'Productivity',
        frequency: 'weekly',
        days: [otherDay],
        type: 'timer',
        targetValue: 5,
      );

      final habit = dto.toHabit();
      expect(habit.selectedWeekdays, isNotNull);
      // Ensure today's weekday was added so the habit is immediately visible
      expect(habit.selectedWeekdays!.contains(todayIndex), isTrue);
      // And ActiveGoalCard scheduled check returns true for today
      expect(ActiveGoalCard.isHabitScheduledForDate(habit, now), isTrue);
    });

    test('HabitRepository heals existing habits that were missing today', () async {
      final now = DateTime.now();
      final todayIndex = now.weekday - 1;
      final otherWeekday = (todayIndex + 3) % 7;

      final existingHabit = Habit(
        id: 'test_habit_heal',
        title: 'Healing Habit',
        description: 'Previously missed today',
        icon: Icons.star,
        color: Colors.blue,
        targetCount: 1,
        unit: 'min',
        habitType: HabitType.timer,
        frequency: 'weekly',
        frequencyType: 'specificWeekdays',
        selectedWeekdays: [otherWeekday], // does NOT contain todayIndex
        currentStreak: 0,
        isCompleted: false,
        progressDate: '2026-10-01',
        startDate: '2026-10-01',
      );

      SharedPreferences.setMockInitialValues({
        'habits_v2': jsonEncode([existingHabit.toJson()]),
      });

      final repo = HabitRepository.instance;
      await repo.reload();

      final loaded = repo.findById('test_habit_heal');
      expect(loaded, isNotNull);
      expect(loaded!.selectedWeekdays, isNotNull);
      // Verify healing added today's weekday
      expect(loaded.selectedWeekdays!.contains(todayIndex), isTrue);
      expect(ActiveGoalCard.isHabitScheduledForDate(loaded, now), isTrue);
    });
  });
}

import 'dart:convert';
import 'package:mira/features/onboarding/domain/starter_plan.dart';

void check(bool condition, String message) {
  if (!condition) throw StateError(message);
}

void main() {
  var profiles = 0;
  final differentPlans = <String>{};
  for (var mask = 0; mask < 16; mask++) {
    final answers = List.filled(12, 2);
    for (final i in [1, 6, 9]) {
      answers[i] = mask & 1 == 0 ? 0 : 4;
    }
    for (final i in [4, 11]) {
      answers[i] = mask & 2 == 0 ? 0 : 4;
    }
    for (final i in [0, 5, 10]) {
      answers[i] = mask & 4 == 0 ? 0 : 4;
    }
    for (final i in [2, 7]) {
      answers[i] = mask & 8 == 0 ? 0 : 4;
    }
    for (final locale in ['tr', 'en']) {
      final plan = StarterPlan.build(answers, languageCode: locale);
      check(StarterPlan.isUsable(plan), 'Invalid plan for $mask/$locale');
      final habits = plan['vision']['habits'] as List;
      check(habits.length == 3, 'Must offer exactly three small options');
      check(
          habits.every(
              (h) => h['duration_minutes'] >= 1 && h['duration_minutes'] <= 5),
          'Starter durations must remain small');
      differentPlans.add(habits.map((h) => h['title']).join('|'));
      profiles++;
    }
  }
  check(differentPlans.length >= 12,
      'Distinct preferences should change recommendations');
  final neutral = StarterPlan.build(List.filled(12, 2), languageCode: 'tr');
  check(StarterPlan.isUsable(neutral), 'Neutral answers must still work');
  for (final invalid in [<int>[], List.filled(12, 5), List.filled(12, -1)]) {
    var rejected = false;
    try {
      StarterPlan.build(invalid, languageCode: 'tr');
    } on ArgumentError {
      rejected = true;
    }
    check(rejected, 'Reject missing or invalid answers');
  }
  Map<String, dynamic> copy() =>
      jsonDecode(jsonEncode(neutral)) as Map<String, dynamic>;
  final empty = copy();
  empty['vision']['habits'] = [];
  check(!StarterPlan.isUsable(empty), 'Reject empty AI output');
  final oversized = copy();
  oversized['vision']['habits'][0]['duration_minutes'] = 60;
  check(!StarterPlan.isUsable(oversized), 'Reject burdensome durations');
  final unexplained = copy();
  unexplained['vision']['habits'][0]['rationale'] = '';
  check(!StarterPlan.isUsable(unexplained), 'Require a personal reason');
  final duplicate = copy();
  duplicate['vision']['habits'][1]['title'] =
      duplicate['vision']['habits'][0]['title'];
  check(!StarterPlan.isUsable(duplicate), 'Reject duplicates');
  final invalidDays = copy();
  invalidDays['vision']['habits'][0]['days'] = ['banana'];
  check(!StarterPlan.isUsable(invalidDays), 'Reject invalid schedules');
  print(
      'Passed: $profiles profile/language combinations, neutral answers, invalid input and malformed AI plans.');
}

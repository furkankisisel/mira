import 'live_rhythm_model.dart';

/// Service to analyze rhythm questionnaire answers and create a RhythmProfile
class RhythmAnalyzerService {
  /// Analyze answers and create a personalized rhythm profile
  RhythmProfile analyze(Map<String, int> answers) {
    // Extract sleep/wake times to determine day boundaries
    final sleepTimeIndex = answers['sleep_time'] ?? 1; // default 23:00-00:00
    final wakeTimeIndex = answers['wake_time'] ?? 1; // default 07:00-08:00

    // Calculate sleep and wake hours based on selected options
    final sleepHour = _getSleepHour(sleepTimeIndex);
    final wakeHour = _getWakeHour(wakeTimeIndex);

    // Analyze focus window from S3 & S4
    final focusWindow = _calculateFocusWindow(
      answers['hard_work_time'] ?? 1,
      answers['learning_clarity'] ?? 0,
      wakeHour,
    );

    // Analyze energy window from S5 & S6
    final energyWindow = _calculateEnergyWindow(
      answers['energy_peak'] ?? 1,
      answers['exercise_ease'] ?? 1,
      focusWindow.endHour,
    );

    // Analyze light window from S7 & S8
    final lightWindow = _calculateLightWindow(
      answers['procrastination_time'] ?? 0,
      answers['low_energy_behavior'] ?? 0,
      energyWindow.endHour,
    );

    // Reflection window fills the remaining time
    final reflectionWindow = TimeRange(
      startHour: lightWindow.endHour,
      endHour: sleepHour,
    );

    // Determine chrono type from S11
    final chronoType = _getChronoType(answers['chrono_type'] ?? 2);

    // Calculate flexibility score based on "fark etmez" and "değişiyor" answers
    final flexibilityScore = _calculateFlexibility(answers);

    return RhythmProfile(
      focusWindow: focusWindow,
      energyWindow: energyWindow,
      lightWindow: lightWindow,
      reflectionWindow: reflectionWindow,
      chronoType: chronoType,
      flexibilityScore: flexibilityScore,
      createdAt: DateTime.now(),
    );
  }

  int _getSleepHour(int index) {
    // Options: 22-23, 23-00, 00-01, 01+
    switch (index) {
      case 0:
        return 22;
      case 1:
        return 23;
      case 2:
        return 0;
      case 3:
        return 1;
      default:
        return 23;
    }
  }

  int _getWakeHour(int index) {
    // Options: 06-07, 07-08, 08-09, 09+
    switch (index) {
      case 0:
        return 6;
      case 1:
        return 7;
      case 2:
        return 8;
      case 3:
        return 9;
      default:
        return 7;
    }
  }

  TimeRange _calculateFocusWindow(
    int hardWorkAnswer,
    int learningAnswer,
    int wakeHour,
  ) {
    // Combine answers to determine focus window
    // 0: early_morning, 1: mid_morning, 2: afternoon, 3: evening, 4: no_difference
    int focusStartHour;
    int focusDuration = 4; // default 4 hours

    // Learning clarity provides secondary signal
    // 0: morning, 1: noon, 2: evening, 3: night, 4: varies

    if (hardWorkAnswer == 0 || learningAnswer == 0) {
      // Early morning person
      focusStartHour = wakeHour;
    } else if (hardWorkAnswer == 1) {
      // Mid-morning
      focusStartHour = wakeHour + 2;
    } else if (hardWorkAnswer == 2 || learningAnswer == 1) {
      // Afternoon
      focusStartHour = 12;
    } else if (hardWorkAnswer == 3 || learningAnswer == 2) {
      // Evening
      focusStartHour = 17;
    } else {
      // No difference or varies - use default morning
      focusStartHour = wakeHour + 1;
    }

    // Night owl special case
    if (learningAnswer == 3) {
      focusStartHour = 20;
    }

    return TimeRange(
      startHour: focusStartHour,
      endHour: focusStartHour + focusDuration,
    );
  }

  TimeRange _calculateEnergyWindow(
    int energyPeakAnswer,
    int exerciseAnswer,
    int afterFocusHour,
  ) {
    // 0: morning, 1: noon, 2: evening, 3: none, 4: fluctuates
    int energyStartHour;
    int energyDuration = 3;

    // Combine both signals
    if (energyPeakAnswer == 0 || exerciseAnswer == 0) {
      energyStartHour = 8;
    } else if (energyPeakAnswer == 1 || exerciseAnswer == 1) {
      energyStartHour = 12;
    } else if (energyPeakAnswer == 2 || exerciseAnswer == 2) {
      energyStartHour = 17;
    } else {
      // Default: after focus window
      energyStartHour = afterFocusHour;
    }

    // Ensure energy window doesn't overlap with focus
    if (energyStartHour < afterFocusHour) {
      energyStartHour = afterFocusHour;
    }

    return TimeRange(
      startHour: energyStartHour,
      endHour: energyStartHour + energyDuration,
    );
  }

  TimeRange _calculateLightWindow(
    int procrastinationAnswer,
    int lowEnergyBehavior,
    int afterEnergyHour,
  ) {
    // Procrastination: 0: after_noon, 1: late_afternoon, 2: night, 3: not_specific
    int lightStartHour;
    int lightDuration = 3;

    switch (procrastinationAnswer) {
      case 0:
        lightStartHour = 14;
        break;
      case 1:
        lightStartHour = 16;
        break;
      case 2:
        lightStartHour = 20;
        break;
      default:
        lightStartHour = afterEnergyHour;
    }

    // Low energy behavior affects duration
    // 0: social_media (long), 1: simple_tasks (medium), 2: rest (short), 3: force (short)
    if (lowEnergyBehavior == 0) {
      lightDuration = 4; // They tend to lose more time
    } else if (lowEnergyBehavior == 2 || lowEnergyBehavior == 3) {
      lightDuration = 2; // They recover faster
    }

    // Ensure light window starts after energy
    if (lightStartHour < afterEnergyHour) {
      lightStartHour = afterEnergyHour;
    }

    return TimeRange(
      startHour: lightStartHour,
      endHour: lightStartHour + lightDuration,
    );
  }

  ChronoType _getChronoType(int answer) {
    // 0: morning_person, 1: evening_person, 2: middle, 3: seasonal
    switch (answer) {
      case 0:
        return ChronoType.morning;
      case 1:
        return ChronoType.evening;
      case 2:
        return ChronoType.intermediate;
      case 3:
        return ChronoType.variable;
      default:
        return ChronoType.intermediate;
    }
  }

  double _calculateFlexibility(Map<String, int> answers) {
    int flexibleAnswers = 0;
    int totalRelevant = 0;

    // Check for "fark etmez", "değişiyor", "belirgin değil" type answers
    final flexibleIndices = {
      'hard_work_time': 4, // no_difference
      'learning_clarity': 4, // varies
      'energy_peak': 4, // fluctuates
      'exercise_ease': 3, // no_difference
      'procrastination_time': 3, // not_specific
    };

    for (final entry in flexibleIndices.entries) {
      final answer = answers[entry.key];
      if (answer != null) {
        totalRelevant++;
        if (answer == entry.value) {
          flexibleAnswers++;
        }
      }
    }

    if (totalRelevant == 0) return 0.5;
    return flexibleAnswers / totalRelevant;
  }
}

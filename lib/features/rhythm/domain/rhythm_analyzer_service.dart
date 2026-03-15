import 'live_rhythm_model.dart';

/// Service to analyze rhythm questionnaire answers and create a RhythmProfile
/// Uses the 5-item Reduced Morningness-Eveningness Questionnaire (rMEQ) logic.
class RhythmAnalyzerService {
  /// Analyze answers and create a personalized rhythm profile
  RhythmProfile analyze(Map<String, int> answers) {
    // 1. Calculate rMEQ score
    final int score = _calculateRMeqScore(answers);

    // 2. Determine Chronotype
    final ChronoType chronoType = _determineChronoType(score);

    // 3. Define Windows based on Chronotype
    final TimeRange focusWindow = _calculateFocusWindow(chronoType);
    final TimeRange energyWindow = _calculateEnergyWindow(chronoType);
    final TimeRange lightWindow = _calculateLightWindow(chronoType);
    final TimeRange reflectionWindow = _calculateReflectionWindow(chronoType);

    return RhythmProfile(
      focusWindow: focusWindow,
      energyWindow: energyWindow,
      lightWindow: lightWindow,
      reflectionWindow: reflectionWindow,
      chronoType: chronoType,
      flexibilityScore: 0.5, // Fixed, as rMEQ doesn't specifically measure this
      createdAt: DateTime.now(),
    );
  }

  int _calculateRMeqScore(Map<String, int> answers) {
    int score = 0;

    // S1: rmeq_wake_time (Scores: 5, 4, 3, 2, 1)
    final wakeAnswer = answers['rmeq_wake_time'] ?? 2; // Default: 07:45-09:45
    score += (5 - wakeAnswer);

    // S2: rmeq_morning_tiredness (Scores: 1, 2, 3, 4)
    final tiredAnswer = answers['rmeq_morning_tiredness'] ?? 1; // Default: Fairly tired
    score += (tiredAnswer + 1);

    // S3: rmeq_sleep_time (Scores: 5, 4, 3, 2, 1)
    final sleepAnswer = answers['rmeq_sleep_time'] ?? 2; // Default: 22:15-00:30
    score += (5 - sleepAnswer);

    // S4: rmeq_peak_time (Scores: 5, 4, 3, 2, 1)
    final peakAnswer = answers['rmeq_peak_time'] ?? 1; // Default: 09:00-14:00
    score += (5 - peakAnswer);

    // S5: rmeq_subjective_type (Scores: 6, 4, 2, 0)
    final subjAnswer = answers['rmeq_subjective_type'] ?? 2; // Default: Rather evening
    if (subjAnswer == 0) score += 6;
    else if (subjAnswer == 1) score += 4;
    else if (subjAnswer == 2) score += 2;
    else if (subjAnswer == 3) score += 0;

    return score;
  }

  ChronoType _determineChronoType(int score) {
    // rMEQ typical ranges:
    // 4-11: Evening type
    // 12-17: Intermediate type
    // 18-25: Morning type
    if (score < 12) {
      return ChronoType.evening;
    } else if (score < 18) {
      return ChronoType.intermediate;
    } else {
      return ChronoType.morning;
    }
  }

  TimeRange _calculateFocusWindow(ChronoType type) {
    switch (type) {
      case ChronoType.morning:
        return const TimeRange(startHour: 8, endHour: 12);
      case ChronoType.intermediate:
        return const TimeRange(startHour: 10, endHour: 14);
      case ChronoType.evening:
      case ChronoType.variable: // fallback
        return const TimeRange(startHour: 14, endHour: 18);
    }
  }

  TimeRange _calculateEnergyWindow(ChronoType type) {
    switch (type) {
      case ChronoType.morning:
        return const TimeRange(startHour: 14, endHour: 17);
      case ChronoType.intermediate:
        return const TimeRange(startHour: 15, endHour: 18);
      case ChronoType.evening:
      case ChronoType.variable:
        return const TimeRange(startHour: 19, endHour: 22);
    }
  }

  TimeRange _calculateLightWindow(ChronoType type) {
    switch (type) {
      case ChronoType.morning:
        return const TimeRange(startHour: 17, endHour: 20);
      case ChronoType.intermediate:
        return const TimeRange(startHour: 18, endHour: 21);
      case ChronoType.evening:
      case ChronoType.variable:
        return const TimeRange(startHour: 22, endHour: 0);
    }
  }

  TimeRange _calculateReflectionWindow(ChronoType type) {
    switch (type) {
      case ChronoType.morning:
        return const TimeRange(startHour: 20, endHour: 22);
      case ChronoType.intermediate:
        return const TimeRange(startHour: 21, endHour: 23);
      case ChronoType.evening:
      case ChronoType.variable:
        return const TimeRange(startHour: 0, endHour: 2);
    }
  }
}

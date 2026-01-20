/// Rhythm window types for time-based habit categorization
enum RhythmWindow {
  /// 🧠 Focus Time - mental clarity, learning, analysis
  focus,

  /// ⚡ Energy Time - movement, action, sports
  energy,

  /// 🌤️ Light Time - low effort, small tasks
  light,

  /// 🌙 Reflection Time - journaling, meditation, closure
  reflection,
}

/// Chronotype classification
enum ChronoType {
  morning,
  evening,
  intermediate,
  variable,
}

/// Time range representation
class TimeRange {
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;

  const TimeRange({
    required this.startHour,
    this.startMinute = 0,
    required this.endHour,
    this.endMinute = 0,
  });

  /// Check if a given time falls within this range
  bool contains(DateTime time) {
    final timeMinutes = time.hour * 60 + time.minute;
    final startMinutes = startHour * 60 + startMinute;
    final endMinutes = endHour * 60 + endMinute;

    // Handle overnight ranges (e.g., 20:00 - 06:00)
    if (startMinutes > endMinutes) {
      return timeMinutes >= startMinutes || timeMinutes < endMinutes;
    }

    return timeMinutes >= startMinutes && timeMinutes < endMinutes;
  }

  @override
  String toString() =>
      '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')} - '
      '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'startHour': startHour,
        'startMinute': startMinute,
        'endHour': endHour,
        'endMinute': endMinute,
      };

  factory TimeRange.fromJson(Map<String, dynamic> json) => TimeRange(
        startHour: json['startHour'] as int,
        startMinute: json['startMinute'] as int? ?? 0,
        endHour: json['endHour'] as int,
        endMinute: json['endMinute'] as int? ?? 0,
      );
}

/// User's personalized rhythm profile
class RhythmProfile {
  final TimeRange focusWindow;
  final TimeRange energyWindow;
  final TimeRange lightWindow;
  final TimeRange reflectionWindow;
  final ChronoType chronoType;
  final double flexibilityScore; // 0.0 - 1.0
  final DateTime createdAt;
  final DateTime? lastEvolution;

  const RhythmProfile({
    required this.focusWindow,
    required this.energyWindow,
    required this.lightWindow,
    required this.reflectionWindow,
    required this.chronoType,
    required this.flexibilityScore,
    required this.createdAt,
    this.lastEvolution,
  });

  /// Get current rhythm window based on time
  RhythmWindow getCurrentWindow([DateTime? time]) {
    final now = time ?? DateTime.now();

    if (focusWindow.contains(now)) return RhythmWindow.focus;
    if (energyWindow.contains(now)) return RhythmWindow.energy;
    if (lightWindow.contains(now)) return RhythmWindow.light;
    return RhythmWindow.reflection;
  }

  /// Get next window transition time
  DateTime? getNextTransition([DateTime? time]) {
    final now = time ?? DateTime.now();
    final currentWindow = getCurrentWindow(now);

    // Determine next window
    final windows = [focusWindow, energyWindow, lightWindow, reflectionWindow];
    final currentIndex = RhythmWindow.values.indexOf(currentWindow);
    final nextIndex = (currentIndex + 1) % 4;
    final nextWindow = windows[nextIndex];

    // Calculate next transition time
    var transitionTime = DateTime(
      now.year,
      now.month,
      now.day,
      nextWindow.startHour,
      nextWindow.startMinute,
    );

    if (transitionTime.isBefore(now)) {
      transitionTime = transitionTime.add(const Duration(days: 1));
    }

    return transitionTime;
  }

  Map<String, dynamic> toJson() => {
        'focusWindow': focusWindow.toJson(),
        'energyWindow': energyWindow.toJson(),
        'lightWindow': lightWindow.toJson(),
        'reflectionWindow': reflectionWindow.toJson(),
        'chronoType': chronoType.name,
        'flexibilityScore': flexibilityScore,
        'createdAt': createdAt.toIso8601String(),
        'lastEvolution': lastEvolution?.toIso8601String(),
      };

  factory RhythmProfile.fromJson(Map<String, dynamic> json) => RhythmProfile(
        focusWindow: TimeRange.fromJson(json['focusWindow']),
        energyWindow: TimeRange.fromJson(json['energyWindow']),
        lightWindow: TimeRange.fromJson(json['lightWindow']),
        reflectionWindow: TimeRange.fromJson(json['reflectionWindow']),
        chronoType: ChronoType.values.firstWhere(
          (e) => e.name == json['chronoType'],
          orElse: () => ChronoType.intermediate,
        ),
        flexibilityScore: (json['flexibilityScore'] as num).toDouble(),
        createdAt: DateTime.parse(json['createdAt'] as String),
        lastEvolution: json['lastEvolution'] != null
            ? DateTime.parse(json['lastEvolution'] as String)
            : null,
      );

  /// Default profile for new users
  factory RhythmProfile.defaultProfile() => RhythmProfile(
        focusWindow: const TimeRange(startHour: 6, endHour: 12),
        energyWindow: const TimeRange(startHour: 12, endHour: 17),
        lightWindow: const TimeRange(startHour: 17, endHour: 20),
        reflectionWindow: const TimeRange(startHour: 20, endHour: 6),
        chronoType: ChronoType.intermediate,
        flexibilityScore: 0.5,
        createdAt: DateTime.now(),
      );
}

/// Live rhythm state for UI
class LiveRhythmState {
  final RhythmWindow currentWindow;
  final String? suggestedHabitId;
  final String? aiExplanation;
  final DateTime lastUpdated;
  final DateTime? nextTransition;

  const LiveRhythmState({
    required this.currentWindow,
    this.suggestedHabitId,
    this.aiExplanation,
    required this.lastUpdated,
    this.nextTransition,
  });
}

/// Rhythm question model for biological clock assessment
class RhythmQuestion {
  final String id;
  final RhythmQuestionCategory category;
  final String questionKey;
  final List<String> answerKeys;

  const RhythmQuestion({
    required this.id,
    required this.category,
    required this.questionKey,
    required this.answerKeys,
  });
}

/// Categories for rhythm questions
enum RhythmQuestionCategory {
  /// S1-S2: Sleep frame (day start/end)
  sleep,

  /// S3-S4: Mental focus (Focus Window)
  focus,

  /// S5-S6: Energy & movement (Energy Window)
  energy,

  /// S7-S8: Low energy periods (Light Window)
  lowEnergy,

  /// S9-S10: Evening & closure (Reflection Window)
  reflection,

  /// S11: Self-identification (calibration)
  selfProfile,
}

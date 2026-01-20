import 'rhythm_question.dart';

/// Static list of 11 biological clock questions
class RhythmQuestions {
  static const List<RhythmQuestion> questions = [
    // S1: Sleep time
    RhythmQuestion(
      id: 'sleep_time',
      category: RhythmQuestionCategory.sleep,
      questionKey: 'rhythmQ1',
      answerKeys: ['22:00-23:00', '23:00-00:00', '00:00-01:00', '01:00+'],
    ),

    // S2: Wake time
    RhythmQuestion(
      id: 'wake_time',
      category: RhythmQuestionCategory.sleep,
      questionKey: 'rhythmQ2',
      answerKeys: ['06:00-07:00', '07:00-08:00', '08:00-09:00', '09:00+'],
    ),

    // S3: Hard work time
    RhythmQuestion(
      id: 'hard_work_time',
      category: RhythmQuestionCategory.focus,
      questionKey: 'rhythmQ3',
      answerKeys: [
        'early_morning',
        'mid_morning',
        'afternoon',
        'evening',
        'no_difference'
      ],
    ),

    // S4: Learning clarity
    RhythmQuestion(
      id: 'learning_clarity',
      category: RhythmQuestionCategory.focus,
      questionKey: 'rhythmQ4',
      answerKeys: ['morning', 'noon', 'evening', 'night', 'varies'],
    ),

    // S5: Energy peak
    RhythmQuestion(
      id: 'energy_peak',
      category: RhythmQuestionCategory.energy,
      questionKey: 'rhythmQ5',
      answerKeys: ['morning', 'noon', 'evening', 'none', 'fluctuates'],
    ),

    // S6: Exercise ease
    RhythmQuestion(
      id: 'exercise_ease',
      category: RhythmQuestionCategory.energy,
      questionKey: 'rhythmQ6',
      answerKeys: ['morning', 'afternoon', 'evening', 'no_difference'],
    ),

    // S7: Procrastination time
    RhythmQuestion(
      id: 'procrastination_time',
      category: RhythmQuestionCategory.lowEnergy,
      questionKey: 'rhythmQ7',
      answerKeys: ['after_noon', 'late_afternoon', 'night', 'not_specific'],
    ),

    // S8: Low energy behavior
    RhythmQuestion(
      id: 'low_energy_behavior',
      category: RhythmQuestionCategory.lowEnergy,
      questionKey: 'rhythmQ8',
      answerKeys: ['social_media', 'simple_tasks', 'rest', 'force_myself'],
    ),

    // S9: Evening activity preference
    RhythmQuestion(
      id: 'evening_activity',
      category: RhythmQuestionCategory.reflection,
      questionKey: 'rhythmQ9',
      answerKeys: ['write_think', 'quiet_rest', 'read', 'sleep_directly'],
    ),

    // S10: Evening mind state
    RhythmQuestion(
      id: 'evening_mind',
      category: RhythmQuestionCategory.reflection,
      questionKey: 'rhythmQ10',
      answerKeys: [
        'calm_collected',
        'tired_thoughtful',
        'scattered',
        'still_active'
      ],
    ),

    // S11: Chrono type self-identification
    RhythmQuestion(
      id: 'chrono_type',
      category: RhythmQuestionCategory.selfProfile,
      questionKey: 'rhythmQ11',
      answerKeys: ['morning_person', 'evening_person', 'middle', 'seasonal'],
    ),
  ];
}

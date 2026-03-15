import 'rhythm_question.dart';

/// Static list of 5 Reduced Morningness-Eveningness Questionnaire (rMEQ) questions
class RhythmQuestions {
  static const List<RhythmQuestion> questions = [
    RhythmQuestion(
      id: 'rmeq_wake_time',
      category: RhythmQuestionCategory.selfProfile,
      questionKey: 'rhythmQ1',
      // Scores: 5, 4, 3, 2, 1
      answerKeys: ['05:00-06:30', '06:30-07:45', '07:45-09:45', '09:45-11:00', '11:00-12:00'],
    ),
    RhythmQuestion(
      id: 'rmeq_morning_tiredness',
      category: RhythmQuestionCategory.selfProfile,
      questionKey: 'rhythmQ2',
      // Scores: 1, 2, 3, 4
      answerKeys: ['very_tired', 'fairly_tired', 'fairly_rested', 'very_rested'],
    ),
    RhythmQuestion(
      id: 'rmeq_sleep_time',
      category: RhythmQuestionCategory.selfProfile,
      questionKey: 'rhythmQ3',
      // Scores: 5, 4, 3, 2, 1
      answerKeys: ['20:00-21:00', '21:00-22:15', '22:15-00:30', '00:30-01:45', '01:45-03:00'],
    ),
    RhythmQuestion(
      id: 'rmeq_peak_time',
      category: RhythmQuestionCategory.selfProfile,
      questionKey: 'rhythmQ4',
      // Scores: 5, 4, 3, 2, 1
      answerKeys: ['05:00-09:00', '09:00-14:00', '14:00-17:00', '17:00-21:00', '21:00-05:00'],
    ),
    RhythmQuestion(
      id: 'rmeq_subjective_type',
      category: RhythmQuestionCategory.selfProfile,
      questionKey: 'rhythmQ5',
      // Scores: 6, 4, 2, 0
      answerKeys: ['definitely_morning', 'rather_morning', 'rather_evening', 'definitely_evening'],
    ),
  ];
}

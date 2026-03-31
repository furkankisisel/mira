import 'profile_draft.dart';

class AdaptiveQuestion {
  final String question;
  final String inputType;
  final List<String> options;
  final num? sliderMin;
  final num? sliderMax;
  final String? sliderUnit;
  final ProfileDraft profileUpdate;
  final bool isFinal;

  AdaptiveQuestion({
    required this.question,
    required this.inputType,
    required this.options,
    this.sliderMin,
    this.sliderMax,
    this.sliderUnit,
    required this.profileUpdate,
    required this.isFinal,
  });

  factory AdaptiveQuestion.fromJson(Map<String, dynamic> json) {
    return AdaptiveQuestion(
      question: json['question'] as String? ?? '',
      inputType: json['input_type'] as String? ?? 'text',
      options: (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [],
      sliderMin: json['slider_min'] as num?,
      sliderMax: json['slider_max'] as num?,
      sliderUnit: json['slider_unit'] as String?,
      profileUpdate: json['profile_update'] != null
          ? ProfileDraft.fromJson(json['profile_update'] as Map<String, dynamic>)
          : ProfileDraft(),
      isFinal: json['is_final'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'input_type': inputType,
      'options': options,
      'slider_min': sliderMin,
      'slider_max': sliderMax,
      'slider_unit': sliderUnit,
      'profile_update': profileUpdate.toJson(),
      'is_final': isFinal,
    };
  }
}

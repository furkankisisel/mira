import '../../../models/profile_draft.dart';
import '../../../models/adaptive_question.dart';
import '../../../models/onboarding_result_ai.dart';
import '../../../services/groq_onboarding_service.dart';
import '../../../core/config/api_config.dart';

/// Adaptif AI onboarding akışını yöneten controller.
///
/// Kullanım:
/// ```dart
/// final ctrl = OnboardingController();
/// final firstQ = await ctrl.startOnboarding();
/// // kullanıcı cevapladı →
/// final nextQ = await ctrl.submitAnswer('cevap');
/// // nextQ == null ise final çağrı yapıldı, result için generateResult() çağrılmayalım,
/// // controller zaten çağırır ve _result'a yazar.
/// print(ctrl.result); // OnboardingResultAi
/// ```
class OnboardingController {
  final GroqOnboardingService _service;

  ProfileDraft _profileDraft = ProfileDraft();
  final List<AdaptiveQuestion> _questionHistory = [];
  int _questionIndex = 0;

  OnboardingResultAi? result;
  bool isLoading = false;

  OnboardingController()
      : _service = GroqOnboardingService(apiKey: ApiConfig.groqApiKey);

  List<AdaptiveQuestion> get questionHistory =>
      List.unmodifiable(_questionHistory);

  /// Onboarding'i başlat — ilk soruyu döner.
  Future<AdaptiveQuestion> startOnboarding() async {
    _profileDraft = ProfileDraft();
    _questionHistory.clear();
    _questionIndex = 0;
    result = null;

    final question = await _service.getNextQuestion(
      currentProfile: _profileDraft,
      lastAnswer: '',
      questionIndex: _questionIndex,
    );
    _questionHistory.add(question);
    _profileDraft.mergeFrom(question.profileUpdate);
    return question;
  }

  /// Kullanıcı cevap verdi — sonraki soruyu döner.
  ///
  /// Bitiş kararı AI'a değil koda bırakılır:
  /// - 5. sorudan itibaren profil tamamsa bitir (erken bitiş)
  /// - 7. soruya ulaşınca zorla bitir
  Future<AdaptiveQuestion?> submitAnswer(String answer) async {
    _questionIndex++;

    // Önce sonraki soruyu al (profil güncellemesi için)
    final question = await _service.getNextQuestion(
      currentProfile: _profileDraft,
      lastAnswer: answer,
      questionIndex: _questionIndex,
    );
    _profileDraft.mergeFrom(question.profileUpdate);

    // Bitiş koşulları — kod kontrol eder, AI'a güvenilmez
    final shouldFinish =
        (_questionIndex >= 5 && _profileDraft.isComplete()) || // profil dolu
        (_questionIndex >= 7); // zorla bitir

    if (shouldFinish) {
      result = await _service.generateResult(finalProfile: _profileDraft);
      return null; // null → UI final ekranına geçer
    }

    _questionHistory.add(question);
    return question;
  }

  /// Soru döngüsünden bağımsız olarak final çağrısı yap.
  /// (Genellikle [submitAnswer] tarafından otomatik çağrılır.)
  Future<OnboardingResultAi> generateResult() async {
    result = await _service.generateResult(finalProfile: _profileDraft);
    return result!;
  }
}

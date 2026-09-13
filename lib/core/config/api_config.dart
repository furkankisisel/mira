class ApiConfig {
  ApiConfig._();

  /// Groq API Key for AI-powered features.
  ///
  /// Securely provided via compile-time environment variable:
  /// `flutter run --dart-define=GROQ_API_KEY=your_groq_key`
  static const String groqApiKey = String.fromEnvironment(
    'GROQ_API_KEY',
    defaultValue: '',
  );

  /// Checks if Groq API key is provided
  static bool get isGroqConfigured => groqApiKey.isNotEmpty;
}

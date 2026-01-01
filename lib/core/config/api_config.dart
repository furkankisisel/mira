class ApiConfig {
  ApiConfig._();

  /// Groq API Key for AI-powered features.
  ///
  /// Securely managed via environment variables or unified config.
  static const String groqApiKey = String.fromEnvironment(
    'GROQ_API_KEY',
    defaultValue: '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',
  );
}

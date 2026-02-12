class AppConstants {
  static const String appName = 'YouTube Clone';
  // Pexels API
  static const String apiBaseUrl = 'https://api.pexels.com/videos';
  // In production, use .env or secure storage
  static const String pexelsApiKey =
      'mf6oSnfX9u9oCKdaHaAApA2CGGrax6nMF5Nbubu2eUrBJCvbKL73cBmk';

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String authKey = 'auth_token';

  // Encryption
  static const String keyStorageKey = 'encryption_key';
}

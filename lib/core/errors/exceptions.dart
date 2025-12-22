/// Custom exception classes for the application
/// Bu dosya uygulamaya özel exception sınıflarını içerir

/// Server exception - Sunucu hatası
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({this.message = 'Server error occurred', this.statusCode});

  @override
  String toString() => 'ServerException: $message (Code: $statusCode)';
}

/// Cache exception - Cache hatası
class CacheException implements Exception {
  final String message;

  CacheException({this.message = 'Cache error occurred'});

  @override
  String toString() => 'CacheException: $message';
}

/// Network exception - Ağ bağlantı hatası
class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'Network connection failed'});

  @override
  String toString() => 'NetworkException: $message';
}

/// Authentication exception - Kimlik doğrulama hatası
class AuthenticationException implements Exception {
  final String message;

  AuthenticationException({this.message = 'Authentication failed'});

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Validation exception - Doğrulama hatası
class ValidationException implements Exception {
  final String message;
  final Map<String, String>? errors;

  ValidationException({this.message = 'Validation failed', this.errors});

  @override
  String toString() => 'ValidationException: $message';
}

/// Database exception - Veritabanı hatası
class DatabaseException implements Exception {
  final String message;

  DatabaseException({this.message = 'Database error occurred'});

  @override
  String toString() => 'DatabaseException: $message';
}

/// Security exception - Güvenlik hatası (anti-cheat, data tampering)
class SecurityException implements Exception {
  final String message;

  SecurityException({this.message = 'Security violation detected'});

  @override
  String toString() => 'SecurityException: $message';
}

/// Firebase exception - Firebase ile ilgili hatalar
class FirebaseException implements Exception {
  final String message;
  final String? code;

  FirebaseException({this.message = 'Firebase error occurred', this.code});

  @override
  String toString() => 'FirebaseException: $message (Code: $code)';
}

import 'package:equatable/equatable.dart';

/// Base failure class - Tüm failure sınıflarının parent'ı
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Server failure - Sunucu hatası
class ServerFailure extends Failure {
  const ServerFailure({String message = 'Server failure', int? code})
      : super(message: message, code: code);
}

/// Cache failure - Cache hatası
class CacheFailure extends Failure {
  const CacheFailure({String message = 'Cache failure'})
      : super(message: message);
}

/// Network failure - Ağ bağlantı hatası
class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'Network failure'})
      : super(message: message);
}

/// Authentication failure - Kimlik doğrulama hatası
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({String message = 'Authentication failure'})
      : super(message: message);
}

/// Validation failure - Doğrulama hatası
class ValidationFailure extends Failure {
  final Map<String, String>? errors;

  const ValidationFailure(
      {String message = 'Validation failure', this.errors, int? code})
      : super(message: message, code: code);

  @override
  List<Object?> get props => [message, code, errors];
}

/// Database failure - Veritabanı hatası
class DatabaseFailure extends Failure {
  const DatabaseFailure({String message = 'Database failure'})
      : super(message: message);
}

/// Security failure - Güvenlik hatası
class SecurityFailure extends Failure {
  const SecurityFailure({String message = 'Security failure'})
      : super(message: message);
}

/// Firebase failure - Firebase hatası
class FirebaseFailure extends Failure {
  const FirebaseFailure({String message = 'Firebase failure', int? code})
      : super(message: message, code: code);
}

/// Unexpected failure - Beklenmeyen hata
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({String message = 'Unexpected error occurred'})
      : super(message: message);
}

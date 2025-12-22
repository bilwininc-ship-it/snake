/// Secure storage service
/// Güvenli veri depolama servisi
/// 
/// Hassas verileri (token, API key vb.) güvenli bir şekilde saklar

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  /// Write secure data
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      print('Secure storage write error: $e');
      rethrow;
    }
  }

  /// Read secure data
  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      print('Secure storage read error: $e');
      return null;
    }
  }

  /// Delete secure data
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      print('Secure storage delete error: $e');
      rethrow;
    }
  }

  /// Delete all secure data
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      print('Secure storage delete all error: $e');
      rethrow;
    }
  }

  /// Check if key exists
  Future<bool> containsKey(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null;
    } catch (e) {
      print('Secure storage contains key error: $e');
      return false;
    }
  }

  // Predefined keys for common use cases
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyApiKey = 'api_key';
  static const String keyEncryptionKey = 'encryption_key';
}

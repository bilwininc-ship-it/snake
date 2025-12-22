import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Encryption and security utilities
/// Şifreleme ve güvenlik yardımcı fonksiyonları

class EncryptionUtils {
  // Secret key - Production'da environment variable olarak kullanılmalı
  static const String _secretKey = 'SNAKE_EMPIRES_SECRET_2024';

  /// Generate SHA-256 hash
  static String generateHash(String data) {
    final bytes = utf8.encode(data);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  /// Generate checksum for anti-cheat
  static String generateChecksum(Map<String, dynamic> data) {
    final sortedKeys = data.keys.toList()..sort();
    final values = sortedKeys.map((key) => '${data[key]}').join('|');
    final content = '$values|$_secretKey';
    return generateHash(content);
  }

  /// Validate checksum
  static bool validateChecksum(Map<String, dynamic> data, String checksum) {
    final generated = generateChecksum(data);
    return generated == checksum;
  }

  /// Generate signature for API requests
  static String generateSignature(Map<String, dynamic> data, int timestamp) {
    final content = '${jsonEncode(data)}|$timestamp|$_secretKey';
    return generateHash(content);
  }

  /// Validate signature
  static bool validateSignature(
      Map<String, dynamic> data, int timestamp, String signature) {
    final generated = generateSignature(data, timestamp);
    return generated == signature;
  }

  /// Simple obfuscation for sensitive data (not encryption, just obfuscation)
  static String obfuscate(String data) {
    final bytes = utf8.encode(data);
    final obfuscated = bytes.map((b) => b ^ 0xAA).toList();
    return base64Encode(obfuscated);
  }

  /// Deobfuscate data
  static String deobfuscate(String obfuscatedData) {
    try {
      final bytes = base64Decode(obfuscatedData);
      final deobfuscated = bytes.map((b) => b ^ 0xAA).toList();
      return utf8.decode(deobfuscated);
    } catch (e) {
      return '';
    }
  }

  /// Generate random ID
  static String generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 1000 + timestamp % 1000).toString();
    return generateHash(random).substring(0, 16);
  }

  /// Validate movement (anti-speed hack)
  static bool validateMovement({
    required double distance,
    required double deltaTime,
    required double maxSpeed,
    double tolerance = 1.2, // 20% tolerance
  }) {
    final maxPossibleDistance = maxSpeed * deltaTime * tolerance;
    return distance <= maxPossibleDistance;
  }

  /// Validate resource collection (anti-cheat)
  static bool validateResourceCollection({
    required int oldValue,
    required int newValue,
    required int maxIncrement,
  }) {
    final increment = newValue - oldValue;
    return increment >= 0 && increment <= maxIncrement;
  }
}

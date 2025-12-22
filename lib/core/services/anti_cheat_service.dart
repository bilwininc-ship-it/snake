/// Anti-cheat service
/// Hile önleme servisi
/// 
/// Oyun içi hile denemelerini tespit eder ve engeller

import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../utils/encryption_utils.dart';

class AntiCheatService {
  static final AntiCheatService _instance = AntiCheatService._internal();
  factory AntiCheatService() => _instance;
  AntiCheatService._internal();

  // Son doğrulama zamanı
  DateTime? _lastValidation;
  
  // Tespit edilen hile sayısı
  int _cheatAttempts = 0;

  /// Validate player data checksum
  bool validatePlayerData(Map<String, dynamic> data, String checksum) {
    final isValid = EncryptionUtils.validateChecksum(data, checksum);
    
    if (!isValid) {
      _cheatAttempts++;
      _reportCheat('Invalid player data checksum');
    }
    
    return isValid;
  }

  /// Validate movement (anti-speed hack)
  bool validateMovement({
    required double distance,
    required double deltaTime,
    required double maxSpeed,
  }) {
    final isValid = EncryptionUtils.validateMovement(
      distance: distance,
      deltaTime: deltaTime,
      maxSpeed: maxSpeed,
    );

    if (!isValid) {
      _cheatAttempts++;
      _reportCheat('Invalid movement detected - possible speed hack');
    }

    return isValid;
  }

  /// Validate resource collection
  bool validateResourceCollection({
    required int oldValue,
    required int newValue,
    required int maxIncrement,
  }) {
    final isValid = EncryptionUtils.validateResourceCollection(
      oldValue: oldValue,
      newValue: newValue,
      maxIncrement: maxIncrement,
    );

    if (!isValid) {
      _cheatAttempts++;
      _reportCheat('Invalid resource increment detected');
    }

    return isValid;
  }

  /// Validate time-based action (anti-time manipulation)
  bool validateTimeBasedAction(DateTime actionTime) {
    final now = DateTime.now();
    
    // Action zamanı gelecekte olamaz
    if (actionTime.isAfter(now.add(const Duration(seconds: 5)))) {
      _cheatAttempts++;
      _reportCheat('Future action time detected - possible time manipulation');
      return false;
    }
    
    // Action çok eski olamaz (5 dakikadan fazla)
    if (actionTime.isBefore(now.subtract(const Duration(minutes: 5)))) {
      _cheatAttempts++;
      _reportCheat('Past action time detected - possible time manipulation');
      return false;
    }

    return true;
  }

  /// Check if player is banned
  bool isPlayerBanned() {
    // Çok fazla hile dene mesi varsa ban
    return _cheatAttempts >= 10;
  }

  /// Get cheat attempts count
  int get cheatAttempts => _cheatAttempts;

  /// Reset cheat attempts (kullanıcı affedildiğinde)
  void resetCheatAttempts() {
    _cheatAttempts = 0;
  }

  /// Report cheat attempt
  void _reportCheat(String reason) {
    print('⚠️ CHEAT DETECTED: $reason (Total attempts: $_cheatAttempts)');
    
    // Firebase Analytics'e gönder
    // AnalyticsService().logEvent(
    //   name: 'cheat_detected',
    //   parameters: {
    //     'reason': reason,
    //     'attempts': _cheatAttempts,
    //   },
    // );

    // Firebase Crashlytics'e gönder (non-fatal)
    // CrashlyticsService().recordError(
    //   Exception('Cheat detected: $reason'),
    //   StackTrace.current,
    //   reason: reason,
    //   fatal: false,
    // );
  }

  /// Generate save file signature
  String generateSaveSignature(Map<String, dynamic> saveData) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return EncryptionUtils.generateSignature(saveData, timestamp);
  }

  /// Validate save file signature
  bool validateSaveSignature(
    Map<String, dynamic> saveData,
    String signature,
    int timestamp,
  ) {
    final isValid = EncryptionUtils.validateSignature(
      saveData,
      timestamp,
      signature,
    );

    if (!isValid) {
      _cheatAttempts++;
      _reportCheat('Invalid save file signature - file tampered');
    }

    return isValid;
  }
}

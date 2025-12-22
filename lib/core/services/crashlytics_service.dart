/// Firebase Crashlytics service
/// Firebase hata raporlama servisi
/// 
/// Uygulama çökmelerini ve hataları otomatik olarak rapor eder
/// 
/// Firebase kurulumu tamamlandıktan sonra yorumları kaldırın

// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/foundation.dart';

class CrashlyticsService {
  static final CrashlyticsService _instance = CrashlyticsService._internal();
  factory CrashlyticsService() => _instance;
  CrashlyticsService._internal();

  /// Initialize Crashlytics
  Future<void> initialize() async {
    try {
      // // FlutterError'ları Crashlytics'e gönder
      // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      // // Debug modda crash reporting'i devre dışı bırak (isteğe bağlı)
      // if (kDebugMode) {
      //   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      // }

      print('Crashlytics initialized');
    } catch (e) {
      print('Crashlytics initialization error: $e');
    }
  }

  /// Log a message
  Future<void> log(String message) async {
    try {
      // await FirebaseCrashlytics.instance.log(message);
      print('Crashlytics log: $message');
    } catch (e) {
      print('Crashlytics log error: $e');
    }
  }

  /// Record an error
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    dynamic reason,
    bool fatal = false,
  }) async {
    try {
      // await FirebaseCrashlytics.instance.recordError(
      //   exception,
      //   stackTrace,
      //   reason: reason,
      //   fatal: fatal,
      // );
      print('Crashlytics error recorded: $exception');
    } catch (e) {
      print('Crashlytics record error: $e');
    }
  }

  /// Set user identifier
  Future<void> setUserIdentifier(String identifier) async {
    try {
      // await FirebaseCrashlytics.instance.setUserIdentifier(identifier);
      print('Crashlytics user ID set: $identifier');
    } catch (e) {
      print('Crashlytics set user ID error: $e');
    }
  }

  /// Set custom key
  Future<void> setCustomKey(String key, dynamic value) async {
    try {
      // await FirebaseCrashlytics.instance.setCustomKey(key, value);
      print('Crashlytics custom key set: $key = $value');
    } catch (e) {
      print('Crashlytics set custom key error: $e');
    }
  }

  /// Force a crash (for testing)
  void testCrash() {
    // FirebaseCrashlytics.instance.crash();
    print('Crashlytics test crash triggered');
  }
}

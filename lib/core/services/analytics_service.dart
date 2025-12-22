/// Firebase Analytics service
/// Firebase analitik servisi
/// 
/// Bu servis kullanıcı davranışlarını takip eder
/// 
/// Firebase kurulumu tamamlandıktan sonra yorumları kaldırın

// import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  // final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  // final FirebaseAnalyticsObserver _observer = FirebaseAnalyticsObserver(
  //   analytics: FirebaseAnalytics.instance,
  // );

  /// Get observer for navigation tracking
  // FirebaseAnalyticsObserver get observer => _observer;

  /// Log custom event
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      // await _analytics.logEvent(
      //   name: name,
      //   parameters: parameters,
      // );
      print('Analytics event logged: $name');
    } catch (e) {
      print('Analytics error: $e');
    }
  }

  /// Log screen view
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      // await _analytics.logScreenView(
      //   screenName: screenName,
      //   screenClass: screenClass,
      // );
      print('Screen view logged: $screenName');
    } catch (e) {
      print('Analytics error: $e');
    }
  }

  /// Log level start
  Future<void> logLevelStart(int level) async {
    await logEvent(
      name: 'level_start',
      parameters: {'level': level},
    );
  }

  /// Log level complete
  Future<void> logLevelComplete(int level, {int? score}) async {
    await logEvent(
      name: 'level_complete',
      parameters: {
        'level': level,
        if (score != null) 'score': score,
      },
    );
  }

  /// Log enemy defeated
  Future<void> logEnemyDefeated(String enemyType) async {
    await logEvent(
      name: 'enemy_defeated',
      parameters: {'enemy_type': enemyType},
    );
  }

  /// Log boss defeated
  Future<void> logBossDefeated(String bossName, {int? timeInSeconds}) async {
    await logEvent(
      name: 'boss_defeated',
      parameters: {
        'boss_name': bossName,
        if (timeInSeconds != null) 'time_seconds': timeInSeconds,
      },
    );
  }

  /// Log item collected
  Future<void> logItemCollected(String itemId, {String? rarity}) async {
    await logEvent(
      name: 'item_collected',
      parameters: {
        'item_id': itemId,
        if (rarity != null) 'rarity': rarity,
      },
    );
  }

  /// Log upgrade
  Future<void> logUpgrade(String upgradeType, int level) async {
    await logEvent(
      name: 'upgrade',
      parameters: {
        'upgrade_type': upgradeType,
        'level': level,
      },
    );
  }

  /// Log ad viewed
  Future<void> logAdViewed(String adType) async {
    await logEvent(
      name: 'ad_viewed',
      parameters: {'ad_type': adType},
    );
  }

  /// Log purchase
  Future<void> logPurchase({
    required String itemId,
    required double value,
    required String currency,
  }) async {
    await logEvent(
      name: 'purchase',
      parameters: {
        'item_id': itemId,
        'value': value,
        'currency': currency,
      },
    );
  }

  /// Set user property
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    try {
      // await _analytics.setUserProperty(name: name, value: value);
      print('User property set: $name = $value');
    } catch (e) {
      print('Analytics error: $e');
    }
  }

  /// Set user ID
  Future<void> setUserId(String userId) async {
    try {
      // await _analytics.setUserId(id: userId);
      print('User ID set: $userId');
    } catch (e) {
      print('Analytics error: $e');
    }
  }
}

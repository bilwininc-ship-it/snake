class AppConstants {
  // App Info
  static const String appName = 'Snake Empires';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyPlayerData = 'player_data';
  static const String keySettings = 'settings';
  static const String keyLanguage = 'language';
  
  // Hive Box Names
  static const String hiveBoxPlayer = 'player_box';
  static const String hiveBoxSettings = 'settings_box';
  
  // Validation
  static const int minNameLength = 3;
  static const int maxNameLength = 20;
  
  // Avatars
  static const List<String> avatarList = [
    '🐍',
    '🐉',
    '🦎',
    '🐊',
    '🦖',
    '🐲',
    '🦕',
    '🐢',
  ];
  
  // Supported Languages
  static const Map<String, String> supportedLanguages = {
    'en': '🇬🇧 English',
    'tr': '🇹🇷 Türkçe',
    'es': '🇪🇸 Español',
    'de': '🇩🇪 Deutsch',
    'fr': '🇫🇷 Français',
  };
}

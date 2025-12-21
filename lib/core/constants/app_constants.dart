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
  
  // Supported Languages (10 dil)
  static const List<String> supportedLanguagesList = [
    'en',
    'tr',
    'ar',
    'zh',
    'de',
    'es',
    'fr',
    'ru',
    'ja',
    'pt',
  ];
  
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'tr': 'Türkçe',
    'ar': 'العربية',
    'zh': '中文',
    'de': 'Deutsch',
    'es': 'Español',
    'fr': 'Français',
    'ru': 'Русский',
    'ja': '日本語',
    'pt': 'Português',
  };
  
  // Language names for display
  static const Map<String, String> languageNames = {
    'en': 'English',
    'tr': 'Türkçe',
    'ar': 'العربية',
    'zh': '中文',
    'de': 'Deutsch',
    'es': 'Español',
    'fr': 'Français',
    'ru': 'Русский',
    'ja': '日本語',
    'pt': 'Português',
  };
  
  // Language Flags
  static const Map<String, String> languageFlags = {
    'en': '🇬🇧',
    'tr': '🇹🇷',
    'ar': '🇸🇦',
    'zh': '🇨🇳',
    'de': '🇩🇪',
    'es': '🇪🇸',
    'fr': '🇫🇷',
    'ru': '🇷🇺',
    'ja': '🇯🇵',
    'pt': '🇧🇷',
  };
  
  // RTL Languages
  static const List<String> rtlLanguages = ['ar'];
  
  // Initial Player Stats
  static const int initialGold = 100;
  static const int initialGems = 10;
  static const int initialLevel = 1;
  static const int initialExperience = 0;
}

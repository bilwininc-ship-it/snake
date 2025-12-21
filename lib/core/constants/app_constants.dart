// Snake Empires - App Constants

class AppConstants {
  // App Info
  static const String appName = 'Snake Empires';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String playerBox = 'player_data';
  static const String settingsBox = 'settings_data';
  static const String gameBox = 'game_data';
  
  // Game Settings
  static const double joystickRadius = 80.0;
  static const double joystickKnobRadius = 30.0;
  static const int maxSnakeLength = 100;
  
  // Languages
  static const List<String> supportedLanguages = [
    'en', 'tr', 'ar', 'zh', 'de', 'es', 'fr', 'ru', 'ja', 'pt'
  ];
  
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
  
  // Default Avatar List
  static const List<String> avatarIds = [
    'snake_green',
    'snake_red',
    'snake_blue',
    'snake_yellow',
    'snake_purple',
    'snake_orange',
  ];
}

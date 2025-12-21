import 'package:flutter/material.dart';
import 'dart:convert';

class LocalizationService {
  static final Map<String, Map<String, String>> _localizedStrings = {};
  static String _currentLocale = 'en';

  static Future<void> load(String languageCode) async {
    _currentLocale = languageCode;
    
    // Load from assets
    final String jsonString = await DefaultAssetBundle.of(
      _currentLocale == 'en' ? const Key('en') as BuildContext : const Key(_currentLocale) as BuildContext
    ).loadString('assets/translations/$languageCode.json');
    
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings[languageCode] = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  static String translate(BuildContext context, String key) {
    return _localizedStrings[_currentLocale]?[key] ?? key;
  }

  static void setLocale(BuildContext context, String languageCode) {
    _currentLocale = languageCode;
  }
  
  static String get currentLocale => _currentLocale;
}

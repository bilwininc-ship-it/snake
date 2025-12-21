import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _soundVolume = 0.7;
  double _musicVolume = 0.7;
  bool _vibrationEnabled = true;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _soundVolume = prefs.getDouble('sound_volume') ?? 0.7;
      _musicVolume = prefs.getDouble('music_volume') ?? 0.7;
      _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('sound_volume', _soundVolume);
    await prefs.setDouble('music_volume', _musicVolume);
    await prefs.setBool('vibration_enabled', _vibrationEnabled);
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('language'.tr()),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: AppConstants.supportedLanguages.length,
            itemBuilder: (context, index) {
              final langCode = AppConstants.supportedLanguages[index];
              final isSelected = context.locale.languageCode == langCode;

              return ListTile(
                leading: Text(
                  AppConstants.languageFlags[langCode] ?? '',
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(AppConstants.languageNames[langCode] ?? langCode),
                trailing: isSelected
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  context.setLocale(Locale(langCode));
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showDeleteDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_data'.tr()),
        content: const Text('Are you sure you want to delete all game data? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement delete data
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Feature coming soon!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text('confirm'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings_title'.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Language Section
          _SectionHeader(title: 'language'.tr()),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text('language'.tr()),
              subtitle: Text(
                AppConstants.languageNames[context.locale.languageCode] ??
                    context.locale.languageCode,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showLanguageDialog,
            ),
          ),
          const SizedBox(height: 24),

          // Audio Section
          _SectionHeader(title: 'Audio'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.volume_up),
                  title: Text('sound'.tr()),
                  subtitle: Slider(
                    value: _soundVolume,
                    onChanged: (value) {
                      setState(() {
                        _soundVolume = value;
                      });
                      _saveSettings();
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.music_note),
                  title: Text('music'.tr()),
                  subtitle: Slider(
                    value: _musicVolume,
                    onChanged: (value) {
                      setState(() {
                        _musicVolume = value;
                      });
                      _saveSettings();
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Other Settings
          _SectionHeader(title: 'Other'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.vibration),
                  title: Text('vibration'.tr()),
                  value: _vibrationEnabled,
                  onChanged: (value) {
                    setState(() {
                      _vibrationEnabled = value;
                    });
                    _saveSettings();
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications),
                  title: Text('notifications'.tr()),
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                    _saveSettings();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Account Section
          _SectionHeader(title: 'account'.tr()),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: Text('change_name'.tr()),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Feature coming soon!')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.face),
                  title: Text('change_avatar'.tr()),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Feature coming soon!')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.delete_forever,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    'delete_data'.tr(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onTap: _showDeleteDataDialog,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About Section
          _SectionHeader(title: 'about'.tr()),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info),
              title: Text('version'.tr()),
              subtitle: Text(AppConstants.appVersion),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}

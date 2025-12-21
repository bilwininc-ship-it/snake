import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/audio_service.dart';
import '../../features/auth/data/models/player_data.dart';
import 'credits_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  double _soundVolume = 0.7;
  double _musicVolume = 0.7;
  bool _vibrationEnabled = true;
  bool _notificationsEnabled = true;
  final AudioService _audioService = AudioService();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
    _loadSettings();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    
    // Update audio service
    await _audioService.setSfxVolume(_soundVolume);
    await _audioService.setMusicVolume(_musicVolume);
    
    // Haptic feedback
    if (_vibrationEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 500),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.language, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'language'.tr(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: AppConstants.supportedLanguages.length,
                  itemBuilder: (context, index) {
                    final langCode = AppConstants.supportedLanguages.keys.elementAt(index);
                    final langName = AppConstants.supportedLanguages[langCode];
                    final isSelected = context.locale.languageCode == langCode;

                    return ListTile(
                      leading: Text(
                        AppConstants.languageFlags[langCode] ?? '',
                        style: const TextStyle(fontSize: 32),
                      ),
                      title: Text(
                        langName ?? langCode,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.secondary,
                            )
                          : null,
                      onTap: () async {
                        await context.setLocale(Locale(langCode));
                        if (mounted) {
                          Navigator.of(context).pop();
                          setState(() {}); // Refresh UI
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangeNameDialog() async {
    final playerBox = await Hive.openBox<PlayerData>(AppConstants.hiveBoxPlayer);
    final playerData = playerBox.get(AppConstants.keyPlayerData);
    
    if (playerData == null) return;

    final TextEditingController nameController = TextEditingController(text: playerData.name);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.edit),
            const SizedBox(width: 12),
            Text('change_name_title'.tr()),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${'current_name'.tr()}: ${playerData.name}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'new_name'.tr(),
                  hintText: 'change_name_hint'.tr(),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'name_required'.tr();
                  }
                  if (value.trim().length < AppConstants.minNameLength) {
                    return 'name_too_short'.tr();
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                playerData.name = nameController.text.trim();
                await playerData.save();
                
                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('change_name_success'.tr()),
                      backgroundColor: Colors.green,
                    ),
                  );
                  setState(() {}); // Refresh UI
                }
              }
            },
            child: Text('save'.tr()),
          ),
        ],
      ),
    );
  }

  void _showChangeAvatarDialog() async {
    final playerBox = await Hive.openBox<PlayerData>(AppConstants.hiveBoxPlayer);
    final playerData = playerBox.get(AppConstants.keyPlayerData);
    
    if (playerData == null) return;

    String? selectedAvatar = playerData.avatar;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.face),
              const SizedBox(width: 12),
              Text('change_avatar_title'.tr()),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: AppConstants.avatarList.length,
              itemBuilder: (context, index) {
                final avatar = AppConstants.avatarList[index];
                final isSelected = selectedAvatar == avatar;

                return GestureDetector(
                  onTap: () {
                    setDialogState(() {
                      selectedAvatar = avatar;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.secondary.withOpacity(0.3)
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        avatar,
                        style: TextStyle(fontSize: isSelected ? 40 : 35),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'.tr()),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedAvatar != null) {
                  playerData.avatar = selectedAvatar!;
                  await playerData.save();
                  
                  if (mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('change_avatar_success'.tr()),
                        backgroundColor: Colors.green,
                      ),
                    );
                    setState(() {}); // Refresh UI
                  }
                }
              },
              child: Text('save'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.warning_amber_rounded,
          size: 48,
          color: Theme.of(context).colorScheme.error,
        ),
        title: Text(
          'delete_data_title'.tr(),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'delete_data_message'.tr(),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () async {
              // Delete all data from Hive
              await Hive.deleteBoxFromDisk(AppConstants.hiveBoxPlayer);
              await Hive.deleteBoxFromDisk(AppConstants.hiveBoxSettings);
              
              // Clear SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              
              if (mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('data_deleted_success'.tr()),
                    backgroundColor: Colors.green,
                  ),
                );
                
                // Restart app or navigate to splash
                // For now, just pop all routes
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
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
      body: FadeTransition(
        opacity: _animationController,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Language Section
            _SectionHeader(title: 'language'.tr()),
            Card(
              child: ListTile(
                leading: const Icon(Icons.language),
                title: Text('language'.tr()),
                subtitle: Text(
                  AppConstants.supportedLanguages[context.locale.languageCode] ??
                      context.locale.languageCode,
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _showLanguageDialog,
              ),
            ),
            const SizedBox(height: 24),

            // Audio Section
            _SectionHeader(title: 'audio'.tr()),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      _soundVolume > 0 ? Icons.volume_up : Icons.volume_off,
                    ),
                    title: Text('sound'.tr()),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Slider(
                          value: _soundVolume,
                          min: 0.0,
                          max: 1.0,
                          divisions: 10,
                          label: '${(_soundVolume * 100).round()}%',
                          onChanged: (value) {
                            setState(() {
                              _soundVolume = value;
                            });
                          },
                          onChangeEnd: (value) {
                            _saveSettings();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '0%',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                '${(_soundVolume * 100).round()}%',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                              ),
                              Text(
                                '100%',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      _musicVolume > 0 ? Icons.music_note : Icons.music_off,
                    ),
                    title: Text('music'.tr()),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Slider(
                          value: _musicVolume,
                          min: 0.0,
                          max: 1.0,
                          divisions: 10,
                          label: '${(_musicVolume * 100).round()}%',
                          onChanged: (value) {
                            setState(() {
                              _musicVolume = value;
                            });
                          },
                          onChangeEnd: (value) {
                            _saveSettings();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '0%',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                '${(_musicVolume * 100).round()}%',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                              ),
                              Text(
                                '100%',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Other Settings
            _SectionHeader(title: 'other'.tr()),
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
                      if (value) {
                        HapticFeedback.mediumImpact();
                      }
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
                    onTap: _showChangeNameDialog,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.face),
                    title: Text('change_avatar'.tr()),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _showChangeAvatarDialog,
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
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: Text('version'.tr()),
                    subtitle: Text(AppConstants.appVersion),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.article),
                    title: Text('credits_title'.tr()),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CreditsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
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
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
        ],
      ),
    );
  }
}

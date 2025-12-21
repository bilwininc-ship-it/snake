import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/constants/app_constants.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('credits_title'.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // App Logo/Title Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purple.shade700,
                  Colors.deepPurple.shade900,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  '🐍',
                  style: TextStyle(fontSize: 64),
                ),
                const SizedBox(height: 16),
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '${'version'.tr()}: ${AppConstants.appVersion}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Development Team
          _buildSectionHeader(context, 'development_team'.tr()),
          Card(
            child: Column(
              children: [
                _buildCreditTile(
                  icon: Icons.code,
                  title: 'credits_developer'.tr(),
                  subtitle: 'Snake Empires Team',
                ),
                const Divider(height: 1),
                _buildCreditTile(
                  icon: Icons.palette,
                  title: 'credits_designer'.tr(),
                  subtitle: 'Snake Empires Team',
                ),
                const Divider(height: 1),
                _buildCreditTile(
                  icon: Icons.music_note,
                  title: 'credits_audio'.tr(),
                  subtitle: 'Snake Empires Team',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Technologies Used
          _buildSectionHeader(context, 'technologies_used'.tr()),
          Card(
            child: Column(
              children: [
                _buildTechTile('Flutter', '^3.24.0', Icons.flutter_dash),
                const Divider(height: 1),
                _buildTechTile('Flame Engine', '^1.18.0', Icons.videogame_asset),
                const Divider(height: 1),
                _buildTechTile('Hive', '^2.2.3', Icons.storage),
                const Divider(height: 1),
                _buildTechTile('Flutter Bloc', '^8.1.6', Icons.architecture),
                const Divider(height: 1),
                _buildTechTile('Easy Localization', '^3.0.7', Icons.language),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Special Thanks
          _buildSectionHeader(context, 'special_thanks'.tr()),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'special_thanks_text'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildThankYouChip('Flutter Community'),
                      _buildThankYouChip('Flame Engine Team'),
                      _buildThankYouChip('All Contributors'),
                      _buildThankYouChip('Beta Testers'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // License
          _buildSectionHeader(context, 'license'.tr()),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.gavel, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'MIT License',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'license_text'.tr(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Copyright
          Center(
            child: Column(
              children: [
                Text(
                  '© ${DateTime.now().year} Snake Empires Team',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'made_with_love'.tr(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.pink.shade300,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }

  Widget _buildCreditTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildTechTile(String name, String version, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      subtitle: Text(version),
      trailing: const Icon(Icons.check_circle, color: Colors.green),
    );
  }

  Widget _buildThankYouChip(String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: Colors.amber.withOpacity(0.2),
      side: BorderSide(color: Colors.amber.withOpacity(0.5)),
    );
  }
}

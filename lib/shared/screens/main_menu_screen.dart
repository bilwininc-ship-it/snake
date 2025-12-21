import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../core/services/injection_container.dart';
import '../../core/services/audio_service.dart';
import '../widgets/player_profile_card.dart';
import '../widgets/menu_button.dart';
import '../widgets/daily_quest_preview.dart';
import '../widgets/notification_banner.dart';
import 'settings_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _logoController;
  late AnimationController _floatingController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotateAnimation;
  late Animation<double> _floatingAnimation;
  
  final AudioService _audioService = AudioService();
  bool _showNotification = true;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoRotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _floatingAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    // Start animations
    _fadeController.forward();
    _logoController.forward();
    
    // Load player data and initialize audio
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    // Load player data
    final authRepo = getIt<AuthRepository>();
    final playerData = await authRepo.getPlayerData();
    
    if (playerData != null && mounted) {
      context.read<AuthBloc>().add(AuthLoadExistingUser());
    }

    // Initialize audio service
    await _audioService.initialize();
    
    // Start background music
    if (mounted) {
      await _audioService.playBackgroundMusic();
    }

    // Show welcome notification after delay
    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted && _showNotification) {
        NotificationService.show(
          context,
          message: 'welcome_back'.tr(),
          icon: Icons.celebration,
          backgroundColor: Colors.deepPurple,
        );
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _logoController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade900,
              Colors.deepPurple.shade800,
              Colors.indigo.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  
                  // Player Profile Card
                  FutureBuilder(
                    future: getIt<AuthRepository>().getPlayerData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return PlayerProfileCard(player: snapshot.data!);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Daily Quest Preview
                  const DailyQuestPreview(),
                  
                  const SizedBox(height: 32),
                  
                  // Logo with floating animation
                  AnimatedBuilder(
                    animation: _floatingAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatingAnimation.value),
                        child: child,
                      );
                    },
                    child: ScaleTransition(
                      scale: _logoScaleAnimation,
                      child: RotationTransition(
                        turns: _logoRotateAnimation,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.3),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.5),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '🐍',
                              style: TextStyle(fontSize: 60),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Game Title
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.amber, Colors.orange, Colors.amber],
                    ).createShader(bounds),
                    child: const Text(
                      'SNAKE EMPIRES',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Menu Buttons
                  MenuButton(
                    icon: Icons.play_arrow,
                    label: 'new_game'.tr(),
                    onPressed: () {
                      _showComingSoon('game_screen');
                    },
                  ),
                  
                  const SizedBox(height: 12),
                  
                  MenuButton(
                    icon: Icons.play_circle_outline,
                    label: 'continue_game'.tr(),
                    isPrimary: false,
                    onPressed: () {
                      _showComingSoon('continue_game');
                    },
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: MenuButton(
                          icon: Icons.location_city,
                          label: 'city'.tr(),
                          isPrimary: false,
                          onPressed: () {
                            _showComingSoon('city_screen');
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MenuButton(
                          icon: Icons.emoji_events,
                          label: 'quests'.tr(),
                          isPrimary: false,
                          onPressed: () {
                            _showComingSoon('quests_screen');
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  MenuButton(
                    icon: Icons.settings,
                    label: 'settings'.tr(),
                    isPrimary: false,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Version info
                  Text(
                    'version_1_0_0'.tr(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    NotificationService.show(
      context,
      message: '${'coming_soon'.tr()}: ${feature.tr()}',
      icon: Icons.access_time,
      backgroundColor: Colors.orange,
    );
  }
}

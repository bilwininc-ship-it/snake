import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:snake_empires/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:snake_empires/features/auth/presentation/bloc/auth_event.dart';
import 'package:snake_empires/features/auth/presentation/bloc/auth_state.dart';
import 'package:snake_empires/features/auth/presentation/screens/welcome_screen.dart';
import 'package:snake_empires/shared/screens/main_menu_screen.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _glowController;
  late AnimationController _particleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _glowAnimation;
  
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    
    // Main animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    // Glow animation controller
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    // Particle animation controller
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
    
    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    
    // Initialize particles
    for (int i = 0; i < 30; i++) {
      _particles.add(Particle());
    }
    
    _animationController.forward();
    
    // Check first launch after animation
    Future.delayed(const Duration(milliseconds: 800), () {
      context.read<AuthBloc>().add(AuthCheckFirstLaunch());
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFirstLaunch) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            );
          });
        } else if (state is AuthReturningUser) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainMenuScreen()),
            );
          });
        }
      },
      child: Scaffold(
        body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0A0E27),
                const Color(0xFF1A1F3A),
                const Color(0xFF2D1B4E),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Animated particles background
              ...List.generate(_particles.length, (index) {
                return AnimatedBuilder(
                  animation: _particleController,
                  builder: (context, child) {
                    _particles[index].update();
                    return Positioned(
                      left: _particles[index].x * size.width,
                      top: _particles[index].y * size.height,
                      child: Container(
                        width: _particles[index].size,
                        height: _particles[index].size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _particles[index].color.withOpacity(0.6),
                          boxShadow: [
                            BoxShadow(
                              color: _particles[index].color.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
              
              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated glow effect
                    AnimatedBuilder(
                      animation: _glowAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 200 + (_glowAnimation.value * 50),
                          height: 200 + (_glowAnimation.value * 50),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.purple.withOpacity(0.3 * _glowAnimation.value),
                                Colors.deepPurple.withOpacity(0.2 * _glowAnimation.value),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    
                    // Logo with scale animation
                    Positioned.fill(
                      child: Center(
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.amber.withOpacity(0.8),
                                    Colors.orange.withOpacity(0.6),
                                    Colors.deepOrange.withOpacity(0.4),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.6),
                                    blurRadius: 60,
                                    spreadRadius: 20,
                                  ),
                                  BoxShadow(
                                    color: Colors.purple.withOpacity(0.4),
                                    blurRadius: 80,
                                    spreadRadius: 30,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '🐍',
                                  style: TextStyle(
                                    fontSize: 100,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 100),
                    
                    // Game title
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.amber,
                            Colors.orange,
                            Colors.amber,
                          ],
                        ).createShader(bounds),
                        child: Text(
                          'SNAKE EMPIRES',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 6,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                              Shadow(
                                color: Colors.purple.withOpacity(0.5),
                                blurRadius: 30,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Loading indicator with text
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.amber,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 45,
                                height: 45,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.purple.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'loading_game'.tr().toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                              letterSpacing: 3,
                              shadows: [
                                Shadow(
                                  color: Colors.amber.withOpacity(0.5),
                                  blurRadius: 10,
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
              
              // Version info at bottom
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Center(
                    child: Text(
                      'version_1_0_0'.tr(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.4),
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Particle class for animated background
class Particle {
  double x;
  double y;
  double size;
  double speedX;
  double speedY;
  Color color;
  
  Particle()
      : x = math.Random().nextDouble(),
        y = math.Random().nextDouble(),
        size = math.Random().nextDouble() * 4 + 2,
        speedX = (math.Random().nextDouble() - 0.5) * 0.002,
        speedY = (math.Random().nextDouble() - 0.5) * 0.002,
        color = [Colors.amber, Colors.purple, Colors.cyan, Colors.pink]
            [math.Random().nextInt(4)];
  
  void update() {
    x += speedX;
    y += speedY;
    
    if (x < 0 || x > 1) speedX *= -1;
    if (y < 0 || y > 1) speedY *= -1;
    
    x = x.clamp(0.0, 1.0);
    y = y.clamp(0.0, 1.0);
  }
}

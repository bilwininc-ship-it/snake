import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_empires/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:snake_empires/features/auth/presentation/bloc/auth_event.dart';
import 'package:snake_empires/features/auth/presentation/bloc/auth_state.dart';
import 'package:snake_empires/features/auth/presentation/screens/welcome_screen.dart';
import 'package:snake_empires/shared/screens/main_menu_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _animationController.forward();
    
    // Check first launch after animation
    Future.delayed(const Duration(milliseconds: 500), () {
      context.read<AuthBloc>().add(AuthCheckFirstLaunch());
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFirstLaunch) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            );
          });
        } else if (state is AuthReturningUser) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainMenuScreen()),
            );
          });
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple.shade900,
                Colors.deepPurple.shade700,
                Colors.indigo.shade900,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
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
                          '',
                          style: TextStyle(fontSize: 80),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'SNAKE EMPIRES',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

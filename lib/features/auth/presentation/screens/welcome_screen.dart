import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_empires/core/constants/app_constants.dart';
import 'package:snake_empires/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:snake_empires/features/auth/presentation/bloc/auth_event.dart';
import 'package:snake_empires/features/auth/presentation/bloc/auth_state.dart';
import 'package:snake_empires/features/auth/presentation/screens/name_input_screen.dart';
import 'package:snake_empires/core/services/localization_service.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLanguageSelected) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NameInputScreen(language: state.language),
            ),
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.indigo.shade900,
                Colors.purple.shade800,
                Colors.deepPurple.shade900,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('', style: TextStyle(fontSize: 70)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    LocalizationService.translate(context, 'welcome'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    LocalizationService.translate(context, 'select_language'),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    flex: 3,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 2.5,
                      ),
                      itemCount: AppConstants.supportedLanguages.length,
                      itemBuilder: (context, index) {
                        final entry = AppConstants.supportedLanguages.entries.elementAt(index);
                        return _LanguageCard(
                          languageCode: entry.key,
                          languageName: entry.value,
                          onTap: () {
                            LocalizationService.setLocale(context, entry.key);
                            context.read<AuthBloc>().add(AuthSelectLanguage(entry.key));
                          },
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String languageCode;
  final String languageName;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.languageCode,
    required this.languageName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.1),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              languageName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

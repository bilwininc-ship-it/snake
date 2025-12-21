import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_empires/core/constants/app_constants.dart';
import 'package:snake_empires/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:snake_empires/features/auth/presentation/bloc/auth_event.dart';
import 'package:snake_empires/features/auth/presentation/bloc/auth_state.dart';
import 'package:snake_empires/shared/screens/main_menu_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class AvatarSelectionScreen extends StatefulWidget {
  final String language;
  final String name;
  
  const AvatarSelectionScreen({
    super.key,
    required this.language,
    required this.name,
  });

  @override
  State<AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends State<AvatarSelectionScreen> {
  String? _selectedAvatar;

  void _selectAvatar(String avatar) {
    setState(() {
      _selectedAvatar = avatar;
    });
  }

  void _completeRegistration() {
    if (_selectedAvatar != null) {
      context.read<AuthBloc>().add(
        AuthSelectAvatar(widget.language, widget.name, _selectedAvatar!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthCompleted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const MainMenuScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.pink.shade600,
                Colors.purple.shade700,
                Colors.deepPurple.shade900,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'select_avatar'.tr(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: AppConstants.avatarList.length,
                      itemBuilder: (context, index) {
                        final avatar = AppConstants.avatarList[index];
                        final isSelected = _selectedAvatar == avatar;
                        
                        return GestureDetector(
                          onTap: () => _selectAvatar(avatar),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? Colors.amber 
                                  : Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected 
                                    ? Colors.amber.shade700 
                                    : Colors.white.withOpacity(0.3),
                                width: isSelected ? 4 : 2,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.amber.withOpacity(0.5),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: Text(
                                avatar,
                                style: TextStyle(
                                  fontSize: isSelected ? 50 : 45,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _selectedAvatar != null ? _completeRegistration : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        disabledBackgroundColor: Colors.grey.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'start_adventure'.tr(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.arrow_forward, color: Colors.black87),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

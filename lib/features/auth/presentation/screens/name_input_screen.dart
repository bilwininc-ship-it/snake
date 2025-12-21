import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_empires/core/constants/app_constants.dart';
import 'package:snake_empires/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:snake_empires/features/auth/presentation/bloc/auth_event.dart';
import 'package:snake_empires/features/auth/presentation/bloc/auth_state.dart';
import 'package:snake_empires/features/auth/presentation/screens/avatar_selection_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class NameInputScreen extends StatefulWidget {
  final String language;
  
  const NameInputScreen({super.key, required this.language});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isValid = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _validateAndProceed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthEnterName(_nameController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthNameEntered) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AvatarSelectionScreen(
                language: state.language,
                name: state.name,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepPurple.shade900,
                Colors.purple.shade700,
                Colors.pink.shade600,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(
                      'enter_name'.tr(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _nameController,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: 'name_hint'.tr(),
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 20,
                          ),
                          prefixIcon: const Icon(
                            Icons.person,
                            size: 28,
                            color: Colors.deepPurple,
                          ),
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
                        onChanged: (value) {
                          setState(() {
                            _isValid = value.trim().length >= AppConstants.minNameLength;
                          });
                        },
                        onFieldSubmitted: (_) => _validateAndProceed(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${_nameController.text.length}/',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(flex: 2),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isValid ? _validateAndProceed : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          disabledBackgroundColor: Colors.grey.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                        ),
                        child: Text(
                          'continue'.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
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
      ),
    );
  }
}

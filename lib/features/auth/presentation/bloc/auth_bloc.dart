import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_empires/features/auth/data/models/player_data.dart';
import 'package:snake_empires/features/auth/data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthCheckFirstLaunch>(_onCheckFirstLaunch);
    on<AuthSelectLanguage>(_onSelectLanguage);
    on<AuthEnterName>(_onEnterName);
    on<AuthSelectAvatar>(_onSelectAvatar);
    on<AuthLoadExistingUser>(_onLoadExistingUser);
  }
  
  Future<void> _onCheckFirstLaunch(
    AuthCheckFirstLaunch event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      await authRepository.init();
      final isFirstLaunch = await authRepository.isFirstLaunch();
      
      if (isFirstLaunch) {
        emit(AuthFirstLaunch());
      } else {
        final playerData = await authRepository.getPlayerData();
        if (playerData != null) {
          emit(AuthReturningUser(playerData));
        } else {
          emit(AuthFirstLaunch());
        }
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  
  Future<void> _onSelectLanguage(
    AuthSelectLanguage event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLanguageSelected(event.language));
  }
  
  Future<void> _onEnterName(
    AuthEnterName event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is AuthLanguageSelected) {
      emit(AuthNameEntered(currentState.language, event.name));
    }
  }
  
  Future<void> _onSelectAvatar(
    AuthSelectAvatar event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final playerData = PlayerData(
        name: event.name,
        avatar: event.avatar,
        language: event.language,
        createdAt: DateTime.now(),
        isFirstLaunch: false,
      );
      
      await authRepository.savePlayerData(playerData);
      emit(AuthCompleted(playerData));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  
  Future<void> _onLoadExistingUser(
    AuthLoadExistingUser event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final playerData = await authRepository.getPlayerData();
      if (playerData != null) {
        emit(AuthCompleted(playerData));
      } else {
        emit(AuthFirstLaunch());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

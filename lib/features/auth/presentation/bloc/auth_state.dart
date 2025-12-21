import 'package:equatable/equatable.dart';
import 'package:snake_empires/features/auth/data/models/player_data.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthFirstLaunch extends AuthState {}

class AuthReturningUser extends AuthState {
  final PlayerData playerData;
  
  const AuthReturningUser(this.playerData);
  
  @override
  List<Object?> get props => [playerData];
}

class AuthLanguageSelected extends AuthState {
  final String language;
  
  const AuthLanguageSelected(this.language);
  
  @override
  List<Object?> get props => [language];
}

class AuthNameEntered extends AuthState {
  final String language;
  final String name;
  
  const AuthNameEntered(this.language, this.name);
  
  @override
  List<Object?> get props => [language, name];
}

class AuthCompleted extends AuthState {
  final PlayerData playerData;
  
  const AuthCompleted(this.playerData);
  
  @override
  List<Object?> get props => [playerData];
}

class AuthError extends AuthState {
  final String message;
  
  const AuthError(this.message);
  
  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

class AuthCheckFirstLaunch extends AuthEvent {}

class AuthSelectLanguage extends AuthEvent {
  final String language;
  
  const AuthSelectLanguage(this.language);
  
  @override
  List<Object?> get props => [language];
}

class AuthEnterName extends AuthEvent {
  final String name;
  
  const AuthEnterName(this.name);
  
  @override
  List<Object?> get props => [name];
}

class AuthSelectAvatar extends AuthEvent {
  final String language;
  final String name;
  final String avatar;
  
  const AuthSelectAvatar(this.language, this.name, this.avatar);
  
  @override
  List<Object?> get props => [language, name, avatar];
}

class AuthLoadExistingUser extends AuthEvent {}

// lib/blocs/auth_event.dart
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  LoginRequested({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class CheckLoginStatus extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

class QuickLoginRequested extends AuthEvent {}

class PasswordResetRequested extends AuthEvent {
  final String email;

  PasswordResetRequested({required this.email});

  @override
  List<Object> get props => [email];
}
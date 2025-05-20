// lib/blocs/auth_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_development/models/user_model.dart'; // Adjust path if needed

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel user;

  AuthSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({required this.error});

  @override
  List<Object> get props => [error];
}

// Emitted by CheckLoginStatus if token exists but no specific user data loaded yet.
// Or, can be a general state signifying user is logged in.
class Authenticated extends AuthState {}

// Emitted when user is not logged in or after logout.
class Unauthenticated extends AuthState {}

// A generic success state that can be used for actions like password reset confirmation.
class AuthOperationSuccess extends AuthState {
  final String message;

  AuthOperationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

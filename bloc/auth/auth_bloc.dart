// lib/blocs/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_development/data/auth_data.dart'; // Adjust path
import 'package:flutter_development/models/user_model.dart'; // Adjust path for UserModel
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthData authData;

  AuthBloc({required this.authData}) : super(AuthInitial()) {
    on<CheckLoginStatus>(_onCheckLoginStatus);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<QuickLoginRequested>(_onQuickLoginRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
  }

  Future<void> _onCheckLoginStatus(CheckLoginStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading()); // Indicate loading while checking
    await Future.delayed(const Duration(milliseconds: 50)); // Small delay to ensure loading UI can show

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      // Optional: Validate token with a lightweight backend call here
      // Or, attempt to reconstruct UserModel from SharedPreferences for immediate use
      final String? name = prefs.getString('name');
      final int? userId = prefs.getInt('user_id');
      final int? companyId = prefs.getInt('company_id');
      final String? companyName = prefs.getString('company_name');

      if (name != null && userId != null && companyId != null && companyName != null) {
         // Emit AuthSuccess if we have enough data to reconstruct a UserModel.
         // This allows the app to potentially start with user data available.
        emit(AuthSuccess(
            user: UserModel(
              token: token,
              name: name,
              userId: userId,
              companyId: companyId,
              companyName: companyName,
            )
        ));
      } else {
        // If critical user details are missing, treat as simply Authenticated (token exists)
        // or even Unauthenticated if that data is essential for app function.
        // For this example, Authenticated is fine; the user will be prompted to login if issues arise.
        emit(Authenticated());
      }
    } else {
      emit(Unauthenticated());
    }
  }

Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
  emit(AuthLoading());
  try {
    final user = await authData.login(event.username, event.password);
    emit(AuthSuccess(user: user));
  } catch (e) {
    String errorMessage = e.toString().replaceFirst("Exception: ", "");
    //print("AuthBloc emitting AuthFailure with error: $errorMessage"); // +++ ADD THIS +++
    emit(AuthFailure(error: errorMessage));
  }
}

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authData.logout();
      emit(Unauthenticated());
    } catch (e) {
      // Even on error, transition to Unauthenticated on client-side
      emit(Unauthenticated());
    //  print("AuthBloc: Error during logout: $e. Client forced to Unauthenticated.");
    }
  }

  Future<void> _onQuickLoginRequested(QuickLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authData.quickLogin();
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(error: e.toString().replaceFirst("Exception: ", "")));
    }
  }

  Future<void> _onPasswordResetRequested(PasswordResetRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final message = await authData.requestPasswordReset(event.email);
      emit(AuthOperationSuccess(message: message));
    } catch (e) {
      emit(AuthFailure(error: e.toString().replaceFirst("Exception: ", "")));
    }
  }
}
// lib/widgets/login_auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_development/bloc/auth/auth_bloc.dart';
import 'package:flutter_development/bloc/auth/auth_state.dart';

import 'package:flutter_development/screen/hrms/login_screen.dart';


import 'package:flutter_development/screen/main_navigation_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  static const ValueKey _loginScreenKey = ValueKey('LoginScreenInstance');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        //print("AuthWrapper building with state: $state");

        if (state is AuthSuccess || state is Authenticated) {
          //print("AuthWrapper: Navigating to MainNavigationScreen");
          return const MainNavigationScreen();
        } else if (state is AuthInitial) { // Only show full-page loading for the very first state
          //print("AuthWrapper: Showing Initializing/Loading screen");
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Initializing..."),
                ],
              ),
            ),
          );
        } else {
          // Covers: Unauthenticated, AuthFailure, AuthLoading (that isn't AuthInitial)
          // The LoginScreen will handle its own loading indicators for login attempts.
         // print("AuthWrapper: Showing LoginScreen (state: $state)");
          return const LoginScreen(key: _loginScreenKey);
        }
      },
    );
  }
}
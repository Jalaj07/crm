// lib/screen/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_development/bloc/auth/auth_bloc.dart';
import 'package:flutter_development/bloc/auth/auth_event.dart';
import 'package:flutter_development/bloc/auth/auth_state.dart';

import 'package:flutter_development/widgets/login/login_email_field_widget.dart';
import 'package:flutter_development/widgets/login/login_forgot_password_button_widget.dart';
import 'package:flutter_development/widgets/login/login_forgot_password_dialog_content.dart';
import 'package:flutter_development/widgets/login/login_button_widget.dart';
import 'package:flutter_development/widgets/login/login_logo_widget.dart';
import 'package:flutter_development/widgets/login/login_or_divider_widget.dart';
import 'package:flutter_development/widgets/login/login_password_field_widget.dart';
import 'package:flutter_development/widgets/login/quick_login_section_widget.dart';
import 'package:flutter_development/widgets/login/login_welcome_text_widget.dart';
import 'package:flutter_development/constants/login_constants.dart'; // Ensure path is correct

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

enum LoginAction { none, mainLogin, quickLogin, passwordReset }

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  LoginAction _currentActionLoading = LoginAction.none;
  bool _isPasswordResetDialogActive = false;
  String? _loginErrorText;

  @override
  void initState() {
    super.initState();
    // print("LoginScreenState initState CALLED"); // Can be removed if not debugging this specifically
  }

  @override
  void dispose() {
    // print("LoginScreenState dispose CALLED"); // Can be removed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearErrorText() {
    if (mounted && _loginErrorText != null) {
      setState(() {
        _loginErrorText = null;
      });
    }
  }

  void _login() {
    FocusScope.of(context).unfocus();
    _clearErrorText();
    if (_formKey.currentState!.validate()) {
      if (mounted) setState(() => _currentActionLoading = LoginAction.mainLogin);
      context.read<AuthBloc>().add(LoginRequested(
            username: _emailController.text.trim(),
            password: _passwordController.text,
          ));
    }
  }

  void _quickLogin() {
    FocusScope.of(context).unfocus();
    _clearErrorText();
    if (mounted) setState(() => _currentActionLoading = LoginAction.quickLogin);
    context.read<AuthBloc>().add(QuickLoginRequested());
  }

  void _togglePasswordVisibility() {
    if (mounted) setState(() => _obscurePassword = !_obscurePassword);
  }

  void _showForgotPasswordDialog() {
    _clearErrorText();
    if (mounted) {
      setState(() {
        _currentActionLoading = LoginAction.passwordReset;
        _isPasswordResetDialogActive = true;
      });
    }
    showDialog(
      context: context,
      barrierDismissible: _currentActionLoading != LoginAction.passwordReset,
      builder: (dialogContext) {
        return BlocBuilder<AuthBloc, AuthState>(
            builder: (blocContext, blocState) {
              final bool isLoadingForDialogButton = blocState is AuthLoading && _currentActionLoading == LoginAction.passwordReset;
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                title: const Text('Forgot Password', style: TextStyle(fontWeight: FontWeight.w600)),
                content: ForgotPasswordDialogContent(
                  isLoading: isLoadingForDialogButton,
                  onSubmit: (email) {
                    blocContext.read<AuthBloc>().add(PasswordResetRequested(email: email));
                  },
                ),
              );
            },
        );
      },
    ).then((_) {
      if (mounted) {
        setState(() {
          if (_currentActionLoading == LoginAction.passwordReset) {
            _currentActionLoading = LoginAction.none;
          }
          _isPasswordResetDialogActive = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            if (mounted) {
              setState(() {
                _currentActionLoading = LoginAction.none;
                _loginErrorText = null;
            });
            }
          } else if (state is AuthFailure) {
            String displayError = state.error.isNotEmpty ? state.error : "Login failed. Please try again.";
            if (displayError.toLowerCase().contains("500") || displayError.toLowerCase().contains("server error")) {
                displayError = "Invalid username or password. Please try again.";
            }
            
            if (mounted) {
              setState(() {
                _loginErrorText = displayError;
                _currentActionLoading = LoginAction.none;
              });
            }
          } else if (state is AuthOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            if (_currentActionLoading == LoginAction.passwordReset && _isPasswordResetDialogActive && Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            if (mounted) {
              setState(() {
                _currentActionLoading = LoginAction.none;
                _loginErrorText = null;
            });
            }
          } else if (state is AuthLoading) {
            if (_currentActionLoading == LoginAction.mainLogin || _currentActionLoading == LoginAction.quickLogin) {
                _clearErrorText(); // Clear error text when these primary login actions start loading
            }
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            bool isMainLoginProcessing = _currentActionLoading == LoginAction.mainLogin && state is AuthLoading;
            bool isQuickLoginProcessing = _currentActionLoading == LoginAction.quickLogin && state is AuthLoading;
            bool isPasswordResetProcessing = _currentActionLoading == LoginAction.passwordReset && state is AuthLoading;
            bool isAnyOtherActionProcessing(LoginAction forAction) => 
                state is AuthLoading && _currentActionLoading != LoginAction.none && _currentActionLoading != forAction;


            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/login7.jpg', fit: BoxFit.cover),
                Container(color: Colors.white.withAlpha(204)),
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: kSpacingLarge, vertical: kSpacingXLarge),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Container(
                          padding: const EdgeInsets.all(kSpacingLarge),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 234, 234, 234),
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 12, offset: const Offset(0, 5)),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const LogoWidget(),
                                const WelcomeTextWidget(),
                                const SizedBox(height: kSpacingXLarge),
                                QuickLoginSectionWidget(
                                  onQuickLogin: isAnyOtherActionProcessing(LoginAction.quickLogin) || isQuickLoginProcessing ? null : _quickLogin,
                                  isQuickLoginLoading: isQuickLoginProcessing,
                                ),
                                if (_currentActionLoading != LoginAction.quickLogin || !isQuickLoginProcessing) const OrDividerWidget(),
                                EmailFieldWidget(
                                  controller: _emailController,
                                  errorText: null, 
                                  onChanged: (value) => _clearErrorText(),
                                ),
                                const SizedBox(height: kSpacingMedium),
                                PasswordFieldWidget(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  onToggleVisibility: _togglePasswordVisibility,
                                  errorText: null, 
                                  onChanged: (value) => _clearErrorText(),
                                  onSubmitted: () {
                                    if (!isMainLoginProcessing && !isAnyOtherActionProcessing(LoginAction.mainLogin)) _login();
                                  },
                                ),
                                if (_loginErrorText != null && _loginErrorText!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                    child: Text(
                                      _loginErrorText!,
                                      style: const TextStyle(color: Colors.red, fontSize: 13.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ForgotPasswordButtonWidget(
                                  isLoading: isPasswordResetProcessing,
                                  onPressed: isAnyOtherActionProcessing(LoginAction.passwordReset) || isPasswordResetProcessing ? null : _showForgotPasswordDialog,
                                ),
                                LoginButtonWidget(
                                  onLogin: isAnyOtherActionProcessing(LoginAction.mainLogin) || isMainLoginProcessing ? null : _login,
                                  isAnyLoading: isMainLoginProcessing,
                                ),
                                const SizedBox(height: kSpacingSmall),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              
              ],
            );
          },
        ),
      ),
    );
  }
}
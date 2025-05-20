// auth_provider.dart
// <<< MODIFIED FILE >>>

import 'package:flutter/foundation.dart'; // Use foundation for ChangeNotifier
import 'package:shared_preferences/shared_preferences.dart';

// --- User Class ---
class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profileImage: json['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
    };
  }
}

// --- AuthProvider ---
class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  bool _isLoadingQuickLogin = false; // Separate loading state for quick login
  String? _lastLoggedInEmail; // Store the last email

  // Keys for SharedPreferences
  static const String _lastEmailKey = 'last_logged_in_email';

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading; // For regular login/password reset
  bool get isLoadingQuickLogin =>
      _isLoadingQuickLogin; // For quick login specifically
  String? get lastLoggedInEmail => _lastLoggedInEmail;

  AuthProvider() {
    // Load the last logged-in email when the provider is created
    _loadLastLoggedInEmail();
  }

  // --- Load last email from storage ---
  Future<void> _loadLastLoggedInEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _lastLoggedInEmail = prefs.getString(_lastEmailKey);
      // Don't notify listeners immediately if this is part of initial setup,
      // unless widgets need to react instantly to the presence/absence of saved email.
      // Let's notify, as the LoginScreen UI depends on this value.
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading last email: $e');
      // Handle error appropriately, maybe log it
    }
  }

  // --- Save last email to storage ---
  Future<void> _saveLastLoggedInEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastEmailKey, email);
      _lastLoggedInEmail = email; // Update local state as well
      // No need to notify here usually, as it happens within login actions that already notify.
    } catch (e) {
      debugPrint('Error saving last email: $e');
      // Handle error appropriately
    }
  }

  // --- Clear last email from storage (Now ONLY used if Quick Login fails for some reason) ---
  Future<void> _clearLastLoggedInEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastEmailKey);
      _lastLoggedInEmail = null; // Clear local state
      // It's okay to notify here if we expect UI to react to a failed quick login clearing the hint
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing last email: $e');
      // Handle error appropriately
    }
  }

  // --- Regular Login ---
  Future<bool> login(String email, String password) async {
    if (_isLoading || _isLoadingQuickLogin) {
      return false; // Prevent concurrent actions
    }
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // --- Simulated backend check ---
    bool success =
        (email.trim().toLowerCase() == 'test@example.com' &&
            password == 'password123') ||
        (email.trim().toLowerCase() == 'user@test.com' &&
            password == 'flutter');

    if (success) {
      _user = User(
        id: 'user_${email.trim().split('@')[0]}',
        name: 'User',
        email: email.trim(),
        profileImage: null,
      );
      await _saveLastLoggedInEmail(
        email.trim(),
      ); // Save email on successful login
    } else {
      _user = null; // Ensure user is null on failure
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  // --- Quick Login (Using Saved Email - No Password Needed for Demo) ---
  Future<bool> quickLogin() async {
    if (_isLoading || _isLoadingQuickLogin) {
      return false; // Prevent concurrent actions
    }
    if (_lastLoggedInEmail == null) {
      debugPrint('Quick Login attempted with no saved email.');
      return false; // Should not happen if button is shown correctly
    }

    _isLoadingQuickLogin = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // --- Demo Simulation: Use stored token or session in real app ---
    // Here, we just check if the saved email is one of the known ones.
    final email = _lastLoggedInEmail!; // We know it's not null here
    bool success = email == 'test@example.com' || email == 'user@test.com';

    if (success) {
      _user = User(
        id: 'user_${email.split('@')[0]}',
        name: 'User',
        email: email,
        profileImage: null,
      );
      // No need to save email again, it's already saved
    } else {
      // This case might occur if the saved email is somehow invalid or user was deleted
      debugPrint('Quick Login failed for saved email: $email');
      _user = null;
      // <<< IMPORTANT: Clear the invalid email hint if quick login fails >>>
      await _clearLastLoggedInEmail(); // Clear invalid saved email
    }

    _isLoadingQuickLogin = false;
    notifyListeners();
    return success;
  }

  // --- Logout ---
  // <<< MODIFICATION START >>>
  Future<void> logout() async {
    _user = null; // Log the user out by clearing the user object

    // await _clearLastLoggedInEmail(); // <<< REMOVED/COMMENTED OUT THIS LINE
    // By not clearing the last logged-in email, the hint will remain on the login screen.

    // Reset loading states maybe? Depending on app flow.
    _isLoading = false;
    _isLoadingQuickLogin = false;
    notifyListeners(); // Notify listeners that authentication state changed (user is null)
    // but lastLoggedInEmail remains unchanged.
  }
  // <<< MODIFICATION END >>>

  // --- Forgot Password (Simulation) ---
  Future<bool> requestPasswordReset(String email) async {
    if (_isLoading || _isLoadingQuickLogin) {
      return false; // Prevent concurrent actions
    }
    // Simulate loading - Reuse main indicator or add a specific one if needed
    _isLoading = true;
    notifyListeners();

    // Simulate network call to backend API
    await Future.delayed(const Duration(seconds: 2));
    debugPrint('Password reset requested for: $email');

    // In a real app, check the API response.
    // bool success = await MyApi.sendPasswordReset(email);

    // Simulate success for now
    bool success = true;

    _isLoading = false;
    notifyListeners();
    return success; // Indicate success/failure based on API response
  }
}

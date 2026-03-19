import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _userRole;
  String? _userName;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get userRole => _userRole;
  String? get userName => _userName;

  /// Authenticate with email and password.
  Future<bool> loginWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // TODO: Backend Integration - Send POST request to /api/auth/login with email and password. Validate response token.
    await Future.delayed(const Duration(seconds: 2));

    _isAuthenticated = true;
    _userName = email.split('@').first;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  /// Create a new account with full name, email, and password.
  Future<bool> signUp(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // TODO: Backend Integration - Send POST request to /api/auth/register with name, email, password. Store returned auth token.
    await Future.delayed(const Duration(seconds: 2));

    _isAuthenticated = true;
    _userName = name;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  /// Authenticate via Google Sign-In.
  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    // TODO: Backend Integration - Trigger Google Sign-In flow, send ID token to /api/auth/google for verification.
    await Future.delayed(const Duration(seconds: 2));

    _isAuthenticated = true;
    _userName = 'Google User';
    _isLoading = false;
    notifyListeners();
    return true;
  }

  /// Send password reset email.
  Future<void> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    // TODO: Backend Integration - Send POST request to /api/auth/forgot-password with email.
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  /// Set the selected user persona/role.
  void setUserRole(String role) {
    _userRole = role;
    // TODO: Backend Integration - Send PUT request to /api/user/profile to persist selected role.
    notifyListeners();
  }

  /// Log the user out and clear all state.
  void logout() {
    _isAuthenticated = false;
    _userRole = null;
    _userName = null;
    // TODO: Backend Integration - Invalidate auth token on server via POST /api/auth/logout.
    notifyListeners();
  }
}

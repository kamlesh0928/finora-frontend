import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userRole; // 'Farmer', 'Women', 'Student', 'Young Adult'

  bool get isAuthenticated => _isAuthenticated;
  String? get userRole => _userRole;

  Future<void> loginWithGoogle() async {
    // TODO: Implement actual GoogleSignIn logic here later
    await Future.delayed(
      const Duration(seconds: 1),
    ); // Simulate network request
    _isAuthenticated = true;
    notifyListeners();
  }

  void setUserRole(String role) {
    _userRole = role;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _userRole = null;
    notifyListeners();
  }
}

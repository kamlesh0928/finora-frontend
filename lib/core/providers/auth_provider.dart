import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';
import '../storage/hive_storage.dart';

class AuthProvider extends ChangeNotifier {
  final _api = ApiService();
  final _storage = HiveStorage();

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _user;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;
  String? get userRole => _user?.role ?? _storage.getRole();
  String? get userName => _user?.name;
  String get language => _user?.language ?? _storage.getLanguage();

  Future<void> _saveUserData(UserModel user) async {
    await _storage.saveUser(user);
    if (user.role != null) {
      await _storage.saveRole(user.role!);
    }
    await _storage.saveWalletBalance(user.walletBalance);
    await _storage.saveEmergencyFund(user.emergencyFund);
    await _storage.saveTotalEarned(user.totalEarned);
    await _storage.saveTotalSpent(user.totalSpent);
  }

  /// Try to restore session from local storage.
  /// Validates the token with the backend if online; falls back to cache if offline.
  Future<void> tryAutoLogin() async {
    final token = _storage.getToken();
    final cachedUser = _storage.getUser();

    if (token == null || cachedUser == null) {
      _isAuthenticated = false;
      notifyListeners();
      return;
    }

    // Optimistically set authenticated from cache
    _user = cachedUser;

    // Validate token with server
    try {
      final data = await _api.get('/user/profile');
      _user = UserModel.fromJson(data);
      await _saveUserData(_user!);
      _isAuthenticated = true;
    } on ApiException catch (e) {
      if (e.statusCode == 401 || e.statusCode == 403) {
        // Token expired or invalid — force re-login
        _isAuthenticated = false;
        _user = null;
        await _api.clearToken();
        await _storage.clearToken();
        await _storage.clearUser();
        notifyListeners();
        return;
      }
      // Other server errors — trust cached data (offline-first)
      _isAuthenticated = true;
    } catch (_) {
      // Network unreachable — trust cached data
      _isAuthenticated = true;
    }

    notifyListeners();
  }

  /// Authenticate with email and password.
  Future<bool> loginWithEmail(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _api.post(
        '/auth/login',
        body: {'email': email, 'password': password},
        auth: false,
      );

      final token = data['access_token'] as String;
      _user = UserModel.fromJson(data['user']);

      await _api.saveToken(token);
      await _storage.saveToken(token);
      await _saveUserData(_user!);

      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      if (e is ApiException) {
        if (e.statusCode == 0) {
          _errorMessage = 'No internet connection. Please connect to sign in.';
        } else if (e.statusCode == 404) {
          _errorMessage = 'User not found. Please sign up first.';
        } else {
          _errorMessage = e.message;
        }
      } else {
        _errorMessage = 'An unexpected error occurred';
      }
      notifyListeners();
      return false;
    }
  }

  /// Create a new account.
  Future<bool> signUp(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _api.post(
        '/auth/register',
        body: {'name': name, 'email': email, 'password': password},
        auth: false,
      );

      final token = data['access_token'] as String;
      _user = UserModel.fromJson(data['user']);

      await _api.saveToken(token);
      await _storage.saveToken(token);
      await _saveUserData(_user!);

      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      if (e is ApiException) {
        if (e.statusCode == 0) {
          _errorMessage = 'Internet required for first-time signup.';
        } else {
          _errorMessage = e.message;
        }
      } else {
        _errorMessage = 'An unexpected error occurred';
      }
      notifyListeners();
      return false;
    }
  }

  /// Authenticate via Google Sign-In.
  Future<bool> loginWithGoogle({bool isSignUp = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final googleSignIn = GoogleSignIn(scopes: ['email']);
      // Force account selection dialog by signing out first
      await googleSignIn.signOut();

      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        _isLoading = false;
        _errorMessage = 'Google sign-in cancelled';
        notifyListeners();
        return false;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken ?? '';

      final data = await _api.post(
        '/auth/google',
        body: {
          'id_token': idToken,
          'name': googleUser.displayName ?? googleUser.email.split('@').first,
          'email': googleUser.email,
          'is_signup': isSignUp,
        },
        auth: false,
      );

      final token = data['access_token'] as String;
      _user = UserModel.fromJson(data['user']);

      await _api.saveToken(token);
      await _storage.saveToken(token);
      await _saveUserData(_user!);

      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      if (e is ApiException) {
        if (e.statusCode == 0) {
          _errorMessage = 'Internet required for Google sign-in.';
        } else if (e.statusCode == 404) {
          _errorMessage = 'User not found. Please sign up first.';
        } else {
          _errorMessage = e.message;
        }
      } else {
        _errorMessage = 'Google sign-in failed. Please try again.';
      }
      notifyListeners();
      return false;
    }
  }

  /// Set the selected user persona/role.
  Future<void> setUserRole(String role) async {
    _user = _user?.copyWith(role: role);
    await _storage.saveRole(role);
    if (_user != null) await _storage.saveUser(_user!);
    notifyListeners();

    try {
      final data = await _api.put('/user/profile', body: {'role': role});
      _user = UserModel.fromJson(data);
      await _saveUserData(_user!);
      notifyListeners();
    } catch (_) {}
  }

  /// Set the user's language preference.
  Future<void> setLanguage(String lang) async {
    _user = _user?.copyWith(language: lang);
    await _storage.saveLanguage(lang);
    if (_user != null) await _storage.saveUser(_user!);
    notifyListeners();

    try {
      await _api.put('/user/profile', body: {'language': lang});
    } catch (_) {}
  }

  /// Send password reset email.
  Future<void> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _api.post(
        '/auth/forgot-password',
        body: {'email': email},
        auth: false,
      );
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  /// Clear error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Log the user out and clear all state.
  Future<void> logout() async {
    try {
      await _api.post('/auth/logout');
    } catch (_) {}

    _isAuthenticated = false;
    _user = null;
    _errorMessage = null;
    await _api.clearToken();
    await _storage.clearToken();
    await _storage.clearUser();
    await _storage.clearAll();
    notifyListeners();
  }
}

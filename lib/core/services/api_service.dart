/// HTTP API service for communicating with the Finora backend.
/// Handles token management, error handling, and offline detection.

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  const ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String get _baseUrl => AppConstants.apiBaseUrl;

  /// Get the stored JWT token.
  String? get _token {
    final box = Hive.box(AppConstants.offlineBox);
    return box.get('auth_token') as String?;
  }

  /// Save the JWT token.
  Future<void> saveToken(String token) async {
    final box = Hive.box(AppConstants.offlineBox);
    await box.put('auth_token', token);
  }

  /// Clear the JWT token.
  Future<void> clearToken() async {
    final box = Hive.box(AppConstants.offlineBox);
    await box.delete('auth_token');
  }

  bool get hasToken => _token != null;

  /// Build headers with optional auth token.
  Map<String, String> _headers({bool auth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (auth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  /// Parse response and throw on error.
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body);
    }

    String message = 'Something went wrong';
    try {
      final body = jsonDecode(response.body);
      message = body['detail'] ?? body['message'] ?? message;
    } catch (_) {}

    throw ApiException(response.statusCode, message);
  }

  // ── HTTP Methods ──────────────────────────────────────────────────────────

  Future<dynamic> get(String path, {bool auth = true, Map<String, String>? queryParams}) async {
    try {
      final uri = Uri.parse('$_baseUrl$path').replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: _headers(auth: auth))
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on SocketException {
      throw const ApiException(0, 'No internet connection');
    } on HttpException {
      throw const ApiException(0, 'Network error');
    }
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body, bool auth = true}) async {
    try {
      final uri = Uri.parse('$_baseUrl$path');
      final response = await http.post(
        uri,
        headers: _headers(auth: auth),
        body: body != null ? jsonEncode(body) : null,
      ).timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on SocketException {
      throw const ApiException(0, 'No internet connection');
    } on HttpException {
      throw const ApiException(0, 'Network error');
    }
  }

  Future<dynamic> put(String path, {Map<String, dynamic>? body, bool auth = true}) async {
    try {
      final uri = Uri.parse('$_baseUrl$path');
      final response = await http.put(
        uri,
        headers: _headers(auth: auth),
        body: body != null ? jsonEncode(body) : null,
      ).timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on SocketException {
      throw const ApiException(0, 'No internet connection');
    } on HttpException {
      throw const ApiException(0, 'Network error');
    }
  }

  Future<dynamic> delete(String path, {bool auth = true}) async {
    try {
      final uri = Uri.parse('$_baseUrl$path');
      final response = await http.delete(uri, headers: _headers(auth: auth))
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on SocketException {
      throw const ApiException(0, 'No internet connection');
    } on HttpException {
      throw const ApiException(0, 'Network error');
    }
  }
}

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';

class HiveStorage {
  static final HiveStorage _instance = HiveStorage._internal();
  factory HiveStorage() => _instance;
  HiveStorage._internal();

  Box get _box => Hive.box(AppConstants.offlineBox);

  // User

  Future<void> saveUser(UserModel user) async {
    await _box.put('user', jsonEncode(user.toJson()));
  }

  UserModel? getUser() {
    final data = _box.get('user');
    if (data == null) return null;
    return UserModel.fromJson(jsonDecode(data));
  }

  Future<void> clearUser() async {
    await _box.delete('user');
  }

  // Auth Token

  Future<void> saveToken(String token) async {
    await _box.put('auth_token', token);
  }

  String? getToken() {
    return _box.get('auth_token') as String?;
  }

  Future<void> clearToken() async {
    await _box.delete('auth_token');
  }

  // Wallet Balance

  Future<void> saveWalletBalance(double balance) async {
    await _box.put('wallet_balance', balance);
  }

  double getWalletBalance() {
    return (_box.get('wallet_balance') ?? AppConstants.defaultWalletBalance)
        as double;
  }

  Future<void> saveEmergencyFund(double fund) async {
    await _box.put('emergency_fund', fund);
  }

  double getEmergencyFund() {
    return (_box.get('emergency_fund') ?? 0.0) as double;
  }

  Future<void> saveTotalEarned(double amount) async {
    await _box.put('total_earned', amount);
  }

  double getTotalEarned() {
    return (_box.get('total_earned') ?? 0.0) as double;
  }

  Future<void> saveTotalSpent(double amount) async {
    await _box.put('total_spent', amount);
  }

  double getTotalSpent() {
    return (_box.get('total_spent') ?? 0.0) as double;
  }

  // Transactions

  Future<void> addTransaction(TransactionModel txn) async {
    final txns = getTransactions();
    txns.insert(0, txn);
    // Keep only last 200 transactions locally
    if (txns.length > 200) txns.removeLast();
    await _box.put(
      'transactions',
      jsonEncode(txns.map((t) => t.toJson()).toList()),
    );
  }

  List<TransactionModel> getTransactions() {
    final data = _box.get('transactions');
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list.map((e) => TransactionModel.fromJson(e)).toList();
  }

  Future<void> clearTransactions() async {
    await _box.delete('transactions');
  }

  // Game Progress

  Future<void> saveCompletedScenarios(
    String module,
    List<String> scenarioIds,
  ) async {
    await _box.put('completed_$module', jsonEncode(scenarioIds));
  }

  List<String> getCompletedScenarios(String module) {
    final data = _box.get('completed_$module');
    if (data == null) return [];
    return (jsonDecode(data) as List).cast<String>();
  }

  // Sync Queue

  Future<void> addToSyncQueue(Map<String, dynamic> item) async {
    final queue = getSyncQueue();
    queue.add(item);
    await _box.put('sync_queue', jsonEncode(queue));
  }

  List<Map<String, dynamic>> getSyncQueue() {
    final data = _box.get('sync_queue');
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list.cast<Map<String, dynamic>>();
  }

  Future<void> clearSyncQueue() async {
    await _box.delete('sync_queue');
  }

  // Settings

  Future<void> saveLanguage(String lang) async {
    await _box.put('language', lang);
  }

  String getLanguage() {
    return (_box.get('language') ?? 'en') as String;
  }

  Future<void> saveRole(String role) async {
    await _box.put('selected_role', role);
  }

  String? getRole() {
    return _box.get('selected_role') as String?;
  }

  // Safety Score

  Future<void> saveSafetyScore(int score) async {
    await _box.put('safety_score', score);
  }

  int getSafetyScore() {
    return (_box.get('safety_score') ?? 0) as int;
  }

  // Stress Level

  Future<void> saveStressLevel(double level) async {
    await _box.put('stress_level', level);
  }

  double getStressLevel() {
    return (_box.get('stress_level') ?? 0.20) as double;
  }

  // Game Tracking

  Future<void> saveTotalDecisionsMade(int count) async {
    await _box.put('total_decisions_made', count);
  }

  int getTotalDecisionsMade() {
    return (_box.get('total_decisions_made') ?? 0) as int;
  }

  Future<void> saveBudgetChallengesCompleted(int count) async {
    await _box.put('budget_challenges_completed', count);
  }

  int getBudgetChallengesCompleted() {
    return (_box.get('budget_challenges_completed') ?? 0) as int;
  }

  // Achievements

  Future<void> saveEarnedAchievements(Set<String> ids) async {
    await _box.put('earned_achievements', jsonEncode(ids.toList()));
  }

  Set<String> getEarnedAchievements() {
    final data = _box.get('earned_achievements');
    if (data == null) return {};
    return (jsonDecode(data) as List).cast<String>().toSet();
  }

  // Notifications

  Future<void> saveNotifications(
    List<Map<String, dynamic>> notifications,
  ) async {
    await _box.put('notifications', jsonEncode(notifications));
  }

  List<Map<String, dynamic>> getNotifications() {
    final data = _box.get('notifications');
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> saveLastNotificationTime(DateTime time) async {
    await _box.put('last_notification_time', time.toIso8601String());
  }

  DateTime? getLastNotificationTime() {
    final data = _box.get('last_notification_time') as String?;
    if (data == null) return null;
    return DateTime.tryParse(data);
  }

  // Clear All

  Future<void> clearAll() async {
    await _box.clear();
  }
}

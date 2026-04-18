import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../models/transaction_model.dart';
import '../services/api_service.dart';
import '../services/sync_service.dart';
import '../storage/hive_storage.dart';

class WalletProvider extends ChangeNotifier {
  final _storage = HiveStorage();
  final _api = ApiService();
  final _sync = SyncService();

  double _balance = AppConstants.defaultWalletBalance;
  double _emergencyFund = 0.0;
  double _totalEarned = 0.0;
  double _totalSpent = 0.0;
  List<TransactionModel> _transactions = [];

  double get balance => _balance;
  double get emergencyFund => _emergencyFund;
  double get totalEarned => _totalEarned;
  double get totalSpent => _totalSpent;
  List<TransactionModel> get transactions => _transactions;

  double get emergencyFundProgress =>
      (_emergencyFund / AppConstants.emergencyFundTarget).clamp(0.0, 1.0);

  /// Initialize from local storage.
  void loadFromStorage() {
    _balance = _storage.getWalletBalance();
    _emergencyFund = _storage.getEmergencyFund();
    _transactions = _storage.getTransactions();
    notifyListeners();
  }

  /// Credit money to wallet.
  Future<void> credit({
    required double amount,
    required String category,
    required String description,
    String? sourceModule,
    String? scenarioId,
  }) async {
    _balance += amount;
    _totalEarned += amount;

    final txn = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: '',
      amount: amount,
      txType: 'credit',
      category: category,
      description: description,
      sourceModule: sourceModule,
      scenarioId: scenarioId,
      createdAt: DateTime.now(),
      synced: false,
    );

    _transactions.insert(0, txn);
    await _storage.saveWalletBalance(_balance);
    await _storage.addTransaction(txn);
    notifyListeners();

    // Queue for sync
    await _sync.queueAction('transaction', txn.toJson());

    // Try to sync immediately
    try {
      await _api.post(
        '/wallet/credit',
        body: {
          'amount': amount,
          'category': category,
          'description': description,
          'source_module': sourceModule,
          'scenario_id': scenarioId,
        },
      );
    } catch (_) {
      // Offline — already queued
    }
  }

  /// Debit money from wallet.
  Future<void> debit({
    required double amount,
    required String category,
    required String description,
    String? sourceModule,
    String? scenarioId,
  }) async {
    _balance = (_balance - amount).clamp(0.0, double.infinity);
    _totalSpent += amount;

    final txn = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: '',
      amount: amount,
      txType: 'debit',
      category: category,
      description: description,
      sourceModule: sourceModule,
      scenarioId: scenarioId,
      createdAt: DateTime.now(),
      synced: false,
    );

    _transactions.insert(0, txn);
    await _storage.saveWalletBalance(_balance);
    await _storage.addTransaction(txn);
    notifyListeners();

    await _sync.queueAction('transaction', txn.toJson());

    try {
      await _api.post(
        '/wallet/debit',
        body: {
          'amount': amount,
          'category': category,
          'description': description,
          'source_module': sourceModule,
          'scenario_id': scenarioId,
        },
      );
    } catch (_) {}
  }

  /// Contribute to emergency fund (deducts from wallet).
  Future<void> contributeToEmergencyFund(double amount) async {
    if (amount > _balance) amount = _balance;

    _balance -= amount;
    _emergencyFund += amount;

    await _storage.saveWalletBalance(_balance);
    await _storage.saveEmergencyFund(_emergencyFund);

    await debit(
      amount: amount,
      category: 'emergency',
      description: 'Emergency fund contribution: ₹${amount.toStringAsFixed(0)}',
      sourceModule: 'emergency_fund',
    );
  }

  /// Use emergency fund for an event.
  Future<double> useEmergencyFund(double needed) async {
    final available = _emergencyFund.clamp(0.0, needed);
    _emergencyFund -= available;
    await _storage.saveEmergencyFund(_emergencyFund);
    notifyListeners();
    return available; // Returns how much was covered
  }

  /// Receive monthly salary based on role.
  Future<void> receiveSalary(String role) async {
    final salary = AppConstants.roleSalary[role] ?? 5000.0;
    await credit(
      amount: salary,
      category: 'salary',
      description: 'Monthly salary received: ₹${salary.toStringAsFixed(0)}',
      sourceModule: 'system',
    );
  }

  /// Reset wallet to defaults.
  Future<void> reset() async {
    _balance = AppConstants.defaultWalletBalance;
    _emergencyFund = 0.0;
    _totalEarned = 0.0;
    _totalSpent = 0.0;
    _transactions = [];
    await _storage.saveWalletBalance(_balance);
    await _storage.saveEmergencyFund(0.0);
    await _storage.clearTransactions();
    notifyListeners();
  }
}

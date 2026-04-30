import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../services/api_service.dart';
import '../storage/hive_storage.dart';

/// Callback type for notifying providers after a successful pull.
typedef SyncPullCallback = void Function(Map<String, dynamic> userData);

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final _api = ApiService();
  final _storage = HiveStorage();
  bool _isSyncing = false;

  /// Callbacks registered by providers to receive pull data.
  final List<SyncPullCallback> _pullCallbacks = [];

  void registerPullCallback(SyncPullCallback callback) {
    _pullCallbacks.add(callback);
  }

  void unregisterPullCallback(SyncPullCallback callback) {
    _pullCallbacks.remove(callback);
  }

  /// Start listening for connectivity changes and sync when online.
  void startListening() {
    Connectivity().onConnectivityChanged.listen((results) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (hasConnection && !_isSyncing) {
        syncPendingChanges();
      }
    });
  }

  /// Check if we're currently online.
  Future<bool> isOnline() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  /// Process the sync queue with retry logic, then pull latest state.
  Future<bool> syncPendingChanges() async {
    if (_isSyncing) return false;
    if (!_api.hasToken) return false;

    final queue = _storage.getSyncQueue();
    if (queue.isEmpty) {
      // No pending changes, but still pull for latest state
      await pullFromServer();
      return true;
    }

    _isSyncing = true;

    // Retry up to 3 times with exponential backoff
    for (int attempt = 0; attempt < 3; attempt++) {
      try {
        final online = await isOnline();
        if (!online) {
          _isSyncing = false;
          return false;
        }

        await _api.post(
          '/sync/push',
          body: {
            'items': queue,
            'last_sync_at': DateTime.now().toIso8601String(),
          },
        );

        // Clear the queue on success
        await _storage.clearSyncQueue();

        // Pull latest state from server after successful push
        await pullFromServer();

        _isSyncing = false;
        return true;
      } catch (e) {
        if (attempt < 2) {
          // Wait before retry: 1s, 3s
          await Future.delayed(Duration(seconds: (attempt + 1) * 2 - 1));
        }
      }
    }

    _isSyncing = false;
    return false;
  }

  /// Pull the latest state from the server and notify registered providers.
  Future<bool> pullFromServer() async {
    if (!_api.hasToken) return false;

    try {
      final online = await isOnline();
      if (!online) return false;

      final data = await _api.get('/sync/pull');
      if (data == null) return false;

      // Update local storage from server data
      if (data['user'] != null) {
        final userJson = data['user'] as Map<String, dynamic>;
        await _storage.saveWalletBalance(
          (userJson['wallet_balance'] ?? 5000.0).toDouble(),
        );
        await _storage.saveEmergencyFund(
          (userJson['emergency_fund'] ?? 0.0).toDouble(),
        );
        await _storage.saveStressLevel(
          (userJson['stress_level'] ?? 0.20).toDouble(),
        );
        await _storage.saveSafetyScore(userJson['safety_score'] ?? 50);
        await _storage.saveTotalEarned(
          (userJson['total_earned'] ?? 0.0).toDouble(),
        );
        await _storage.saveTotalSpent(
          (userJson['total_spent'] ?? 0.0).toDouble(),
        );
      }

      // Notify all registered providers with the full data payload
      for (final callback in _pullCallbacks) {
        callback(data);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Queue an action for later sync if offline.
  Future<void> queueAction(String action, Map<String, dynamic> payload) async {
    await _storage.addToSyncQueue({
      'action': action,
      'payload': payload,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}

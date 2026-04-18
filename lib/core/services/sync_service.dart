/// Background sync service — pushes offline changes when connectivity is restored.

import 'package:connectivity_plus/connectivity_plus.dart';

import '../services/api_service.dart';
import '../storage/hive_storage.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final _api = ApiService();
  final _storage = HiveStorage();
  bool _isSyncing = false;

  /// Start listening for connectivity changes and sync when online.
  void startListening() {
    Connectivity().onConnectivityChanged.listen((results) {
      // results is a List<ConnectivityResult>
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

  /// Process the sync queue — push all pending changes to the server.
  Future<bool> syncPendingChanges() async {
    if (_isSyncing) return false;
    if (!_api.hasToken) return false;

    final queue = _storage.getSyncQueue();
    if (queue.isEmpty) return true;

    _isSyncing = true;

    try {
      final online = await isOnline();
      if (!online) {
        _isSyncing = false;
        return false;
      }

      await _api.post('/sync/push', body: {
        'items': queue,
        'last_sync_at': DateTime.now().toIso8601String(),
      });

      // Clear the queue on success
      await _storage.clearSyncQueue();
      _isSyncing = false;
      return true;
    } catch (e) {
      _isSyncing = false;
      return false;
    }
  }

  /// Pull the latest state from the server and update local storage.
  Future<bool> pullFromServer() async {
    if (!_api.hasToken) return false;

    try {
      final online = await isOnline();
      if (!online) return false;

      final data = await _api.get('/sync/pull');
      if (data == null) return false;

      // Update local user data
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
        await _storage.saveSafetyScore(
          userJson['safety_score'] ?? 50,
        );
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

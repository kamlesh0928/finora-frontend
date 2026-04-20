import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../services/sync_service.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isOnline = true;
  bool _isSyncing = false;
  StreamSubscription? _subscription;

  bool get isOnline => _isOnline;
  bool get isSyncing => _isSyncing;

  final _syncService = SyncService();

  ConnectivityProvider() {
    _init();
  }

  Future<void> _init() async {
    final results = await Connectivity().checkConnectivity();
    _isOnline = results.any((r) => r != ConnectivityResult.none);
    notifyListeners();

    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final wasOffline = !_isOnline;
      _isOnline = results.any((r) => r != ConnectivityResult.none);
      notifyListeners();

      // If we just came back online, trigger a sync
      if (wasOffline && _isOnline) {
        _triggerSync();
      }
    });
  }

  Future<void> _triggerSync() async {
    if (_isSyncing) return;
    _isSyncing = true;
    notifyListeners();

    try {
      await _syncService.syncPendingChanges();
    } catch (_) {}

    _isSyncing = false;
    notifyListeners();
  }

  /// Manually trigger a sync.
  Future<void> manualSync() async {
    if (!_isOnline) return;
    await _triggerSync();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

/// Game state provider — manages scenarios, savings, stress across all modules.

import 'package:flutter/material.dart';

import '../data/scenario_data.dart';
import '../services/api_service.dart';
import '../services/sync_service.dart';
import '../storage/hive_storage.dart';

class GameProvider extends ChangeNotifier {
  final _storage = HiveStorage();
  final _api = ApiService();
  final _sync = SyncService();

  double _savings = 5000.0;
  double _stressLevel = 0.20;
  int _currentScenarioIndex = 0;
  String _currentRole = 'Farmer';
  int _safetyScore = 50;
  int _financialHealthScore = 50;
  List<Scenario> _scenarios = [];
  List<String> _completedScenarioIds = [];
  int _totalDecisionsMade = 0;
  int _goodDecisions = 0;

  double get savings => _savings;
  double get stressLevel => _stressLevel;
  int get currentScenarioIndex => _currentScenarioIndex;
  String get currentRole => _currentRole;
  int get totalScenarios => _scenarios.length;
  bool get hasMoreScenarios => _currentScenarioIndex < _scenarios.length;
  int get safetyScore => _safetyScore;
  int get financialHealthScore => _financialHealthScore;
  int get totalDecisionsMade => _totalDecisionsMade;
  int get goodDecisions => _goodDecisions;

  /// Returns the current scenario, or null if all scenarios are completed.
  Scenario? get currentScenario {
    if (_currentScenarioIndex < _scenarios.length) {
      return _scenarios[_currentScenarioIndex];
    }
    return null;
  }

  /// Load from local storage.
  void loadFromStorage() {
    _savings = _storage.getWalletBalance();
    _stressLevel = _storage.getStressLevel();
    _safetyScore = _storage.getSafetyScore();
    final role = _storage.getRole();
    if (role != null) {
      _currentRole = role;
      _scenarios = scenariosByRole[role] ?? [];
      _completedScenarioIds = _storage.getCompletedScenarios('scenario');
      _currentScenarioIndex = _completedScenarioIds.length;
    }
    _recalculateHealthScore();
    notifyListeners();
  }

  /// Load the scenario set for the selected role.
  void loadScenariosForRole(String role) {
    _currentRole = role;
    _scenarios = scenariosByRole[role] ?? [];
    _completedScenarioIds = _storage.getCompletedScenarios('scenario');
    _currentScenarioIndex = _completedScenarioIds.length.clamp(0, _scenarios.length);
    _savings = _storage.getWalletBalance();
    _stressLevel = _storage.getStressLevel();
    _recalculateHealthScore();
    notifyListeners();
  }

  /// Process a player decision and update savings and stress.
  Future<void> makeDecision(Decision decision) async {
    _savings += decision.savingsImpact;
    if (_savings < 0) _savings = 0.0;

    _stressLevel += decision.stressImpact;
    _stressLevel = _stressLevel.clamp(0.0, 1.0);

    _totalDecisionsMade++;
    if (decision.savingsImpact >= 0 && decision.stressImpact <= 0) {
      _goodDecisions++;
    }

    final scenarioId = 'scenario_${_currentRole}_$_currentScenarioIndex';
    _completedScenarioIds.add(scenarioId);
    _currentScenarioIndex++;

    // Save locally
    await _storage.saveWalletBalance(_savings);
    await _storage.saveStressLevel(_stressLevel);
    await _storage.saveCompletedScenarios('scenario', _completedScenarioIds);

    _recalculateHealthScore();
    notifyListeners();

    // Sync to backend
    final payload = {
      'module': 'scenario',
      'scenario_id': scenarioId,
      'decision_index': _currentScenarioIndex - 1,
      'decision_title': decision.title,
      'savings_impact': decision.savingsImpact,
      'stress_impact': decision.stressImpact,
      'wallet_impact': decision.savingsImpact,
    };

    try {
      await _api.post('/game/decision', body: payload);
    } catch (_) {
      await _sync.queueAction('game_progress', payload);
    }
  }

  /// Update safety score (from fraud module).
  Future<void> updateSafetyScore(int delta) async {
    _safetyScore = (_safetyScore + delta).clamp(0, 100);
    await _storage.saveSafetyScore(_safetyScore);
    _recalculateHealthScore();
    notifyListeners();
  }

  /// Update stress level externally.
  Future<void> updateStressLevel(double delta) async {
    _stressLevel = (_stressLevel + delta).clamp(0.0, 1.0);
    await _storage.saveStressLevel(_stressLevel);
    _recalculateHealthScore();
    notifyListeners();
  }

  void _recalculateHealthScore() {
    int health = 50;
    if (_savings >= 10000) {
      health += 15;
    } else if (_savings >= 5000) {
      health += 10;
    } else if (_savings < 1000) {
      health -= 10;
    }

    final emergencyFund = _storage.getEmergencyFund();
    if (emergencyFund >= 50000) {
      health += 15;
    } else if (emergencyFund >= 10000) {
      health += 10;
    }

    if (_stressLevel < 0.3) {
      health += 10;
    } else if (_stressLevel > 0.7) {
      health -= 10;
    }

    if (_safetyScore >= 80) {
      health += 10;
    } else if (_safetyScore < 30) {
      health -= 5;
    }

    _financialHealthScore = health.clamp(0, 100);
  }

  /// Reset game state to defaults for the current role.
  Future<void> resetGame() async {
    _currentScenarioIndex = 0;
    _savings = 5000.0;
    _stressLevel = 0.20;
    _safetyScore = 50;
    _completedScenarioIds = [];
    _totalDecisionsMade = 0;
    _goodDecisions = 0;

    await _storage.saveWalletBalance(_savings);
    await _storage.saveStressLevel(_stressLevel);
    await _storage.saveSafetyScore(_safetyScore);
    await _storage.saveCompletedScenarios('scenario', []);

    _recalculateHealthScore();
    notifyListeners();

    try {
      await _api.post('/game/reset/all');
    } catch (_) {
      await _sync.queueAction('update_state', {
        'wallet_balance': _savings,
        'stress_level': _stressLevel,
        'safety_score': _safetyScore,
        'scenarios_completed': 0,
      });
    }
  }
}

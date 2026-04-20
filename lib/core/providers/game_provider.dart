import 'package:flutter/material.dart';

import '../data/scenario_data.dart';
import '../services/api_service.dart';
import '../services/sync_service.dart';
import '../storage/hive_storage.dart';
import 'wallet_provider.dart';

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
  int _budgetChallengesCompleted = 0;
  Set<String> _earnedAchievementIds = {};

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
  int get budgetChallengesCompleted => _budgetChallengesCompleted;
  Set<String> get earnedAchievementIds => _earnedAchievementIds;

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
    _totalDecisionsMade = _storage.getTotalDecisionsMade();
    _budgetChallengesCompleted = _storage.getBudgetChallengesCompleted();
    _earnedAchievementIds = _storage.getEarnedAchievements();
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

  /// Sync game state from server pull response.
  void syncFromServer(Map<String, dynamic> userData) {
    _stressLevel = (userData['stress_level'] ?? _stressLevel).toDouble();
    _safetyScore = userData['safety_score'] ?? _safetyScore;
    _financialHealthScore = userData['financial_health_score'] ?? _financialHealthScore;
    final serverScenariosCompleted = userData['scenarios_completed'] ?? 0;

    _storage.saveStressLevel(_stressLevel);
    _storage.saveSafetyScore(_safetyScore);

    // Update savings from server wallet_balance
    if (userData['wallet_balance'] != null) {
      _savings = (userData['wallet_balance']).toDouble();
      _storage.saveWalletBalance(_savings);
    }

    // Only advance scenario index if server is ahead
    if (serverScenariosCompleted > _currentScenarioIndex) {
      _currentScenarioIndex = serverScenariosCompleted.clamp(0, _scenarios.length);
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

  /// Process a player decision and update savings and stress, syncing with WalletProvider.
  Future<void> makeDecision(Decision decision, WalletProvider wallet) async {
    // 1. Update wallet provider (single source of truth for balance)
    if (decision.savingsImpact > 0) {
      await wallet.credit(
        amount: decision.savingsImpact.abs(),
        category: 'scenario',
        description: 'Scenario Action: ${decision.title}',
        sourceModule: 'scenario',
      );
    } else if (decision.savingsImpact < 0) {
      await wallet.debit(
        amount: decision.savingsImpact.abs(),
        category: 'scenario',
        description: 'Scenario Action: ${decision.title}',
        sourceModule: 'scenario',
      );
    }
    _savings = wallet.balance;

    // 2. Update local game state
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
    await _storage.saveStressLevel(_stressLevel);
    await _storage.saveCompletedScenarios('scenario', _completedScenarioIds);
    await _storage.saveTotalDecisionsMade(_totalDecisionsMade);

    _recalculateHealthScore();
    _checkAndAwardAchievements();
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
    _checkAndAwardAchievements();
    notifyListeners();
  }

  /// Update stress level externally.
  Future<void> updateStressLevel(double delta) async {
    _stressLevel = (_stressLevel + delta).clamp(0.0, 1.0);
    await _storage.saveStressLevel(_stressLevel);
    _recalculateHealthScore();
    notifyListeners();
  }

  /// Track budget challenge completions.
  Future<void> completeBudgetChallenge() async {
    _budgetChallengesCompleted++;
    await _storage.saveBudgetChallengesCompleted(_budgetChallengesCompleted);
    _checkAndAwardAchievements();
    notifyListeners();
  }

  /// Check conditions and auto-award achievements.
  void _checkAndAwardAchievements() {
    final walletBalance = _savings;
    final emergencyFund = _storage.getEmergencyFund();

    _tryAward('a1', _totalDecisionsMade >= 1);
    _tryAward('a2', walletBalance >= 10000);
    _tryAward('a3', _safetyScore >= 80);
    _tryAward('a4', _budgetChallengesCompleted >= 1);
    _tryAward('a5', emergencyFund >= 50000);
    _tryAward('a7', _currentScenarioIndex >= _scenarios.length && _scenarios.isNotEmpty);
  }

  void _tryAward(String achievementId, bool condition) {
    if (condition && !_earnedAchievementIds.contains(achievementId)) {
      _earnedAchievementIds.add(achievementId);
      _storage.saveEarnedAchievements(_earnedAchievementIds);

      // Queue for backend sync
      _sync.queueAction('achievement', {
        'badge_id': achievementId,
        'badge_name': _achievementName(achievementId),
        'badge_description': _achievementDesc(achievementId),
      });
    }
  }

  String _achievementName(String id) {
    const names = {
      'a1': 'First Steps', 'a2': 'Smart Saver', 'a3': 'Fraud Fighter',
      'a4': 'Budget Master', 'a5': 'Emergency Ready', 'a6': 'Knowledge Seeker',
      'a7': 'Financial Champion',
    };
    return names[id] ?? id;
  }

  String _achievementDesc(String id) {
    const descs = {
      'a1': 'Complete your first scenario', 'a2': 'Save 10,000 in wallet',
      'a3': 'Achieve 80+ safety score', 'a4': 'Complete budget allocation challenge',
      'a5': 'Build 50,000 emergency fund', 'a6': 'Read all micro-learning facts',
      'a7': 'Complete all modules and scenarios',
    };
    return descs[id] ?? '';
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
    _budgetChallengesCompleted = 0;
    _earnedAchievementIds = {};

    await _storage.saveWalletBalance(_savings);
    await _storage.saveStressLevel(_stressLevel);
    await _storage.saveSafetyScore(_safetyScore);
    await _storage.saveCompletedScenarios('scenario', []);
    await _storage.saveTotalDecisionsMade(0);
    await _storage.saveBudgetChallengesCompleted(0);
    await _storage.saveEarnedAchievements({});

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

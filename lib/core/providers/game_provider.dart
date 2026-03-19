import 'package:flutter/material.dart';

import '../data/scenario_data.dart';

class GameProvider extends ChangeNotifier {
  double _savings = 5000.0;
  double _stressLevel = 0.20;
  int _currentScenarioIndex = 0;
  String _currentRole = 'Farmer';
  List<Scenario> _scenarios = [];

  double get savings => _savings;
  double get stressLevel => _stressLevel;
  int get currentScenarioIndex => _currentScenarioIndex;
  String get currentRole => _currentRole;
  int get totalScenarios => _scenarios.length;
  bool get hasMoreScenarios => _currentScenarioIndex < _scenarios.length;

  /// Returns the current scenario, or null if all scenarios are completed.
  Scenario? get currentScenario {
    if (_currentScenarioIndex < _scenarios.length) {
      return _scenarios[_currentScenarioIndex];
    }
    return null;
  }

  /// Load the scenario set for the selected role.
  void loadScenariosForRole(String role) {
    _currentRole = role;
    _scenarios = scenariosByRole[role] ?? [];
    _currentScenarioIndex = 0;
    _savings = 5000.0;
    _stressLevel = 0.20;
    // TODO: Backend Integration - Fetch user progress from /api/game/progress/:userId to restore saved state.
    notifyListeners();
  }

  /// Process a player decision and update savings and stress.
  void makeDecision(Decision decision) {
    _savings += decision.savingsImpact;

    // Savings cannot drop below zero
    if (_savings < 0) {
      _savings = 0.0;
    }

    _stressLevel += decision.stressImpact;

    // Clamp stress between 0 and 1
    _stressLevel = _stressLevel.clamp(0.0, 1.0);

    _currentScenarioIndex++;

    // TODO: Backend Integration - Send POST to /api/game/decision with decision data and updated stats. Persist to Hive for offline.
    notifyListeners();
  }

  /// Reset game state to defaults for the current role.
  void resetGame() {
    _currentScenarioIndex = 0;
    _savings = 5000.0;
    _stressLevel = 0.20;
    // TODO: Backend Integration - Send POST to /api/game/reset/:userId to reset server-side progress.
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  double _savings = 5000.0;
  double _stressLevel = 0.3; // 0.0 to 1.0 (30% stress)
  int _currentScenarioIndex = 1;

  double get savings => _savings;
  double get stressLevel => _stressLevel;
  int get currentScenarioIndex => _currentScenarioIndex;

  // Simulating a decision made in the game
  void makeDecision(double cost, double stressImpact) {
    _savings -= cost;

    // Real-world logic: Savings cannot be negative
    if (_savings < 0) {
      _savings = 0.0;
    }

    _stressLevel += stressImpact;

    // Clamp stress between 0 and 1
    if (_stressLevel < 0) _stressLevel = 0.0;
    if (_stressLevel > 1.0) _stressLevel = 1.0;

    _currentScenarioIndex++;
    notifyListeners();

    // TODO: In the future, save these new values to Hive for offline persistence
  }
}

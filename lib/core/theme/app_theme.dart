import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primaryGreen = Color(0xFF2E7D52);
  static const Color primaryDark = Color(0xFF1B5E3B);
  static const Color primaryLight = Color(0xFF4CAF50);

  // Secondary
  static const Color secondaryBlue = Color(0xFF1565C0);
  static const Color secondaryLight = Color(0xFF42A5F5);

  // Accent
  static const Color accentGold = Color(0xFFF9A825);
  static const Color accentOrange = Color(0xFFF57C00);

  // Module colors
  static const Color budgetingColor = Color(0xFF1565C0);
  static const Color fraudColor = Color(0xFFD32F2F);
  static const Color emergencyColor = Color(0xFFF57C00);

  // Semantic
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1976D2);

  // Role colors
  static const Map<String, Color> roleColors = {
    'Farmer': Color(0xFF4CAF50),
    'Woman': Color(0xFFE91E63),
    'Student': Color(0xFF2196F3),
    'Young Adult': Color(0xFFFF9800),
  };

  // Neutral
  static const Color surface = Color(0xFFFAFAFA);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color textPrimary = Color(0xFF1B3A2D);
  static const Color textSecondary = Color(0xFF6B7C74);
}

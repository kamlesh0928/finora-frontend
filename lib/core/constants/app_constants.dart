class AppConstants {
  AppConstants._();

  // API
  // static const String apiBaseUrl = 'http://192.168.56.1/api'; // Android emulator
  // static const String apiBaseUrl = 'http://192.171.14.200:8000/api'; // Physical Wi-Fi Device
  // static const String apiBaseUrl = 'http://127.0.0.1:8000/api'; // Physical phone via ADB Reverse
  // static const String apiBaseUrl = 'http://localhost:8000/api'; // iOS / Web
  static const String apiBaseUrl = 'https://finora-backend-lvio.onrender.com/api'; // Production

  // Hive Box Names
  static const String offlineBox = 'finora_offline_data';
  static const String userBox = 'finora_user';
  static const String walletBox = 'finora_wallet';
  static const String transactionsBox = 'finora_transactions';
  static const String progressBox = 'finora_progress';
  static const String syncQueueBox = 'finora_sync_queue';
  static const String settingsBox = 'finora_settings';
  static const String tokenBox = 'finora_token';

  // Game Defaults
  static const double defaultWalletBalance = 5000.0;
  static const double defaultStressLevel = 0.20;
  static const int defaultHealthScore = 50;
  static const int defaultSafetyScore = 50;
  static const double emergencyFundTarget = 100000.0;

  // Role-Based Monthly Salary
  static const Map<String, double> roleSalary = {
    'Farmer': 15000.0,
    'Woman': 12000.0,
    'Student': 5000.0,
    'Young Adult': 50000.0,
  };

  // Role-Based Budget Amount
  static const Map<String, double> roleBudgetAmount = {
    'Farmer': 15000.0,
    'Woman': 12000.0,
    'Student': 5000.0,
    'Young Adult': 50000.0,
  };

  // Achievement Badge IDs
  static const String badgeFirstSteps = 'first_steps';
  static const String badgeSmartSaver = 'smart_saver';
  static const String badgeFraudFighter = 'fraud_fighter';
  static const String badgeBudgetMaster = 'budget_master';
  static const String badgeEmergencyReady = 'emergency_ready';
  static const String badgeKnowledgeSeeker = 'knowledge_seeker';
  static const String badge7DayStreak = 'seven_day_streak';
  static const String badgeChampion = 'financial_champion';
  static const String badgePerfectMonth = 'perfect_month';
  static const String badgeRoleMaster = 'role_master';

  // Languages
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'hi': 'हिन्दी',
  };
}

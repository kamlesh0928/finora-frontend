/// User data model for local storage and API communication.
class UserModel {
  final String id;
  final String email;
  final String name;
  final String? role;
  final String language;
  final double walletBalance;
  final double emergencyFund;
  final int financialHealthScore;
  final double stressLevel;
  final int safetyScore;
  final double totalEarned;
  final double totalSpent;
  final int scenariosCompleted;
  final int currentStreak;
  final int longestStreak;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.role,
    this.language = 'en',
    this.walletBalance = 5000.0,
    this.emergencyFund = 0.0,
    this.financialHealthScore = 50,
    this.stressLevel = 0.20,
    this.safetyScore = 50,
    this.totalEarned = 0.0,
    this.totalSpent = 0.0,
    this.scenariosCompleted = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'],
      language: json['language'] ?? 'en',
      walletBalance: (json['wallet_balance'] ?? 5000.0).toDouble(),
      emergencyFund: (json['emergency_fund'] ?? 0.0).toDouble(),
      financialHealthScore: json['financial_health_score'] ?? 50,
      stressLevel: (json['stress_level'] ?? 0.20).toDouble(),
      safetyScore: json['safety_score'] ?? 50,
      totalEarned: (json['total_earned'] ?? 0.0).toDouble(),
      totalSpent: (json['total_spent'] ?? 0.0).toDouble(),
      scenariosCompleted: json['scenarios_completed'] ?? 0,
      currentStreak: json['current_streak'] ?? 0,
      longestStreak: json['longest_streak'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'language': language,
      'wallet_balance': walletBalance,
      'emergency_fund': emergencyFund,
      'financial_health_score': financialHealthScore,
      'stress_level': stressLevel,
      'safety_score': safetyScore,
      'total_earned': totalEarned,
      'total_spent': totalSpent,
      'scenarios_completed': scenariosCompleted,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? language,
    double? walletBalance,
    double? emergencyFund,
    int? financialHealthScore,
    double? stressLevel,
    int? safetyScore,
    double? totalEarned,
    double? totalSpent,
    int? scenariosCompleted,
    int? currentStreak,
    int? longestStreak,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      language: language ?? this.language,
      walletBalance: walletBalance ?? this.walletBalance,
      emergencyFund: emergencyFund ?? this.emergencyFund,
      financialHealthScore: financialHealthScore ?? this.financialHealthScore,
      stressLevel: stressLevel ?? this.stressLevel,
      safetyScore: safetyScore ?? this.safetyScore,
      totalEarned: totalEarned ?? this.totalEarned,
      totalSpent: totalSpent ?? this.totalSpent,
      scenariosCompleted: scenariosCompleted ?? this.scenariosCompleted,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

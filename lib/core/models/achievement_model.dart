class AchievementModel {
  final String id;
  final String badgeId;
  final String badgeName;
  final String? badgeDescription;
  final String? badgeIcon;
  final DateTime? earnedAt;
  final bool isEarned;

  const AchievementModel({
    this.id = '',
    required this.badgeId,
    required this.badgeName,
    this.badgeDescription,
    this.badgeIcon,
    this.earnedAt,
    this.isEarned = false,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] ?? '',
      badgeId: json['badge_id'] ?? '',
      badgeName: json['badge_name'] ?? '',
      badgeDescription: json['badge_description'],
      badgeIcon: json['badge_icon'],
      earnedAt: json['earned_at'] != null
          ? DateTime.tryParse(json['earned_at'])
          : null,
      isEarned: json['earned_at'] != null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'badge_id': badgeId,
      'badge_name': badgeName,
      'badge_description': badgeDescription,
      'badge_icon': badgeIcon,
      'earned_at': earnedAt?.toIso8601String(),
    };
  }
}

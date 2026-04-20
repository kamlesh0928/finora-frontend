class AchievementData {
  final String id;
  final String emoji;
  final String title;
  final String description;

  const AchievementData({
    required this.id,
    required this.emoji,
    required this.title,
    required this.description,
  });
}

const List<AchievementData> allAchievements = [
  AchievementData(
    id: 'a1',
    emoji: '🌱',
    title: 'First Steps',
    description: 'Complete your first scenario',
  ),
  AchievementData(
    id: 'a2',
    emoji: '💰',
    title: 'Smart Saver',
    description: 'Save ₹10,000 in wallet',
  ),
  AchievementData(
    id: 'a3',
    emoji: '🛡️',
    title: 'Fraud Fighter',
    description: 'Achieve 80+ safety score',
  ),
  AchievementData(
    id: 'a4',
    emoji: '🎯',
    title: 'Budget Master',
    description: 'Complete budget allocation challenge',
  ),
  AchievementData(
    id: 'a5',
    emoji: '🏦',
    title: 'Emergency Ready',
    description: 'Build ₹50,000 emergency fund',
  ),
  AchievementData(
    id: 'a6',
    emoji: '📚',
    title: 'Knowledge Seeker',
    description: 'Read all micro-learning facts',
  ),
  AchievementData(
    id: 'a7',
    emoji: '🏆',
    title: 'Financial Champion',
    description: 'Complete all modules and scenarios',
  ),
];

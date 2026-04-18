/// Emergency fund event data — role-specific emergencies.

class EmergencyEvent {
  final String id;
  final String title;
  final String description;
  final double costAmount;
  final String icon;
  final List<EmergencyChoice> choices;
  final String microLearning;

  const EmergencyEvent({
    required this.id, required this.title, required this.description,
    required this.costAmount, required this.icon,
    required this.choices, required this.microLearning,
  });
}

class EmergencyChoice {
  final String title;
  final String subtitle;
  final double walletImpact;
  final double stressImpact;
  final double emergencyFundImpact;
  final bool isRecommended;

  const EmergencyChoice({
    required this.title, required this.subtitle,
    required this.walletImpact, required this.stressImpact,
    this.emergencyFundImpact = 0, this.isRecommended = false,
  });
}

const Map<String, List<EmergencyEvent>> emergencyEventsByRole = {
  'Farmer': [
    EmergencyEvent(
      id: 'fe1', title: 'Tractor Breakdown', icon: '🚜',
      description: 'Your tractor engine seized during ploughing season. Repair costs ₹15,000. Without it, you can\'t prepare fields.',
      costAmount: 15000, microLearning: 'An emergency fund equal to 3 months of expenses prevents debt during crises.',
      choices: [
        EmergencyChoice(title: 'Use emergency fund', subtitle: 'Pay ₹15,000 from fund. No debt.', walletImpact: 0, stressImpact: -0.05, emergencyFundImpact: -15000, isRecommended: true),
        EmergencyChoice(title: 'Take moneylender loan', subtitle: 'Borrow at 5% monthly interest. Pay ₹22,500 total.', walletImpact: -22500, stressImpact: 0.25, emergencyFundImpact: 0),
        EmergencyChoice(title: 'Wait and miss the season', subtitle: 'No repair cost but lose ₹30,000 in crop income.', walletImpact: -30000, stressImpact: 0.30, emergencyFundImpact: 0),
      ],
    ),
    EmergencyEvent(
      id: 'fe2', title: 'Crop Disease Outbreak', icon: '🦠',
      description: 'A fungal disease is spreading in your wheat crop. Immediate pesticide treatment costs ₹8,000.',
      costAmount: 8000, microLearning: '70% of Indian farmers don\'t have emergency savings, leading to debt traps.',
      choices: [
        EmergencyChoice(title: 'Use emergency fund', subtitle: 'Pay ₹8,000 from fund.', walletImpact: 0, stressImpact: -0.05, emergencyFundImpact: -8000, isRecommended: true),
        EmergencyChoice(title: 'Use cheaper local remedy', subtitle: 'Pay ₹2,000 but 50% chance it won\'t work.', walletImpact: -2000, stressImpact: 0.15, emergencyFundImpact: 0),
        EmergencyChoice(title: 'Do nothing', subtitle: 'Risk losing 60% of crop (₹25,000 loss).', walletImpact: -25000, stressImpact: 0.35, emergencyFundImpact: 0),
      ],
    ),
    EmergencyEvent(
      id: 'fe3', title: 'Family Medical Emergency', icon: '🏥',
      description: 'Your wife needs urgent treatment. Hospital demands ₹20,000 advance deposit.',
      costAmount: 20000, microLearning: 'Medical emergencies are the #1 reason families fall into debt in India.',
      choices: [
        EmergencyChoice(title: 'Emergency fund + govt hospital', subtitle: 'Use ₹10,000 from fund + go to govt hospital.', walletImpact: -5000, stressImpact: 0.05, emergencyFundImpact: -10000, isRecommended: true),
        EmergencyChoice(title: 'Sell livestock', subtitle: 'Sell 2 goats for ₹20,000 but lose future income.', walletImpact: -20000, stressImpact: 0.20, emergencyFundImpact: 0),
        EmergencyChoice(title: 'Borrow from relatives', subtitle: 'No interest but social obligation.', walletImpact: -20000, stressImpact: 0.15, emergencyFundImpact: 0),
      ],
    ),
  ],
  'Woman': [
    EmergencyEvent(
      id: 'we1', title: 'Sewing Machine Breaks', icon: '🧵',
      description: 'Your sewing machine broke. A new one costs ₹12,000. Without it, your tailoring income stops.',
      costAmount: 12000, microLearning: 'Even ₹500/month builds ₹30,000 in 5 years with interest.',
      choices: [
        EmergencyChoice(title: 'Use emergency fund', subtitle: 'Pay ₹12,000 from fund. Back to work in 2 days.', walletImpact: 0, stressImpact: -0.05, emergencyFundImpact: -12000, isRecommended: true),
        EmergencyChoice(title: 'SHG loan', subtitle: 'Borrow ₹12,000 at low interest from Self-Help Group.', walletImpact: -13500, stressImpact: 0.10, emergencyFundImpact: 0),
        EmergencyChoice(title: 'Do hand stitching', subtitle: 'Slow work, income drops 70% for weeks.', walletImpact: -8000, stressImpact: 0.20, emergencyFundImpact: 0),
      ],
    ),
    EmergencyEvent(
      id: 'we2', title: 'Child\'s School Emergency', icon: '📚',
      description: 'School demands ₹10,000 sudden fee for annual day + exam fee. Due in 3 days.',
      costAmount: 10000, microLearning: 'Start with a ₹1,000 emergency target. Small wins build the saving habit.',
      choices: [
        EmergencyChoice(title: 'Use emergency fund', subtitle: 'Pay from fund. No disruption.', walletImpact: 0, stressImpact: -0.05, emergencyFundImpact: -10000, isRecommended: true),
        EmergencyChoice(title: 'Negotiate installments', subtitle: 'Pay ₹5,000 now, ₹6,000 next month.', walletImpact: -5000, stressImpact: 0.10, emergencyFundImpact: 0),
        EmergencyChoice(title: 'Borrow from neighbor', subtitle: 'Moderate social pressure.', walletImpact: -10500, stressImpact: 0.15, emergencyFundImpact: 0),
      ],
    ),
    EmergencyEvent(
      id: 'we3', title: 'Gas Cylinder Accident', icon: '🔥',
      description: 'Gas cylinder leak caused small kitchen fire. Repairs and replacement cost ₹8,000.',
      costAmount: 8000, microLearning: 'People without emergency funds take loans 3x more often.',
      choices: [
        EmergencyChoice(title: 'Use emergency fund', subtitle: 'Cover repairs immediately.', walletImpact: 0, stressImpact: -0.05, emergencyFundImpact: -8000, isRecommended: true),
        EmergencyChoice(title: 'Use savings account', subtitle: 'Withdraw from bank savings.', walletImpact: -8000, stressImpact: 0.05, emergencyFundImpact: 0),
        EmergencyChoice(title: 'Cook on chulha temporarily', subtitle: 'Save money but health risks from smoke.', walletImpact: -2000, stressImpact: 0.20, emergencyFundImpact: 0),
      ],
    ),
  ],
  'Student': [
    EmergencyEvent(
      id: 'se1', title: 'Phone Screen Cracked', icon: '📱',
      description: 'Your phone screen cracked badly. Repair costs ₹3,000. You need it for online classes.',
      costAmount: 3000, microLearning: 'Saving just ₹100/week gives you a ₹5,200 emergency fund in a year!',
      choices: [
        EmergencyChoice(title: 'Use emergency savings', subtitle: 'Pay from your saved money.', walletImpact: 0, stressImpact: -0.05, emergencyFundImpact: -3000, isRecommended: true),
        EmergencyChoice(title: 'Ask parents for money', subtitle: 'They\'ll help but might be disappointed.', walletImpact: -3000, stressImpact: 0.10, emergencyFundImpact: 0),
        EmergencyChoice(title: 'Use phone with cracked screen', subtitle: 'Free but hard to read and risk of injury.', walletImpact: 0, stressImpact: 0.15, emergencyFundImpact: 0),
      ],
    ),
    EmergencyEvent(
      id: 'se2', title: 'Exam Fee Surprise', icon: '📝',
      description: 'Competitive exam registration deadline is tomorrow! Fee: ₹2,500. You didn\'t budget for it.',
      costAmount: 2500, microLearning: 'Writing down upcoming expenses helps avoid financial surprises.',
      choices: [
        EmergencyChoice(title: 'Use emergency fund', subtitle: 'Cover the fee without stress.', walletImpact: 0, stressImpact: -0.05, emergencyFundImpact: -2500, isRecommended: true),
        EmergencyChoice(title: 'Borrow from a friend', subtitle: 'Promise to repay next month.', walletImpact: -2500, stressImpact: 0.10, emergencyFundImpact: 0),
        EmergencyChoice(title: 'Skip the exam', subtitle: 'Lose the opportunity. Wait for next year.', walletImpact: 0, stressImpact: 0.25, emergencyFundImpact: 0),
      ],
    ),
    EmergencyEvent(
      id: 'se3', title: 'Laptop Hard Drive Failure', icon: '💻',
      description: 'Your laptop won\'t boot! Data recovery + repair costs ₹5,000. Assignments due this week.',
      costAmount: 5000, microLearning: 'An emergency fund prevents small problems from becoming big crises.',
      choices: [
        EmergencyChoice(title: 'Use emergency fund', subtitle: 'Get it fixed today.', walletImpact: 0, stressImpact: -0.05, emergencyFundImpact: -5000, isRecommended: true),
        EmergencyChoice(title: 'Use library computers', subtitle: 'Free but limited hours and inconvenient.', walletImpact: 0, stressImpact: 0.20, emergencyFundImpact: 0),
        EmergencyChoice(title: 'Buy cheap second-hand laptop', subtitle: 'Pay ₹8,000 for used laptop. Old data lost.', walletImpact: -8000, stressImpact: 0.15, emergencyFundImpact: 0),
      ],
    ),
  ],
  'Young Adult': [
    EmergencyEvent(
      id: 'yae1', title: 'Car Engine Problem', icon: '🚗',
      description: 'Your car won\'t start. Mechanic says engine overhaul needed: ₹25,000.',
      costAmount: 25000, microLearning: 'Ideal emergency fund = 6 months of your monthly expenses.',
      choices: [
        EmergencyChoice(title: 'Use emergency fund', subtitle: 'Cover the entire amount. No EMI.', walletImpact: 0, stressImpact: -0.05, emergencyFundImpact: -25000, isRecommended: true),
        EmergencyChoice(title: 'Credit card EMI', subtitle: '₹25,000 at 18% APR over 6 months = ₹27,250', walletImpact: -27250, stressImpact: 0.15, emergencyFundImpact: 0),
        EmergencyChoice(title: 'Use public transport', subtitle: 'No repair cost but 2 hours daily commute.', walletImpact: -3000, stressImpact: 0.20, emergencyFundImpact: 0),
      ],
    ),
    EmergencyEvent(
      id: 'yae2', title: 'Sudden Rent Increase', icon: '🏠',
      description: 'Landlord increased rent by ₹5,000/month effective immediately. Moving costs ₹15,000.',
      costAmount: 15000, microLearning: 'Housing costs should ideally be 30% or less of your income.',
      choices: [
        EmergencyChoice(title: 'Use fund for deposit + move', subtitle: 'Pay ₹15,000 from fund for a cheaper place.', walletImpact: 0, stressImpact: 0.05, emergencyFundImpact: -15000, isRecommended: true),
        EmergencyChoice(title: 'Absorb the increase', subtitle: 'Stay put, pay ₹5,000 more every month.', walletImpact: -5000, stressImpact: 0.15, emergencyFundImpact: 0),
        EmergencyChoice(title: 'Get a roommate', subtitle: 'Split costs but lose privacy.', walletImpact: 0, stressImpact: 0.10, emergencyFundImpact: 0),
      ],
    ),
    EmergencyEvent(
      id: 'yae3', title: 'Parent\'s Surgery', icon: '🏥',
      description: 'Your father needs knee surgery: ₹1,50,000. Insurance covers ₹1,00,000. You need ₹50,000.',
      costAmount: 50000, microLearning: 'Health insurance + emergency fund = complete financial protection.',
      choices: [
        EmergencyChoice(title: 'Emergency fund + family split', subtitle: '₹30,000 from fund + siblings contribute ₹20,000.', walletImpact: 0, stressImpact: 0.05, emergencyFundImpact: -30000, isRecommended: true),
        EmergencyChoice(title: 'Personal loan', subtitle: 'Borrow ₹50,000 at 12% for 1 year = ₹56,000.', walletImpact: -56000, stressImpact: 0.20, emergencyFundImpact: 0),
        EmergencyChoice(title: 'Sell investments', subtitle: 'Liquidate mutual funds. May lose ₹5,000 in exit charges.', walletImpact: -55000, stressImpact: 0.10, emergencyFundImpact: 0),
      ],
    ),
  ],
};

/// Micro-learning facts for emergency fund education.
const List<Map<String, String>> emergencyMicroLearning = [
  {'fact': 'People without emergency funds take loans 3x more often.', 'icon': '📊'},
  {'fact': 'Ideal emergency fund = 6 months of expenses.', 'icon': '🎯'},
  {'fact': '70% of Indians don\'t have any emergency savings.', 'icon': '😰'},
  {'fact': 'Even ₹500/month builds ₹30,000 in 5 years.', 'icon': '💰'},
  {'fact': 'Medical emergencies are the #1 reason for debt in India.', 'icon': '🏥'},
  {'fact': 'Start with ₹1,000 target. Small wins build habits.', 'icon': '🌱'},
  {'fact': 'An emergency fund is NOT for vacations or shopping.', 'icon': '🚫'},
  {'fact': 'Keep emergency fund in a separate savings account.', 'icon': '🏦'},
  {'fact': 'Job loss without savings leads to average 4 months of hardship.', 'icon': '📉'},
  {'fact': 'Auto-transfer ₹500/month — you won\'t miss it!', 'icon': '⚡'},
];

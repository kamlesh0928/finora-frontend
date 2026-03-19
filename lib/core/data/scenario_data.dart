// Data models and scenario definitions for the Finora game engine.
// Each role has a curated set of financial scenarios covering savings,
// budgeting, and risk management themes.

class Decision {
  final String title;
  final String subtitle;
  final IconChoice icon;
  final double savingsImpact;
  final double stressImpact;

  const Decision({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.savingsImpact,
    required this.stressImpact,
  });
}

/// Enum-like class to map to Material Icons without importing Flutter
/// in the data layer. The actual IconData is resolved in the UI.
enum IconChoice {
  savings,
  accountBalance,
  warning,
  trendingUp,
  trendingDown,
  shield,
  school,
  creditCard,
  phoneAndroid,
  agriculture,
  handshake,
  localHospital,
  store,
  lightbulb,
  buildCircle,
  moneyOff,
  receiptLong,
  groups,
  workspacePremium,
}

class Scenario {
  final String title;
  final String description;
  final String theme; // 'savings', 'budgeting', 'risk_management'
  final List<Decision> decisions;

  const Scenario({
    required this.title,
    required this.description,
    required this.theme,
    required this.decisions,
  });
}

/// All scenarios keyed by role name.
const Map<String, List<Scenario>> scenariosByRole = {
  'Farmer': _farmerScenarios,
  'Woman': _womanScenarios,
  'Student': _studentScenarios,
  'Young Adult': _youngAdultScenarios,
};

const List<Scenario> _farmerScenarios = [
  Scenario(
    title: 'Tractor Breakdown',
    description:
        'Your tractor has broken down right before the harvest season. '
        'A local mechanic can fix it for INR 2,000. Without the tractor, '
        'you risk losing a significant portion of your crop yield.',
    theme: 'risk_management',
    decisions: [
      Decision(
        title: 'Pay from emergency savings',
        subtitle: 'Costs INR 2,000 but keeps stress low.',
        icon: IconChoice.savings,
        savingsImpact: -2000,
        stressImpact: -0.05,
      ),
      Decision(
        title: 'Take a high-interest local loan',
        subtitle: 'No upfront cost, but adds long-term debt pressure.',
        icon: IconChoice.warning,
        savingsImpact: 0,
        stressImpact: 0.25,
      ),
      Decision(
        title: 'Borrow a neighbor\'s tractor',
        subtitle: 'Small favor cost of INR 500. Moderate stress.',
        icon: IconChoice.handshake,
        savingsImpact: -500,
        stressImpact: 0.05,
      ),
    ],
  ),
  Scenario(
    title: 'Crop Insurance Offer',
    description:
        'A government agent visits your village offering crop insurance '
        'for INR 1,500 per season. Last year, unexpected rains destroyed '
        '30% of crops in your area. What do you decide?',
    theme: 'risk_management',
    decisions: [
      Decision(
        title: 'Buy the crop insurance',
        subtitle: 'Costs INR 1,500 now but protects against crop loss.',
        icon: IconChoice.shield,
        savingsImpact: -1500,
        stressImpact: -0.15,
      ),
      Decision(
        title: 'Skip insurance this season',
        subtitle: 'Save money now but risk heavy losses if rains come.',
        icon: IconChoice.moneyOff,
        savingsImpact: 0,
        stressImpact: 0.10,
      ),
    ],
  ),
  Scenario(
    title: 'Harvest Surplus',
    description:
        'This season produced an excellent harvest. After selling your yield, '
        'you have an extra INR 3,000. How will you use this surplus?',
    theme: 'savings',
    decisions: [
      Decision(
        title: 'Deposit in a bank savings account',
        subtitle: 'Earns interest over time and builds a safety net.',
        icon: IconChoice.accountBalance,
        savingsImpact: 3000,
        stressImpact: -0.10,
      ),
      Decision(
        title: 'Buy fertilizer for next season',
        subtitle: 'Invest in future yield. Moderate risk, moderate reward.',
        icon: IconChoice.agriculture,
        savingsImpact: -1000,
        stressImpact: -0.05,
      ),
      Decision(
        title: 'Spend on household needs',
        subtitle: 'Immediate comfort but no financial buffer created.',
        icon: IconChoice.store,
        savingsImpact: -2500,
        stressImpact: 0.05,
      ),
    ],
  ),
];

const List<Scenario> _womanScenarios = [
  Scenario(
    title: 'Self-Help Group Opportunity',
    description:
        'A local Self-Help Group (SHG) invites you to join with a monthly '
        'contribution of INR 500. Members get access to low-interest loans '
        'and financial training. Your household budget is already tight.',
    theme: 'savings',
    decisions: [
      Decision(
        title: 'Join the SHG',
        subtitle:
            'INR 500/month cost, but builds savings and community support.',
        icon: IconChoice.groups,
        savingsImpact: -500,
        stressImpact: -0.15,
      ),
      Decision(
        title: 'Decline for now',
        subtitle: 'No cost, but miss out on financial support network.',
        icon: IconChoice.moneyOff,
        savingsImpact: 0,
        stressImpact: 0.10,
      ),
    ],
  ),
  Scenario(
    title: 'Child\'s School Fees',
    description:
        'School fees of INR 2,000 are due next week. You have savings, '
        'but using them means no emergency buffer. A neighbor offers '
        'to lend you the money at moderate interest.',
    theme: 'budgeting',
    decisions: [
      Decision(
        title: 'Pay from savings',
        subtitle: 'Costs INR 2,000 but avoids debt.',
        icon: IconChoice.school,
        savingsImpact: -2000,
        stressImpact: 0.05,
      ),
      Decision(
        title: 'Borrow from the neighbor',
        subtitle: 'Keeps savings intact but adds repayment pressure.',
        icon: IconChoice.handshake,
        savingsImpact: 0,
        stressImpact: 0.20,
      ),
      Decision(
        title: 'Negotiate a payment plan with the school',
        subtitle: 'Pay INR 1,000 now and INR 1,200 next month.',
        icon: IconChoice.receiptLong,
        savingsImpact: -1000,
        stressImpact: 0.08,
      ),
    ],
  ),
  Scenario(
    title: 'Digital Payment Training',
    description:
        'A local NGO is offering free training on using UPI and mobile '
        'banking. It requires one full day of your time. Learning digital '
        'skills could help you manage money better and avoid middlemen.',
    theme: 'risk_management',
    decisions: [
      Decision(
        title: 'Attend the training',
        subtitle: 'One day of lost work, but valuable long-term skill.',
        icon: IconChoice.phoneAndroid,
        savingsImpact: -200,
        stressImpact: -0.12,
      ),
      Decision(
        title: 'Skip and continue as usual',
        subtitle:
            'No time lost, but remain dependent on others for transactions.',
        icon: IconChoice.moneyOff,
        savingsImpact: 0,
        stressImpact: 0.05,
      ),
    ],
  ),
];

const List<Scenario> _studentScenarios = [
  Scenario(
    title: 'Monthly Budget Challenge',
    description:
        'You receive INR 3,000 as your monthly pocket money. Your friends '
        'are planning an outing that costs INR 1,500. You also need to buy '
        'study materials worth INR 800. How do you plan your budget?',
    theme: 'budgeting',
    decisions: [
      Decision(
        title: 'Go on the outing, skip the books',
        subtitle: 'Fun now, but academic performance may suffer.',
        icon: IconChoice.groups,
        savingsImpact: -1500,
        stressImpact: 0.10,
      ),
      Decision(
        title: 'Buy books, skip the outing',
        subtitle: 'Saves INR 1,500 and stays focused on studies.',
        icon: IconChoice.school,
        savingsImpact: -800,
        stressImpact: -0.05,
      ),
      Decision(
        title: 'Do both, stretch the budget thin',
        subtitle: 'Costs INR 2,300 total. Very little left for the month.',
        icon: IconChoice.warning,
        savingsImpact: -2300,
        stressImpact: 0.15,
      ),
    ],
  ),
  Scenario(
    title: 'Suspicious Online Offer',
    description:
        'You see an ad online promising to double your money in 7 days '
        'if you invest just INR 500. Several of your classmates say they '
        'are trying it. It sounds too good to be true.',
    theme: 'risk_management',
    decisions: [
      Decision(
        title: 'Invest the INR 500',
        subtitle: 'High risk. Could lose everything to a scam.',
        icon: IconChoice.warning,
        savingsImpact: -500,
        stressImpact: 0.30,
      ),
      Decision(
        title: 'Report it and warn friends',
        subtitle: 'No loss. Protects yourself and others.',
        icon: IconChoice.shield,
        savingsImpact: 0,
        stressImpact: -0.10,
      ),
    ],
  ),
  Scenario(
    title: 'Part-Time Tutoring Gig',
    description:
        'A junior student asks you to tutor them in Math for INR 1,000 '
        'per month. It will take 5 hours of your week. This could be a '
        'great way to earn, but your exams are approaching.',
    theme: 'savings',
    decisions: [
      Decision(
        title: 'Accept the tutoring job',
        subtitle: 'Earn INR 1,000 but risk exam preparation time.',
        icon: IconChoice.trendingUp,
        savingsImpact: 1000,
        stressImpact: 0.10,
      ),
      Decision(
        title: 'Decline and focus on exams',
        subtitle: 'No extra income, but better academic performance.',
        icon: IconChoice.school,
        savingsImpact: 0,
        stressImpact: -0.08,
      ),
    ],
  ),
];

const List<Scenario> _youngAdultScenarios = [
  Scenario(
    title: 'Credit Card Temptation',
    description:
        'You just received your first credit card with a limit of INR 50,000. '
        'An electronics sale is offering the latest smartphone for INR 25,000 '
        'with a no-cost EMI option. Your current phone works fine.',
    theme: 'budgeting',
    decisions: [
      Decision(
        title: 'Buy the smartphone on EMI',
        subtitle: 'INR 25,000 debt. Monthly EMIs add financial pressure.',
        icon: IconChoice.creditCard,
        savingsImpact: 0,
        stressImpact: 0.25,
      ),
      Decision(
        title: 'Save up and buy later with cash',
        subtitle: 'No debt. Build savings discipline.',
        icon: IconChoice.savings,
        savingsImpact: 0,
        stressImpact: -0.05,
      ),
      Decision(
        title: 'Buy a budget phone instead',
        subtitle: 'Spend INR 8,000 from savings. Practical choice.',
        icon: IconChoice.phoneAndroid,
        savingsImpact: -8000,
        stressImpact: -0.02,
      ),
    ],
  ),
  Scenario(
    title: 'Tax Filing Decision',
    description:
        'It is tax season and you earned INR 4,00,000 this year. You can '
        'save tax by investing INR 15,000 in an ELSS mutual fund under '
        'Section 80C. But that means less cash in hand right now.',
    theme: 'savings',
    decisions: [
      Decision(
        title: 'Invest in ELSS and save tax',
        subtitle: 'Costs INR 15,000 now but reduces tax and builds wealth.',
        icon: IconChoice.trendingUp,
        savingsImpact: -15000,
        stressImpact: -0.15,
      ),
      Decision(
        title: 'Skip tax-saving investments',
        subtitle: 'Keep cash but pay higher tax. No long-term wealth building.',
        icon: IconChoice.moneyOff,
        savingsImpact: 0,
        stressImpact: 0.10,
      ),
    ],
  ),
  Scenario(
    title: 'Fake Job Offer Scam',
    description:
        'You receive a message offering a work-from-home job paying '
        'INR 30,000/month. They ask for a INR 2,000 "registration fee" upfront. '
        'The company website looks professional but you cannot verify their office.',
    theme: 'risk_management',
    decisions: [
      Decision(
        title: 'Pay the registration fee',
        subtitle: 'High risk of losing INR 2,000 to a scam.',
        icon: IconChoice.warning,
        savingsImpact: -2000,
        stressImpact: 0.30,
      ),
      Decision(
        title: 'Research and verify first',
        subtitle: 'No cost. Smart due diligence protects your money.',
        icon: IconChoice.shield,
        savingsImpact: 0,
        stressImpact: -0.05,
      ),
      Decision(
        title: 'Report to cyber crime portal',
        subtitle: 'No cost. Helps protect others from the scam too.',
        icon: IconChoice.lightbulb,
        savingsImpact: 0,
        stressImpact: -0.10,
      ),
    ],
  ),
];

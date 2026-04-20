class BudgetCategory {
  final String name;
  final String icon;
  final double recommended;
  final double min;
  final double max;

  const BudgetCategory({
    required this.name,
    required this.icon,
    required this.recommended,
    required this.min,
    required this.max,
  });
}

class BudgetScenario {
  final String id;
  final String title;
  final String description;
  final String type; // salary_increase, medical_bill, festival, job_loss
  final List<BudgetDecision> decisions;

  const BudgetScenario({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.decisions,
  });
}

class BudgetDecision {
  final String title;
  final String subtitle;
  final String icon;
  final double walletImpact;
  final double stressImpact;
  final String feedbackGood;
  final String feedbackBad;
  final bool isRecommended;

  const BudgetDecision({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.walletImpact,
    required this.stressImpact,
    this.feedbackGood = '',
    this.feedbackBad = '',
    this.isRecommended = false,
  });
}

/// Budget categories per role.
const Map<String, List<BudgetCategory>> budgetCategoriesByRole = {
  'Farmer': [
    BudgetCategory(
      name: 'Seeds & Fertilizer',
      icon: '🌱',
      recommended: 3000,
      min: 1000,
      max: 6000,
    ),
    BudgetCategory(
      name: 'Food & Groceries',
      icon: '🍚',
      recommended: 4000,
      min: 2000,
      max: 6000,
    ),
    BudgetCategory(
      name: 'Health',
      icon: '🏥',
      recommended: 1000,
      min: 0,
      max: 3000,
    ),
    BudgetCategory(
      name: 'Education',
      icon: '📚',
      recommended: 1000,
      min: 0,
      max: 3000,
    ),
    BudgetCategory(
      name: 'Transport',
      icon: '🚜',
      recommended: 1500,
      min: 500,
      max: 3000,
    ),
    BudgetCategory(
      name: 'Savings',
      icon: '🏦',
      recommended: 3000,
      min: 0,
      max: 8000,
    ),
    BudgetCategory(
      name: 'Emergency Fund',
      icon: '🛡️',
      recommended: 1500,
      min: 0,
      max: 5000,
    ),
  ],
  'Woman': [
    BudgetCategory(
      name: 'Groceries & Kitchen',
      icon: '🛒',
      recommended: 5000,
      min: 3000,
      max: 7000,
    ),
    BudgetCategory(
      name: 'Children Education',
      icon: '📚',
      recommended: 2000,
      min: 500,
      max: 4000,
    ),
    BudgetCategory(
      name: 'Health',
      icon: '🏥',
      recommended: 1500,
      min: 0,
      max: 3000,
    ),
    BudgetCategory(
      name: 'Business Supplies',
      icon: '🧵',
      recommended: 1500,
      min: 0,
      max: 3000,
    ),
    BudgetCategory(
      name: 'Household Bills',
      icon: '💡',
      recommended: 1000,
      min: 500,
      max: 2000,
    ),
    BudgetCategory(
      name: 'Savings (SHG)',
      icon: '🏦',
      recommended: 500,
      min: 0,
      max: 2000,
    ),
    BudgetCategory(
      name: 'Emergency Fund',
      icon: '🛡️',
      recommended: 500,
      min: 0,
      max: 2000,
    ),
  ],
  'Student': [
    BudgetCategory(
      name: 'Study Materials',
      icon: '📖',
      recommended: 1000,
      min: 500,
      max: 2000,
    ),
    BudgetCategory(
      name: 'Food & Snacks',
      icon: '🍕',
      recommended: 1500,
      min: 800,
      max: 2500,
    ),
    BudgetCategory(
      name: 'Transport',
      icon: '🚌',
      recommended: 500,
      min: 200,
      max: 1000,
    ),
    BudgetCategory(
      name: 'Entertainment',
      icon: '🎮',
      recommended: 500,
      min: 0,
      max: 1500,
    ),
    BudgetCategory(
      name: 'Mobile Recharge',
      icon: '📱',
      recommended: 300,
      min: 100,
      max: 500,
    ),
    BudgetCategory(
      name: 'Savings',
      icon: '🏦',
      recommended: 700,
      min: 0,
      max: 2000,
    ),
    BudgetCategory(
      name: 'Emergency Fund',
      icon: '🛡️',
      recommended: 500,
      min: 0,
      max: 1500,
    ),
  ],
  'Young Adult': [
    BudgetCategory(
      name: 'Rent & Housing',
      icon: '🏠',
      recommended: 15000,
      min: 8000,
      max: 20000,
    ),
    BudgetCategory(
      name: 'Food & Dining',
      icon: '🍽️',
      recommended: 8000,
      min: 4000,
      max: 12000,
    ),
    BudgetCategory(
      name: 'Transport',
      icon: '🚗',
      recommended: 5000,
      min: 2000,
      max: 8000,
    ),
    BudgetCategory(
      name: 'Utilities & Bills',
      icon: '💡',
      recommended: 3000,
      min: 1000,
      max: 5000,
    ),
    BudgetCategory(
      name: 'Entertainment',
      icon: '🎬',
      recommended: 3000,
      min: 0,
      max: 6000,
    ),
    BudgetCategory(
      name: 'Savings & Investment',
      icon: '📈',
      recommended: 10000,
      min: 0,
      max: 20000,
    ),
    BudgetCategory(
      name: 'Emergency Fund',
      icon: '🛡️',
      recommended: 6000,
      min: 0,
      max: 15000,
    ),
  ],
};

/// Budget scenarios per role.
const Map<String, List<BudgetScenario>> budgetScenariosByRole = {
  'Farmer': _farmerBudgetScenarios,
  'Woman': _womanBudgetScenarios,
  'Student': _studentBudgetScenarios,
  'Young Adult': _youngAdultBudgetScenarios,
};

const List<BudgetScenario> _farmerBudgetScenarios = [
  BudgetScenario(
    id: 'f_salary',
    title: 'Bumper Harvest',
    description:
        'Your crop sold for ₹10,000 more than expected this season! How will you use the surplus?',
    type: 'salary_increase',
    decisions: [
      BudgetDecision(
        title: 'Save 50% + invest in next season',
        subtitle: '₹5,000 to savings, ₹5,000 for seeds and fertilizer',
        icon: 'savings',
        walletImpact: 7000,
        stressImpact: -0.10,
        feedbackGood: 'Smart move! You balanced savings with investment.',
        isRecommended: true,
      ),
      BudgetDecision(
        title: 'Buy new farm equipment',
        subtitle: 'Invest full ₹10,000 in a better plough',
        icon: 'build',
        walletImpact: 3000,
        stressImpact: -0.05,
        feedbackGood: 'Good investment, but no emergency buffer.',
      ),
      BudgetDecision(
        title: 'Celebrate with a big family feast',
        subtitle: 'Spend ₹8,000 on celebrations',
        icon: 'celebration',
        walletImpact: -2000,
        stressImpact: 0.05,
        feedbackBad:
            'Celebrations are fine, but spending 80% of surplus is risky.',
      ),
    ],
  ),
  BudgetScenario(
    id: 'f_medical',
    title: 'Child\'s Sudden Illness',
    description:
        'Your child needs urgent medical treatment costing ₹8,000. The nearest hospital is 30 km away.',
    type: 'medical_bill',
    decisions: [
      BudgetDecision(
        title: 'Pay from emergency fund',
        subtitle: 'Use saved emergency money. No debt incurred.',
        icon: 'shield',
        walletImpact: -8000,
        stressImpact: -0.05,
        feedbackGood: 'This is exactly why emergency funds exist!',
        isRecommended: true,
      ),
      BudgetDecision(
        title: 'Take a loan from local moneylender',
        subtitle: '5% monthly interest. You\'ll pay ₹12,000 over 3 months.',
        icon: 'warning',
        walletImpact: -12000,
        stressImpact: 0.25,
        feedbackBad: 'High-interest loans trap families in debt cycles.',
      ),
      BudgetDecision(
        title: 'Sell a goat from the herd',
        subtitle: 'Get ₹8,000 now but lose future income from the goat.',
        icon: 'pets',
        walletImpact: -5000,
        stressImpact: 0.10,
        feedbackBad:
            'Selling assets for emergencies reduces future earning ability.',
      ),
    ],
  ),
  BudgetScenario(
    id: 'f_festival',
    title: 'Diwali Festival Spending',
    description:
        'Diwali is approaching. The village expects everyone to celebrate. How do you manage your budget?',
    type: 'festival',
    decisions: [
      BudgetDecision(
        title: 'Budget ₹2,000 and stick to it',
        subtitle: 'Modest celebration within means',
        icon: 'check_circle',
        walletImpact: -2000,
        stressImpact: -0.05,
        feedbackGood: 'Celebrating within budget is the smartest choice!',
        isRecommended: true,
      ),
      BudgetDecision(
        title: 'Overspend ₹8,000 on credit',
        subtitle: 'Big celebrations now, debt later',
        icon: 'credit_card',
        walletImpact: -10000,
        stressImpact: 0.20,
        feedbackBad: 'Festival debt takes months to repay and adds stress.',
      ),
      BudgetDecision(
        title: 'Skip celebrations entirely',
        subtitle: 'Save all money but miss out on festivities',
        icon: 'money_off',
        walletImpact: 0,
        stressImpact: 0.15,
        feedbackBad: 'Social isolation can cause stress too. Balance is key.',
      ),
    ],
  ),
  BudgetScenario(
    id: 'f_jobloss',
    title: 'Monsoon Crop Failure',
    description:
        'Unexpected heavy rains destroyed 70% of your crop. This season\'s income is nearly zero.',
    type: 'job_loss',
    decisions: [
      BudgetDecision(
        title: 'Claim crop insurance',
        subtitle: 'If you bought insurance, recover ₹15,000',
        icon: 'shield',
        walletImpact: 15000,
        stressImpact: -0.15,
        feedbackGood: 'Insurance saved you! This is why risk planning matters.',
        isRecommended: true,
      ),
      BudgetDecision(
        title: 'Use emergency fund to survive',
        subtitle: 'Depletes emergency savings but avoids debt',
        icon: 'savings',
        walletImpact: -20000,
        stressImpact: 0.20,
        feedbackBad:
            'Without insurance, you lost ₹20,000. Consider insurance next time.',
      ),
      BudgetDecision(
        title: 'Seek government relief',
        subtitle: 'Apply for PM-KISAN relief. ₹5,000 after 3 months.',
        icon: 'account_balance',
        walletImpact: 5000,
        stressImpact: 0.10,
        feedbackGood: 'Government schemes help, but delays mean hardship.',
      ),
    ],
  ),
];

const List<BudgetScenario> _womanBudgetScenarios = [
  BudgetScenario(
    id: 'w_salary',
    title: 'Tailoring Business Boom',
    description:
        'Your tailoring business earned ₹5,000 extra this month due to wedding season orders!',
    type: 'salary_increase',
    decisions: [
      BudgetDecision(
        title: 'Save ₹3,000, invest ₹2,000 in material',
        subtitle: 'Build savings while growing business',
        icon: 'savings',
        walletImpact: 5000,
        stressImpact: -0.10,
        isRecommended: true,
        feedbackGood: 'Perfect balance of saving and investing!',
      ),
      BudgetDecision(
        title: 'Buy gold jewelry',
        subtitle: 'Traditional savings but not liquid',
        icon: 'diamond',
        walletImpact: 0,
        stressImpact: 0.0,
        feedbackGood: 'Gold has value but bank savings earn interest.',
      ),
      BudgetDecision(
        title: 'Spend on household upgrages',
        subtitle: 'New utensils and clothes for family',
        icon: 'home',
        walletImpact: -3000,
        stressImpact: 0.05,
        feedbackBad: 'Immediate comfort but no financial buffer.',
      ),
    ],
  ),
  BudgetScenario(
    id: 'w_medical',
    title: 'Mother-in-law\'s Surgery',
    description:
        'Your mother-in-law needs an urgent ₹10,000 surgery. The family is looking to you for help.',
    type: 'medical_bill',
    decisions: [
      BudgetDecision(
        title: 'Pay from emergency fund',
        subtitle: 'Use emergency savings',
        icon: 'shield',
        walletImpact: -10000,
        stressImpact: -0.05,
        isRecommended: true,
        feedbackGood: 'Emergency fund worked as intended!',
      ),
      BudgetDecision(
        title: 'Borrow from SHG',
        subtitle: 'Low-interest SHG loan of ₹10,000',
        icon: 'groups',
        walletImpact: -11000,
        stressImpact: 0.10,
        feedbackGood: 'SHG loans are better than moneylenders.',
      ),
      BudgetDecision(
        title: 'Sell tailoring machine',
        subtitle: 'Get ₹10,000 but lose income source',
        icon: 'warning',
        walletImpact: -10000,
        stressImpact: 0.30,
        feedbackBad: 'Never sell income-generating assets!',
      ),
    ],
  ),
  BudgetScenario(
    id: 'w_festival',
    title: 'Raksha Bandhan Celebrations',
    description:
        'Raksha Bandhan is here. You need gifts for brothers and decorations for the house.',
    type: 'festival',
    decisions: [
      BudgetDecision(
        title: 'Handmade gifts + ₹1,000 budget',
        subtitle: 'Thoughtful and within means',
        icon: 'favorite',
        walletImpact: -1000,
        stressImpact: -0.05,
        isRecommended: true,
        feedbackGood: 'Handmade gifts show love without breaking the bank!',
      ),
      BudgetDecision(
        title: 'Buy expensive gifts worth ₹5,000',
        subtitle: 'Impress family but strain budget',
        icon: 'card_giftcard',
        walletImpact: -5000,
        stressImpact: 0.15,
        feedbackBad: 'Social pressure shouldn\'t dictate your budget.',
      ),
    ],
  ),
  BudgetScenario(
    id: 'w_jobloss',
    title: 'Husband\'s Factory Shutdown',
    description:
        'Your husband\'s factory closed for 2 months. Family income dropped by 60%.',
    type: 'job_loss',
    decisions: [
      BudgetDecision(
        title: 'Cut expenses to essentials + use emergency fund',
        subtitle: 'Survive on bare minimum for 2 months',
        icon: 'savings',
        walletImpact: -8000,
        stressImpact: 0.10,
        isRecommended: true,
        feedbackGood: 'Emergency planning saved your family.',
      ),
      BudgetDecision(
        title: 'Take children out of school to save fees',
        subtitle: 'Save ₹2,000/month but hurt education',
        icon: 'school',
        walletImpact: -4000,
        stressImpact: 0.25,
        feedbackBad:
            'Education is an investment. Find other ways to cut costs.',
      ),
      BudgetDecision(
        title: 'Take high-interest loan',
        subtitle: 'Maintain lifestyle but accumulate debt',
        icon: 'warning',
        walletImpact: -15000,
        stressImpact: 0.30,
        feedbackBad: 'Debt during income loss creates a dangerous spiral.',
      ),
    ],
  ),
];

const List<BudgetScenario> _studentBudgetScenarios = [
  BudgetScenario(
    id: 's_salary',
    title: 'Extra Pocket Money!',
    description:
        'Parents gave you ₹1,000 extra for scoring well in exams. What will you do with it?',
    type: 'salary_increase',
    decisions: [
      BudgetDecision(
        title: 'Save ₹700, treat yourself to ₹300',
        subtitle: 'Reward yourself while building savings',
        icon: 'savings',
        walletImpact: 1000,
        stressImpact: -0.10,
        isRecommended: true,
        feedbackGood: 'The 70-30 rule: save 70%, enjoy 30%!',
      ),
      BudgetDecision(
        title: 'Buy a new video game for ₹1,000',
        subtitle: 'Instant gratification, zero savings',
        icon: 'games',
        walletImpact: 0,
        stressImpact: 0.05,
        feedbackBad: 'Spending everything leaves nothing for emergencies.',
      ),
      BudgetDecision(
        title: 'Buy study books for ₹800',
        subtitle: 'Invest in education',
        icon: 'menu_book',
        walletImpact: 200,
        stressImpact: -0.05,
        feedbackGood: 'Investing in your future is always smart!',
      ),
    ],
  ),
  BudgetScenario(
    id: 's_medical',
    title: 'Friend Needs Medicine Money',
    description:
        'Your close friend needs ₹500 for urgent medicines. They promise to repay next week.',
    type: 'medical_bill',
    decisions: [
      BudgetDecision(
        title: 'Help with ₹500 from savings',
        subtitle: 'Be a good friend, but set a return date',
        icon: 'favorite',
        walletImpact: -500,
        stressImpact: -0.05,
        isRecommended: true,
        feedbackGood:
            'Helping others in need is noble, but always track loans.',
      ),
      BudgetDecision(
        title: 'Give ₹250, suggest they ask others too',
        subtitle: 'Share the burden',
        icon: 'groups',
        walletImpact: -250,
        stressImpact: 0.0,
        feedbackGood: 'Partial help while protecting your own finances.',
      ),
      BudgetDecision(
        title: 'Say no, it\'s not your problem',
        subtitle: 'Protect your money',
        icon: 'block',
        walletImpact: 0,
        stressImpact: 0.10,
        feedbackBad: 'Sometimes helping is important. Find a middle ground.',
      ),
    ],
  ),
  BudgetScenario(
    id: 's_festival',
    title: 'Birthday Party Pressure',
    description:
        'It\'s your birthday! Friends expect you to throw a party at a cafe. Budget-friendly or go big?',
    type: 'festival',
    decisions: [
      BudgetDecision(
        title: 'Home party with homemade snacks (₹500)',
        subtitle: 'Fun and affordable',
        icon: 'home',
        walletImpact: -500,
        stressImpact: -0.05,
        isRecommended: true,
        feedbackGood: 'Great memories don\'t need expensive venues!',
      ),
      BudgetDecision(
        title: 'Cafe party for 10 friends (₹2,500)',
        subtitle: 'Cool but expensive',
        icon: 'restaurant',
        walletImpact: -2500,
        stressImpact: 0.10,
        feedbackBad: 'Fun party, but half your monthly money is gone.',
      ),
      BudgetDecision(
        title: 'Skip the party, save everything',
        subtitle: 'No celebration',
        icon: 'money_off',
        walletImpact: 0,
        stressImpact: 0.10,
        feedbackBad: 'Balance is key. A small celebration is fine!',
      ),
    ],
  ),
  BudgetScenario(
    id: 's_jobloss',
    title: 'Coaching Fee Increase',
    description:
        'Your coaching class fees suddenly increased by ₹2,000/month. Parents are struggling.',
    type: 'job_loss',
    decisions: [
      BudgetDecision(
        title: 'Switch to free online courses',
        subtitle: 'YouTube + Khan Academy are free',
        icon: 'laptop',
        walletImpact: 2000,
        stressImpact: -0.10,
        isRecommended: true,
        feedbackGood: 'Smart! Free resources can be just as effective.',
      ),
      BudgetDecision(
        title: 'Ask parents to pay the increase',
        subtitle: 'Continue coaching but family stress increases',
        icon: 'family_restroom',
        walletImpact: -2000,
        stressImpact: 0.15,
        feedbackBad: 'Consider your family\'s financial situation.',
      ),
      BudgetDecision(
        title: 'Start tutoring juniors to pay difference',
        subtitle: 'Earn ₹2,000/month tutoring math',
        icon: 'school',
        walletImpact: 0,
        stressImpact: 0.05,
        feedbackGood: 'Self-reliance is impressive! Watch your own study time.',
      ),
    ],
  ),
];

const List<BudgetScenario> _youngAdultBudgetScenarios = [
  BudgetScenario(
    id: 'ya_salary',
    title: '20% Salary Hike!',
    description:
        'You got a 20% raise! New salary: ₹60,000/month. How will you adjust your lifestyle?',
    type: 'salary_increase',
    decisions: [
      BudgetDecision(
        title: 'Save 50% of the raise',
        subtitle: 'Increase savings by ₹5,000/month. SIP into mutual fund.',
        icon: 'trending_up',
        walletImpact: 10000,
        stressImpact: -0.15,
        isRecommended: true,
        feedbackGood: 'The 50% raise-save rule builds wealth fast!',
      ),
      BudgetDecision(
        title: 'Upgrade lifestyle — new apartment',
        subtitle: 'Move to a better flat, ₹8,000 more rent',
        icon: 'apartment',
        walletImpact: 2000,
        stressImpact: 0.05,
        feedbackBad:
            'Lifestyle inflation eats raises. Save first, upgrade later.',
      ),
      BudgetDecision(
        title: 'Buy a new bike on EMI',
        subtitle: '₹5,000/month EMI for 2 years',
        icon: 'two_wheeler',
        walletImpact: -5000,
        stressImpact: 0.15,
        feedbackBad: 'EMI on depreciating assets is a financial drain.',
      ),
    ],
  ),
  BudgetScenario(
    id: 'ya_medical',
    title: 'Appendix Surgery',
    description:
        'Sudden appendix pain! Surgery costs ₹50,000. Your health insurance covers ₹30,000.',
    type: 'medical_bill',
    decisions: [
      BudgetDecision(
        title: 'Insurance + emergency fund',
        subtitle: '₹30,000 from insurance, ₹20,000 from emergency fund',
        icon: 'shield',
        walletImpact: -20000,
        stressImpact: -0.05,
        isRecommended: true,
        feedbackGood: 'Insurance + emergency fund = financial safety net!',
      ),
      BudgetDecision(
        title: 'Credit card EMI for ₹50,000',
        subtitle: 'No insurance? Pay over 12 months at 18% interest',
        icon: 'credit_card',
        walletImpact: -59000,
        stressImpact: 0.25,
        feedbackBad:
            'Credit card EMI at 18% means you pay ₹59,000 for a ₹50,000 bill.',
      ),
      BudgetDecision(
        title: 'Borrow from parents',
        subtitle: 'No interest but emotional debt',
        icon: 'family_restroom',
        walletImpact: -50000,
        stressImpact: 0.10,
        feedbackGood: 'Better than credit cards, but get your own insurance.',
      ),
    ],
  ),
  BudgetScenario(
    id: 'ya_festival',
    title: 'Wedding Season',
    description:
        '3 weddings this month! Each expects gifts worth ₹3,000-5,000. Your total budget?',
    type: 'festival',
    decisions: [
      BudgetDecision(
        title: 'Budget ₹3,000 per wedding (₹9,000 total)',
        subtitle: 'Reasonable gifts within means',
        icon: 'card_giftcard',
        walletImpact: -9000,
        stressImpact: -0.05,
        isRecommended: true,
        feedbackGood:
            'Setting a per-event budget is smart financial discipline.',
      ),
      BudgetDecision(
        title: 'Go big: ₹5,000 each (₹15,000 total)',
        subtitle: 'Impress everyone but strain finances',
        icon: 'diamond',
        walletImpact: -15000,
        stressImpact: 0.15,
        feedbackBad: 'Social pressure shouldn\'t determine your spending.',
      ),
      BudgetDecision(
        title: 'Skip 2 weddings, attend 1',
        subtitle: 'Save ₹10,000 but hurt relationships',
        icon: 'event_busy',
        walletImpact: -3000,
        stressImpact: 0.10,
        feedbackBad: 'Relationships matter. Find a balanced middle ground.',
      ),
    ],
  ),
  BudgetScenario(
    id: 'ya_jobloss',
    title: 'Company Layoffs',
    description:
        'Your company is downsizing. You might lose your job. You have 1 month\'s notice.',
    type: 'job_loss',
    decisions: [
      BudgetDecision(
        title: 'Cut expenses drastically + job hunt',
        subtitle: 'Reduce spending to bare minimum, apply everywhere',
        icon: 'search',
        walletImpact: -5000,
        stressImpact: 0.10,
        isRecommended: true,
        feedbackGood:
            'Proactive job hunting + expense cutting is the right move.',
      ),
      BudgetDecision(
        title: 'Use emergency fund to maintain lifestyle',
        subtitle: 'Keep spending, use savings',
        icon: 'savings',
        walletImpact: -30000,
        stressImpact: 0.20,
        feedbackBad:
            'Maintaining lifestyle during unemployment drains savings fast.',
      ),
      BudgetDecision(
        title: 'Start freelancing immediately',
        subtitle: 'Use skills to earn part-time while job hunting',
        icon: 'laptop',
        walletImpact: 5000,
        stressImpact: 0.05,
        feedbackGood: 'Multiple income streams provide security.',
      ),
    ],
  ),
];

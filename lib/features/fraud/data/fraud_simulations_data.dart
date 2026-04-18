/// Fraud simulation data models and role-specific scam scenarios.

class FraudSimulation {
  final String id;
  final String role;
  final String title;
  final String type;
  final String senderName;
  final String messageContent;
  final bool isScam;
  final double walletImpactIfFooled;
  final int safetyScoreImpact;
  final String explanation;
  final String safetyTip;
  final int timeLimitSeconds;

  const FraudSimulation({
    required this.id,
    required this.role,
    required this.title,
    required this.type,
    required this.senderName,
    required this.messageContent,
    required this.isScam,
    required this.walletImpactIfFooled,
    required this.safetyScoreImpact,
    required this.explanation,
    required this.safetyTip,
    this.timeLimitSeconds = 30,
  });
}

class MicroChallenge {
  final String id;
  final String type;
  final String title;
  final String question;
  final List<ChallengeOption> options;
  final String correctAnswerId;
  final String explanation;
  final int points;

  const MicroChallenge({
    required this.id, required this.type, required this.title,
    required this.question, required this.options,
    required this.correctAnswerId, required this.explanation, this.points = 10,
  });
}

class ChallengeOption {
  final String id;
  final String text;
  final bool isScam;
  const ChallengeOption({required this.id, required this.text, required this.isScam});
}

const Map<String, List<FraudSimulation>> fraudSimulationsByRole = {
  'Farmer': [
    FraudSimulation(id: 'f1', role: 'Farmer', title: 'Fake Pesticide Dealer', type: 'whatsapp', senderName: '+91 98765 43210',
      messageContent: '🌿 SPECIAL OFFER! Premium pesticide at 50% discount!\nPay ₹5,000 via UPI to 9876543210\n⚠️ Offer expires TODAY!',
      isScam: true, walletImpactIfFooled: -5000, safetyScoreImpact: -20,
      explanation: 'No legitimate dealer asks for advance UPI payments via WhatsApp.',
      safetyTip: 'Always buy from known shops. Never pay advance to unknown numbers.'),
    FraudSimulation(id: 'f2', role: 'Farmer', title: 'PM-KISAN Payment Fraud', type: 'sms', senderName: 'PM-KISAN',
      messageContent: 'Your PM-KISAN ₹6,000 payment pending. Verify Aadhaar: http://pm-kisan-verify.xyz/claim',
      isScam: true, walletImpactIfFooled: -15000, safetyScoreImpact: -25,
      explanation: 'PM-KISAN never sends SMS links. Official site is pmkisan.gov.in.',
      safetyTip: 'Government sites end in .gov.in. Never click SMS links.'),
    FraudSimulation(id: 'f3', role: 'Farmer', title: 'Bank Credit Notification', type: 'sms', senderName: 'SBI',
      messageContent: 'A/c XX1234 credited INR 6,000.00. Info: GOVT/PMKISAN. Bal: INR 12,450. -SBI',
      isScam: false, walletImpactIfFooled: 0, safetyScoreImpact: 10,
      explanation: 'Genuine bank notification with masked account, amount, and balance.',
      safetyTip: 'Real bank SMS show account number, amount, and balance.'),
    FraudSimulation(id: 'f4', role: 'Farmer', title: 'Fake Insurance Agent', type: 'phone_call', senderName: 'Unknown',
      messageContent: '"I am from LIC. Your policy expiring tomorrow. Pay ₹3,000 renewal via Google Pay to 9876543210."',
      isScam: true, walletImpactIfFooled: -3000, safetyScoreImpact: -15,
      explanation: 'LIC never demands urgent payment to personal UPI IDs over phone.',
      safetyTip: 'Never pay anyone who calls demanding urgent payment.'),
  ],
  'Woman': [
    FraudSimulation(id: 'w1', role: 'Woman', title: 'WhatsApp Lottery', type: 'whatsapp', senderName: '+91 87654 32100',
      messageContent: '🎉 You won ₹10,00,000 in Jio Lucky Draw!\nPay ₹2,000 processing fee.\nUPI: lucky.draw@paytm',
      isScam: true, walletImpactIfFooled: -2000, safetyScoreImpact: -20,
      explanation: 'No company asks winners to pay fees. Classic advance-fee scam.',
      safetyTip: 'If you didn\'t enter a contest, you didn\'t win.'),
    FraudSimulation(id: 'w2', role: 'Woman', title: 'Bank KYC Scam', type: 'sms', senderName: 'SBI',
      messageContent: 'KYC expiring today. Update: http://sbi-kyc-update.xyz to avoid account freeze.',
      isScam: true, walletImpactIfFooled: -20000, safetyScoreImpact: -25,
      explanation: 'Banks never send KYC links via SMS. KYC is done at branches.',
      safetyTip: 'Visit bank branch for KYC. Never click SMS links.'),
    FraudSimulation(id: 'w3', role: 'Woman', title: 'UPI Payment Received', type: 'sms', senderName: 'PAYTM',
      messageContent: 'Received ₹500 from ASHOK KUMAR via UPI Ref: 412345678. Balance: ₹1,250.',
      isScam: false, walletImpactIfFooled: 0, safetyScoreImpact: 10,
      explanation: 'Genuine UPI notification with sender name and reference.',
      safetyTip: 'Real payment notifications show sender and reference.'),
    FraudSimulation(id: 'w4', role: 'Woman', title: 'Fake Delivery Fee', type: 'sms', senderName: 'AMAZON',
      messageContent: 'Order delivery failed. Pay ₹199 re-delivery: http://amazon-redeliver.com/pay',
      isScam: true, walletImpactIfFooled: -199, safetyScoreImpact: -15,
      explanation: 'Amazon never charges re-delivery via SMS links.',
      safetyTip: 'Check delivery in the official app, not SMS links.'),
  ],
  'Student': [
    FraudSimulation(id: 's1', role: 'Student', title: 'Free Gaming Diamonds', type: 'whatsapp', senderName: 'FreeFire',
      messageContent: '🔥 FREE 10,000 DIAMONDS! Enter UPI PIN to verify: http://freefire-diamonds.xyz',
      isScam: true, walletImpactIfFooled: -5000, safetyScoreImpact: -20,
      explanation: 'No game gives free items via WhatsApp. Entering UPI PIN steals money.',
      safetyTip: 'Never enter UPI PIN anywhere except your UPI app.'),
    FraudSimulation(id: 's2', role: 'Student', title: 'Fake Scholarship', type: 'email', senderName: 'scholarship@edu.xyz',
      messageContent: 'Selected for ₹50,000 National Merit Scholarship! Pay ₹500 registration fee. UPI: scholarship@ybl',
      isScam: true, walletImpactIfFooled: -500, safetyScoreImpact: -15,
      explanation: 'Government scholarships never charge fees. Check scholarships.gov.in.',
      safetyTip: 'Real scholarships never charge fees.'),
    FraudSimulation(id: 's3', role: 'Student', title: 'CBSE Result SMS', type: 'sms', senderName: 'CBSE',
      messageContent: 'Roll No 1234567, Result: PASS, Percentage: 89.2%. Check cbseresults.nic.in',
      isScam: false, walletImpactIfFooled: 0, safetyScoreImpact: 10,
      explanation: 'Genuine CBSE result. Uses official .nic.in domain. No payment asked.',
      safetyTip: 'Government sites use .gov.in or .nic.in domains.'),
    FraudSimulation(id: 's4', role: 'Student', title: 'Instagram Hack Alert', type: 'email', senderName: 'instagran.com',
      messageContent: 'Your Instagram will be deleted in 24 hours! Verify: http://insta-verify.xyz/secure',
      isScam: true, walletImpactIfFooled: -3000, safetyScoreImpact: -20,
      explanation: 'Email from "instagran.com" (misspelled!). Instagram never threatens deletion.',
      safetyTip: 'Check sender email domain carefully. One letter = scam.'),
  ],
  'Young Adult': [
    FraudSimulation(id: 'ya1', role: 'Young Adult', title: 'WFH Job Scam', type: 'whatsapp', senderName: '+91 76543 21000',
      messageContent: '💼 Data Entry ₹50K/month! Registration fee: ₹2,000. UPI: digitalsol@axl. Limited seats!',
      isScam: true, walletImpactIfFooled: -2000, safetyScoreImpact: -20,
      explanation: 'Legitimate companies never charge registration fees for jobs.',
      safetyTip: 'If a job requires payment, it\'s a scam.'),
    FraudSimulation(id: 'ya2', role: 'Young Adult', title: 'Crypto Ponzi Scheme', type: 'whatsapp', senderName: 'CryptoGroup',
      messageContent: '📈 GUARANTEED 200% RETURNS! Invest ₹10,000 → Get ₹30,000 in 30 days! UPI: cryptoprofit@paytm',
      isScam: true, walletImpactIfFooled: -10000, safetyScoreImpact: -25,
      explanation: 'No investment guarantees returns. This is a Ponzi scheme.',
      safetyTip: 'If returns sound too good to be true, they are.'),
    FraudSimulation(id: 'ya3', role: 'Young Adult', title: 'Salary Credit', type: 'sms', senderName: 'HDFC',
      messageContent: 'INR 50,000.00 credited to a/c XX5678. Info: NEFT/SALARY/TECHCORP. Bal: INR 72,450. -HDFC Bank',
      isScam: false, walletImpactIfFooled: 0, safetyScoreImpact: 10,
      explanation: 'Genuine salary credit with masked account, NEFT reference, and balance.',
      safetyTip: 'Real bank SMS show masked accounts and reference IDs.'),
    FraudSimulation(id: 'ya4', role: 'Young Adult', title: 'Delivery OTP Scam', type: 'phone_call', senderName: 'Unknown',
      messageContent: '"Flipkart delivery. Need OTP sent to your number for address verification."',
      isScam: true, walletImpactIfFooled: -25000, safetyScoreImpact: -25,
      explanation: 'Delivery agents never need OTP. Sharing OTP empties your account.',
      safetyTip: 'NEVER share OTP with anyone.'),
  ],
};

const List<MicroChallenge> microChallenges = [
  MicroChallenge(id: 'mc1', type: 'spot_fake_sms', title: 'Spot the Fake Bank SMS', question: 'Which is a SCAM?',
    options: [
      ChallengeOption(id: 'a', text: 'A/c XX1234 credited Rs.5,000. Ref: NEFT/UTR123. -SBI', isScam: false),
      ChallengeOption(id: 'b', text: 'URGENT: SBI account blocked! Click http://sbi-verify.xyz', isScam: true),
    ], correctAnswerId: 'b', explanation: 'Banks never send links in SMS.'),
  MicroChallenge(id: 'mc2', type: 'unsafe_link', title: 'Unsafe URL', question: 'Which URL is dangerous?',
    options: [
      ChallengeOption(id: 'a', text: 'https://www.onlinesbi.sbi/', isScam: false),
      ChallengeOption(id: 'b', text: 'https://sbi-login-secure.xyz/verify', isScam: true),
    ], correctAnswerId: 'b', explanation: '.xyz domain is suspicious. SBI uses .sbi domain.'),
  MicroChallenge(id: 'mc3', type: 'fake_caller', title: 'Scam Call', question: 'Which caller is a scammer?',
    options: [
      ChallengeOption(id: 'a', text: '"Visit HDFC branch with ID for KYC by April 30"', isScam: false),
      ChallengeOption(id: 'b', text: '"Share OTP now or account freezes in 2 hours!"', isScam: true),
    ], correctAnswerId: 'b', explanation: 'Banks never ask for OTP over phone.'),
  MicroChallenge(id: 'mc4', type: 'spot_fake_sms', title: 'Lottery Scam', question: 'Which is a SCAM?',
    options: [
      ChallengeOption(id: 'a', text: 'Won ₹25L in Jio Draw! Pay ₹999 to claim.', isScam: true),
      ChallengeOption(id: 'b', text: 'Jio recharge ₹399 successful. 28 days validity.', isScam: false),
    ], correctAnswerId: 'a', explanation: 'Prizes never require payment from you.'),
  MicroChallenge(id: 'mc5', type: 'unsafe_link', title: 'QR Code Safety', question: 'Which is SAFE?',
    options: [
      ChallengeOption(id: 'a', text: 'Shopkeeper QR at counter to pay ₹200', isScam: false),
      ChallengeOption(id: 'b', text: 'Stranger asks scan QR to "receive" ₹500', isScam: true),
    ], correctAnswerId: 'a', explanation: 'QR is for paying, not receiving money.'),
  MicroChallenge(id: 'mc6', type: 'fake_caller', title: 'OTP Rule', question: 'Someone calls for OTP. What do you do?',
    options: [
      ChallengeOption(id: 'a', text: 'Share it — they said they\'re from bank', isScam: true),
      ChallengeOption(id: 'b', text: 'Refuse and hang up', isScam: false),
    ], correctAnswerId: 'b', explanation: 'OTP is a password. NEVER share it.'),
];

class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final String txType; // 'credit' or 'debit'
  final String category; // budgeting, fraud, emergency, scenario, salary, reward
  final String description;
  final String? sourceModule;
  final String? scenarioId;
  final DateTime createdAt;
  final bool synced;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.txType,
    required this.category,
    required this.description,
    this.sourceModule,
    this.scenarioId,
    required this.createdAt,
    this.synced = false,
  });

  bool get isCredit => txType == 'credit';
  bool get isDebit => txType == 'debit';

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      txType: json['tx_type'] ?? 'debit',
      category: json['category'] ?? 'scenario',
      description: json['description'] ?? '',
      sourceModule: json['source_module'],
      scenarioId: json['scenario_id'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
      synced: json['synced'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'tx_type': txType,
      'category': category,
      'description': description,
      'source_module': sourceModule,
      'scenario_id': scenarioId,
      'created_at': createdAt.toIso8601String(),
      'synced': synced,
    };
  }
}

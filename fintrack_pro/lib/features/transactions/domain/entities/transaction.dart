import 'package:equatable/equatable.dart';

enum TransactionType {
  recette('recette'),
  depense('depense');

  const TransactionType(this.value);
  final String value;

  static TransactionType fromString(String value) {
    return TransactionType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => TransactionType.recette,
    );
  }
}

enum TransactionStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected'),
  completed('completed');

  const TransactionStatus(this.value);
  final String value;

  static TransactionStatus fromString(String value) {
    return TransactionStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TransactionStatus.pending,
    );
  }
}

class Transaction extends Equatable {
  final String id;
  final String activityId;
  final String userId;
  final TransactionType type;
  final double amount;
  final TransactionStatus status;
  final String description;
  final DateTime transactionDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? rejectionReason;

  const Transaction({
    required this.id,
    required this.activityId,
    required this.userId,
    required this.type,
    required this.amount,
    required this.status,
    required this.description,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
    this.approvedBy,
    this.approvedAt,
    this.rejectionReason,
  });

  // Factory pour créer depuis TransactionEntity (Drift)
  factory Transaction.fromEntity(dynamic entity) {
    return Transaction(
      id: entity.id,
      activityId: entity.activityId,
      userId: entity.userId,
      type: TransactionType.fromString(entity.type),
      amount: entity.amount,
      status: TransactionStatus.fromString(entity.status),
      description: entity.description,
      transactionDate: entity.transactionDate,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      approvedBy: entity.approvedBy,
      approvedAt: entity.approvedAt,
      rejectionReason: entity.rejectionReason,
    );
  }

  // Méthode pour convertir en TransactionEntity
  dynamic toEntity() {
    return {
      'id': id,
      'activityId': activityId,
      'userId': userId,
      'type': type.value,
      'amount': amount,
      'status': status.value,
      'description': description,
      'transactionDate': transactionDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt,
      'rejectionReason': rejectionReason,
    };
  }

  Transaction copyWith({
    String? id,
    String? activityId,
    String? userId,
    TransactionType? type,
    double? amount,
    TransactionStatus? status,
    String? description,
    DateTime? transactionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? approvedBy,
    DateTime? approvedAt,
    String? rejectionReason,
  }) {
    return Transaction(
      id: id ?? this.id,
      activityId: activityId ?? this.activityId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      description: description ?? this.description,
      transactionDate: transactionDate ?? this.transactionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  @override
  List<Object?> get props => [
    id,
    activityId,
    userId,
    type,
    amount,
    status,
    description,
    transactionDate,
    createdAt,
    updatedAt,
    approvedBy,
    approvedAt,
    rejectionReason,
  ];
}
import 'package:fintrack_pro/features/transactions/domain/entities/transaction.dart';

class TransactionModel {
  final String id;
  final String activityId;
  final String userId;
  final String type;
  final double amount;
  final String status;
  final String description;
  final DateTime transactionDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? rejectionReason;

  TransactionModel({
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
  factory TransactionModel.fromEntity(dynamic entity) {
    return TransactionModel(
      id: entity.id,
      activityId: entity.activityId,
      userId: entity.userId,
      type: entity.type,
      amount: entity.amount,
      status: entity.status,
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
      'type': type,
      'amount': amount,
      'status': status,
      'description': description,
      'transactionDate': transactionDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt,
      'rejectionReason': rejectionReason,
    };
  }

  // Méthode pour convertir vers le domaine
  Transaction toDomain() {
    return Transaction(
      id: id,
      activityId: activityId,
      userId: userId,
      type: TransactionType.fromString(type),
      amount: amount,
      status: TransactionStatus.fromString(status),
      description: description,
      transactionDate: transactionDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      approvedBy: approvedBy,
      approvedAt: approvedAt,
      rejectionReason: rejectionReason,
    );
  }

  // Factory pour créer depuis le domaine
  factory TransactionModel.fromDomain(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      activityId: transaction.activityId,
      userId: transaction.userId,
      type: transaction.type.value,
      amount: transaction.amount,
      status: transaction.status.value,
      description: transaction.description,
      transactionDate: transaction.transactionDate,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
      approvedBy: transaction.approvedBy,
      approvedAt: transaction.approvedAt,
      rejectionReason: transaction.rejectionReason,
    );
  }

  TransactionModel copyWith({
    String? id,
    String? activityId,
    String? userId,
    String? type,
    double? amount,
    String? status,
    String? description,
    DateTime? transactionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? approvedBy,
    DateTime? approvedAt,
    String? rejectionReason,
  }) {
    return TransactionModel(
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
}
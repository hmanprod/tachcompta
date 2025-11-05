import 'package:fpdart/fpdart.dart';

import '../entities/transaction.dart';

abstract class TransactionFailure {
  const TransactionFailure();
}

class TransactionNotFoundFailure extends TransactionFailure {
  final String message;
  const TransactionNotFoundFailure(this.message);
}

class TransactionValidationFailure extends TransactionFailure {
  final String message;
  const TransactionValidationFailure(this.message);
}

class TransactionDatabaseFailure extends TransactionFailure {
  final String message;
  const TransactionDatabaseFailure(this.message);
}

class TransactionPermissionFailure extends TransactionFailure {
  final String message;
  const TransactionPermissionFailure(this.message);
}

class TransactionApprovalFailure extends TransactionFailure {
  final String message;
  const TransactionApprovalFailure(this.message);
}

abstract class TransactionRepository {
  // CRUD Transactions
  Future<Either<TransactionFailure, List<Transaction>>> getAllTransactions();
  Future<Either<TransactionFailure, Transaction?>> getTransactionById(String id);
  Future<Either<TransactionFailure, Transaction>> createTransaction(Transaction transaction);
  Future<Either<TransactionFailure, Transaction>> updateTransaction(Transaction transaction);
  Future<Either<TransactionFailure, void>> deleteTransaction(String id);

  // Transactions par activité
  Future<Either<TransactionFailure, List<Transaction>>> getTransactionsByActivity(String activityId);
  Future<Either<TransactionFailure, List<Transaction>>> getTransactionsByUser(String userId);

  // Workflow d'approbation
  Future<Either<TransactionFailure, Transaction>> approveTransaction(String id, String approvedBy);
  Future<Either<TransactionFailure, Transaction>> rejectTransaction(String id, String approvedBy, String reason);
  Future<Either<TransactionFailure, Transaction>> completeTransaction(String id);
  Future<Either<TransactionFailure, Transaction>> cancelTransaction(String id, String reason);

  // Transactions en attente
  Future<Either<TransactionFailure, List<Transaction>>> getPendingTransactions();
  Future<Either<TransactionFailure, List<Transaction>>> getPendingTransactionsByActivity(String activityId);

  // Calculs automatiques
  Future<Either<TransactionFailure, double>> getActivityBalance(String activityId);
  Future<Either<TransactionFailure, Map<String, double>>> getAllActivitiesBalances();

  // Filtres avancés
  Future<Either<TransactionFailure, List<Transaction>>> getTransactionsByStatus(TransactionStatus status);
  Future<Either<TransactionFailure, List<Transaction>>> getTransactionsByType(TransactionType type);
  Future<Either<TransactionFailure, List<Transaction>>> getTransactionsByDateRange(DateTime start, DateTime end);
  Future<Either<TransactionFailure, List<Transaction>>> searchTransactions(String query);

  // Statistiques
  Future<Either<TransactionFailure, Map<String, int>>> getTransactionCountsByStatus();
  Future<Either<TransactionFailure, double>> getTotalRevenue();
  Future<Either<TransactionFailure, double>> getTotalExpenses();
  Future<Either<TransactionFailure, double>> getTotalAmountToCollect();
}
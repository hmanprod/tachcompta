import 'package:fpdart/fpdart.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource dataSource;

  TransactionRepositoryImpl(this.dataSource);

  @override
  Future<Either<TransactionFailure, List<Transaction>>> getAllTransactions() async {
    try {
      final transactions = await dataSource.getAllTransactions();
      return Right(transactions.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(TransactionDatabaseFailure('Erreur lors de la récupération des transactions: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, Transaction?>> getTransactionById(String id) async {
    try {
      final transaction = await dataSource.getTransactionById(id);
      return Right(transaction?.toDomain());
    } catch (e) {
      return Left(TransactionDatabaseFailure('Erreur lors de la récupération de la transaction: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, Transaction>> createTransaction(Transaction transaction) async {
    try {
      // Validation de base
      if (transaction.amount <= 0) {
        return Left(TransactionValidationFailure('Le montant doit être positif'));
      }

      if (transaction.description.isEmpty) {
        return Left(TransactionValidationFailure('La description est requise'));
      }

      // Vérifier les permissions selon le rôle de l'utilisateur
      // Cette logique sera implémentée dans les usecases

      final model = TransactionModel.fromDomain(transaction);
      final created = await dataSource.createTransaction(model);
      return Right(created.toDomain());
    } catch (e) {
      return Left(TransactionDatabaseFailure('Erreur lors de la création de la transaction: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, Transaction>> updateTransaction(Transaction transaction) async {
    try {
      // Validation de base
      if (transaction.amount <= 0) {
        return Left(TransactionValidationFailure('Le montant doit être positif'));
      }

      if (transaction.description.isEmpty) {
        return Left(TransactionValidationFailure('La description est requise'));
      }

      final model = TransactionModel.fromDomain(transaction);
      final updated = await dataSource.updateTransaction(model);
      return Right(updated.toDomain());
    } catch (e) {
      return Left(TransactionDatabaseFailure('Erreur lors de la mise à jour de la transaction: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, void>> deleteTransaction(String id) async {
    try {
      await dataSource.deleteTransaction(id);
      return const Right(null);
    } catch (e) {
      return Left(TransactionDatabaseFailure('Erreur lors de la suppression de la transaction: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, List<Transaction>>> getTransactionsByActivity(String activityId) async {
    try {
      final transactions = await dataSource.getTransactionsByActivity(activityId);
      return Right(transactions.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(TransactionDatabaseFailure('Erreur lors de la récupération des transactions par activité: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, List<Transaction>>> getTransactionsByUser(String userId) async {
    try {
      final transactions = await dataSource.getTransactionsByUser(userId);
      return Right(transactions.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(TransactionDatabaseFailure('Erreur lors de la récupération des transactions par utilisateur: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, Transaction>> approveTransaction(String id, String approvedBy) async {
    try {
      await dataSource.approveTransaction(id, approvedBy, DateTime.now());

      final transaction = await dataSource.getTransactionById(id);
      if (transaction == null) {
        return Left(TransactionNotFoundFailure('Transaction non trouvée après approbation'));
      }

      return Right(transaction.toDomain());
    } catch (e) {
      return Left(TransactionApprovalFailure('Erreur lors de l\'approbation: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, Transaction>> rejectTransaction(String id, String approvedBy, String reason) async {
    try {
      if (reason.isEmpty) {
        return Left(TransactionValidationFailure('La raison du rejet est requise'));
      }

      await dataSource.rejectTransaction(id, approvedBy, DateTime.now(), reason);

      final transaction = await dataSource.getTransactionById(id);
      if (transaction == null) {
        return Left(TransactionNotFoundFailure('Transaction non trouvée après rejet'));
      }

      return Right(transaction.toDomain());
    } catch (e) {
      return Left(TransactionApprovalFailure('Erreur lors du rejet: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, Transaction>> completeTransaction(String id) async {
    try {
      await dataSource.completeTransaction(id);

      final transaction = await dataSource.getTransactionById(id);
      if (transaction == null) {
        return Left(TransactionNotFoundFailure('Transaction non trouvée après réalisation'));
      }

      return Right(transaction.toDomain());
    } catch (e) {
      return Left(TransactionApprovalFailure('Erreur lors de la réalisation: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, Transaction>> cancelTransaction(String id, String reason) async {
    return rejectTransaction(id, '', reason); // Utilise la même logique de rejet
  }

  @override
  Future<Either<TransactionFailure, List<Transaction>>> getPendingTransactions() async {
    try {
      final transactions = await dataSource.getPendingTransactions();
      return Right(transactions.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(TransactionDatabaseFailure('Erreur lors de la récupération des transactions en attente: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, List<Transaction>>> getPendingTransactionsByActivity(String activityId) async {
    try {
      final transactions = await dataSource.getPendingTransactionsByActivity(activityId);
      return Right(transactions.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(TransactionDatabaseFailure('Erreur lors de la récupération des transactions en attente par activité: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, double>> getActivityBalance(String activityId) async {
    try {
      final balance = await dataSource.getActivityBalance(activityId);
      return Right(balance);
    } catch (e) {
      return Left(TransactionDatabaseFailure('Erreur lors du calcul du solde de l\'activité: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, Map<String, double>>> getAllActivitiesBalances() async {
    try {
      final balances = await dataSource.getAllActivitiesBalances();
      return Right(balances);
    } catch (e) {
      return Left(TransactionDatabaseFailure('Erreur lors du calcul des soldes: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, List<Transaction>>> getTransactionsByStatus(TransactionStatus status) async {
    try {
      final transactions = await dataSource.getTransactionsByStatus(status.value);
      return Right(transactions.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(TransactionDatabaseFailure('Erreur lors de la récupération des transactions par statut: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, List<Transaction>>> getTransactionsByType(TransactionType type) async {
    try {
      final transactions = await dataSource.getTransactionsByType(type.value);
      return Right(transactions.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(TransactionDatabaseFailure('Erreur lors de la récupération des transactions par type: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, List<Transaction>>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    try {
      final transactions = await dataSource.getTransactionsByDateRange(start, end);
      return Right(transactions.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(TransactionDatabaseFailure('Erreur lors de la récupération des transactions par période: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, List<Transaction>>> searchTransactions(String query) async {
    try {
      final transactions = await dataSource.searchTransactions(query);
      return Right(transactions.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(TransactionDatabaseFailure('Erreur lors de la recherche des transactions: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, Map<String, int>>> getTransactionCountsByStatus() async {
    try {
      final counts = await dataSource.getTransactionCountsByStatus();
      return Right(counts);
    } catch (e) {
      return Left(TransactionDatabaseFailure('Erreur lors du comptage des transactions: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, double>> getTotalRevenue() async {
    try {
      final revenue = await dataSource.getTotalRevenue();
      return Right(revenue);
    } catch (e) {
      return Left(TransactionDatabaseFailure('Erreur lors du calcul des recettes totales: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, double>> getTotalExpenses() async {
    try {
      final expenses = await dataSource.getTotalExpenses();
      return Right(expenses);
    } catch (e) {
      return Left(TransactionDatabaseFailure('Erreur lors du calcul des dépenses totales: ${e.toString()}'));
    }
  }

  @override
  Future<Either<TransactionFailure, double>> getTotalAmountToCollect() async {
    try {
      final amount = await dataSource.getTotalAmountToCollect();
      return Right(amount);
    } catch (e) {
      return Left(TransactionDatabaseFailure('Erreur lors du calcul du montant à collecter: ${e.toString()}'));
    }
  }
}
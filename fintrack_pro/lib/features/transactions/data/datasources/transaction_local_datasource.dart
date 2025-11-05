import 'package:drift/drift.dart';
import 'package:fintrack_pro/features/transactions/data/models/transaction_model.dart';
import 'package:drift/drift.dart' as drift;
import 'package:fintrack_pro/core/database/database.dart';

abstract class TransactionLocalDataSource {
  // CRUD Operations
  Future<List<TransactionModel>> getAllTransactions();
  Future<TransactionModel?> getTransactionById(String id);
  Future<TransactionModel> createTransaction(TransactionModel transaction);
  Future<TransactionModel> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);

  // Filtered Queries
  Future<List<TransactionModel>> getTransactionsByActivity(String activityId);
  Future<List<TransactionModel>> getTransactionsByUser(String userId);
  Future<List<TransactionModel>> getTransactionsByStatus(String status);
  Future<List<TransactionModel>> getTransactionsByType(String type);
  Future<List<TransactionModel>> getTransactionsByDateRange(DateTime start, DateTime end);
  Future<List<TransactionModel>> searchTransactions(String query);

  // Approval Workflow
  Future<List<TransactionModel>> getPendingTransactions();
  Future<List<TransactionModel>> getPendingTransactionsByActivity(String activityId);
  Future<void> approveTransaction(String id, String approvedBy, DateTime approvedAt);
  Future<void> rejectTransaction(String id, String approvedBy, DateTime approvedAt, String reason);
  Future<void> completeTransaction(String id);
  Future<void> cancelTransaction(String id, String reason);

  // Calculations
  Future<double> getActivityBalance(String activityId);
  Future<Map<String, double>> getAllActivitiesBalances();
  Future<Map<String, int>> getTransactionCountsByStatus();
  Future<double> getTotalRevenue();
  Future<double> getTotalExpenses();
  Future<double> getTotalAmountToCollect();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final AppDatabase database;

  TransactionLocalDataSourceImpl(this.database);

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final transactions = await database.select(database.transactions).get();
    return transactions.map((entity) => TransactionModel.fromEntity(entity)).toList();
  }

  @override
  Future<TransactionModel?> getTransactionById(String id) async {
    final query = database.select(database.transactions)
      ..where((tbl) => tbl.id.equals(id));

    final entity = await query.getSingleOrNull();
    return entity != null ? TransactionModel.fromEntity(entity) : null;
  }

  @override
  Future<TransactionModel> createTransaction(TransactionModel transaction) async {
    await database.into(database.transactions).insert(TransactionsCompanion(
      id: drift.Value(transaction.id),
      activityId: drift.Value(transaction.activityId),
      userId: drift.Value(transaction.userId),
      type: drift.Value(transaction.type),
      amount: drift.Value(transaction.amount),
      status: drift.Value(transaction.status),
      description: drift.Value(transaction.description),
      transactionDate: drift.Value(transaction.transactionDate),
      createdAt: drift.Value(transaction.createdAt),
      updatedAt: drift.Value(transaction.updatedAt),
      approvedBy: drift.Value(transaction.approvedBy),
      approvedAt: drift.Value(transaction.approvedAt),
      rejectionReason: drift.Value(transaction.rejectionReason),
    ));
    return transaction;
  }

  @override
  Future<TransactionModel> updateTransaction(TransactionModel transaction) async {
    await (database.update(database.transactions)
          ..where((tbl) => tbl.id.equals(transaction.id)))
        .write(TransactionsCompanion(
          activityId: drift.Value(transaction.activityId),
          userId: drift.Value(transaction.userId),
          type: drift.Value(transaction.type),
          amount: drift.Value(transaction.amount),
          status: drift.Value(transaction.status),
          description: drift.Value(transaction.description),
          transactionDate: drift.Value(transaction.transactionDate),
          updatedAt: drift.Value(DateTime.now()),
          approvedBy: drift.Value(transaction.approvedBy),
          approvedAt: drift.Value(transaction.approvedAt),
          rejectionReason: drift.Value(transaction.rejectionReason),
        ));
    return transaction;
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await (database.delete(database.transactions)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  @override
  Future<List<TransactionModel>> getTransactionsByActivity(String activityId) async {
    final query = database.select(database.transactions)
      ..where((tbl) => tbl.activityId.equals(activityId))
      ..orderBy([(tbl) => drift.OrderingTerm(expression: tbl.transactionDate, mode: drift.OrderingMode.desc)]);

    final transactions = await query.get();
    return transactions.map((entity) => TransactionModel.fromEntity(entity)).toList();
  }

  @override
  Future<List<TransactionModel>> getTransactionsByUser(String userId) async {
    final query = database.select(database.transactions)
      ..where((tbl) => tbl.userId.equals(userId))
      ..orderBy([(tbl) => drift.OrderingTerm(expression: tbl.transactionDate, mode: drift.OrderingMode.desc)]);

    final transactions = await query.get();
    return transactions.map((entity) => TransactionModel.fromEntity(entity)).toList();
  }

  @override
  Future<List<TransactionModel>> getTransactionsByStatus(String status) async {
    final query = database.select(database.transactions)
      ..where((tbl) => tbl.status.equals(status))
      ..orderBy([(tbl) => drift.OrderingTerm(expression: tbl.createdAt, mode: drift.OrderingMode.desc)]);

    final transactions = await query.get();
    return transactions.map((entity) => TransactionModel.fromEntity(entity)).toList();
  }

  @override
  Future<List<TransactionModel>> getTransactionsByType(String type) async {
    final query = database.select(database.transactions)
      ..where((tbl) => tbl.type.equals(type))
      ..orderBy([(tbl) => drift.OrderingTerm(expression: tbl.transactionDate, mode: drift.OrderingMode.desc)]);

    final transactions = await query.get();
    return transactions.map((entity) => TransactionModel.fromEntity(entity)).toList();
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    final query = database.select(database.transactions)
      ..where((tbl) => tbl.transactionDate.isBetweenValues(start, end))
      ..orderBy([(tbl) => drift.OrderingTerm(expression: tbl.transactionDate, mode: drift.OrderingMode.desc)]);

    final transactions = await query.get();
    return transactions.map((entity) => TransactionModel.fromEntity(entity)).toList();
  }

  @override
  Future<List<TransactionModel>> searchTransactions(String query) async {
    final searchQuery = database.select(database.transactions)
      ..where((tbl) => tbl.description.contains(query))
      ..orderBy([(tbl) => drift.OrderingTerm(expression: tbl.transactionDate, mode: drift.OrderingMode.desc)]);

    final transactions = await searchQuery.get();
    return transactions.map((entity) => TransactionModel.fromEntity(entity)).toList();
  }

  @override
  Future<List<TransactionModel>> getPendingTransactions() async {
    return getTransactionsByStatus('pending');
  }

  @override
  Future<List<TransactionModel>> getPendingTransactionsByActivity(String activityId) async {
    final query = database.select(database.transactions)
      ..where((tbl) => tbl.activityId.equals(activityId) & tbl.status.equals('pending'))
      ..orderBy([(tbl) => drift.OrderingTerm(expression: tbl.createdAt, mode: drift.OrderingMode.desc)]);

    final transactions = await query.get();
    return transactions.map((entity) => TransactionModel.fromEntity(entity)).toList();
  }

  @override
  Future<void> approveTransaction(String id, String approvedBy, DateTime approvedAt) async {
    await (database.update(database.transactions)
          ..where((tbl) => tbl.id.equals(id)))
        .write(TransactionsCompanion(
          status: drift.Value('approved'),
          approvedBy: drift.Value(approvedBy),
          approvedAt: drift.Value(approvedAt),
          updatedAt: drift.Value(DateTime.now()),
        ));
  }

  @override
  Future<void> rejectTransaction(String id, String approvedBy, DateTime approvedAt, String reason) async {
    await (database.update(database.transactions)
          ..where((tbl) => tbl.id.equals(id)))
        .write(TransactionsCompanion(
          status: drift.Value('rejected'),
          approvedBy: drift.Value(approvedBy),
          approvedAt: drift.Value(approvedAt),
          rejectionReason: drift.Value(reason),
          updatedAt: drift.Value(DateTime.now()),
        ));
  }

  @override
  Future<void> completeTransaction(String id) async {
    await (database.update(database.transactions)
          ..where((tbl) => tbl.id.equals(id)))
        .write(TransactionsCompanion(
          status: drift.Value('completed'),
          updatedAt: drift.Value(DateTime.now()),
        ));
  }

  @override
  Future<void> cancelTransaction(String id, String reason) async {
    await (database.update(database.transactions)
          ..where((tbl) => tbl.id.equals(id)))
        .write(TransactionsCompanion(
          status: drift.Value('rejected'),
          rejectionReason: drift.Value(reason),
          updatedAt: drift.Value(DateTime.now()),
        ));
  }

  @override
  Future<double> getActivityBalance(String activityId) async {
    final query = database.select(database.transactions)
      ..where((tbl) => tbl.activityId.equals(activityId) & tbl.status.equals('completed'));

    final transactions = await query.get();

    return transactions.fold<double>(0.0, (balance, entity) {
      final amount = entity.amount;
      return entity.type == 'recette' ? balance + amount : balance - amount;
    });
  }

  @override
  Future<Map<String, double>> getAllActivitiesBalances() async {
    final query = database.select(database.transactions)
      ..where((tbl) => tbl.status.equals('completed'));

    final transactions = await query.get();
    final balances = <String, double>{};

    for (final entity in transactions) {
      final activityId = entity.activityId;
      final amount = entity.amount;
      final adjustment = entity.type == 'recette' ? amount : -amount;

      balances[activityId] = (balances[activityId] ?? 0.0) + adjustment;
    }

    return balances;
  }

  @override
  Future<Map<String, int>> getTransactionCountsByStatus() async {
    final allTransactions = await getAllTransactions();
    final counts = <String, int>{};

    for (final transaction in allTransactions) {
      counts[transaction.status] = (counts[transaction.status] ?? 0) + 1;
    }

    return counts;
  }

  @override
  Future<double> getTotalRevenue() async {
    final query = database.select(database.transactions)
      ..where((tbl) => tbl.type.equals('recette') & tbl.status.equals('completed'));

    final transactions = await query.get();
    return transactions.fold<double>(0.0, (total, entity) => total + entity.amount);
  }

  @override
  Future<double> getTotalExpenses() async {
    final query = database.select(database.transactions)
      ..where((tbl) => tbl.type.equals('depense') & tbl.status.equals('completed'));

    final transactions = await query.get();
    return transactions.fold<double>(0.0, (total, entity) => total + entity.amount);
  }

  @override
  Future<double> getTotalAmountToCollect() async {
    final query = database.select(database.transactions)
      ..where((tbl) => tbl.status.equals('completed'));

    final transactions = await query.get();

    return transactions.fold<double>(0.0, (total, entity) {
      final amount = entity.amount;
      return entity.type == 'recette' ? total : total + amount;
    });
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../shared/providers/repository_providers.dart';
import '../../domain/entities/transaction.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/usecases/get_transactions_usecase.dart';
import '../../domain/usecases/create_transaction_usecase.dart';
import '../../domain/usecases/update_transaction_usecase.dart';
import '../../domain/usecases/delete_transaction_usecase.dart';
import '../../domain/usecases/approve_transaction_usecase.dart';
import '../../domain/usecases/reject_transaction_usecase.dart';

class TransactionState {
  final List<Transaction> transactions;
  final List<Transaction> pendingTransactions;
  final bool isLoading;
  final String? error;

  TransactionState({
    required this.transactions,
    required this.pendingTransactions,
    required this.isLoading,
    this.error,
  });

  TransactionState copyWith({
    List<Transaction>? transactions,
    List<Transaction>? pendingTransactions,
    bool? isLoading,
    String? error,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      pendingTransactions: pendingTransactions ?? this.pendingTransactions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TransactionNotifier extends StateNotifier<TransactionState> {
  final GetTransactionsUseCase getTransactionsUseCase;
  final CreateTransactionUseCase createTransactionUseCase;
  final UpdateTransactionUseCase updateTransactionUseCase;
  final DeleteTransactionUseCase deleteTransactionUseCase;
  final ApproveTransactionUseCase approveTransactionUseCase;
  final RejectTransactionUseCase rejectTransactionUseCase;

  TransactionNotifier({
    required this.getTransactionsUseCase,
    required this.createTransactionUseCase,
    required this.updateTransactionUseCase,
    required this.deleteTransactionUseCase,
    required this.approveTransactionUseCase,
    required this.rejectTransactionUseCase,
  }) : super(TransactionState(
    transactions: [],
    pendingTransactions: [],
    isLoading: false,
  ));

  Future<void> loadTransactions() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getTransactionsUseCase.call();

    result.fold(
      (error) => state = state.copyWith(isLoading: false, error: error),
      (transactions) {
        final pending = transactions.where((t) => t.status == TransactionStatus.pending).toList();
        state = state.copyWith(
          transactions: transactions,
          pendingTransactions: pending,
          isLoading: false,
        );
      },
    );
  }

  Future<Either<String, Transaction>> createTransaction(Transaction transaction) async {
    final result = await createTransactionUseCase.call(transaction);

    if (result.isRight()) {
      await loadTransactions(); // Recharger la liste
    }

    return result;
  }

  Future<Either<String, Transaction>> updateTransaction(Transaction transaction) async {
    final result = await updateTransactionUseCase.call(transaction);

    if (result.isRight()) {
      await loadTransactions(); // Recharger la liste
    }

    return result;
  }

  Future<Either<String, void>> deleteTransaction(String transactionId) async {
    final result = await deleteTransactionUseCase.call(transactionId);

    if (result.isRight()) {
      await loadTransactions(); // Recharger la liste
    }

    return result;
  }

  Future<Either<String, Transaction>> approveTransaction(String transactionId, dynamic approver) async {
    final result = await approveTransactionUseCase.call(transactionId, approver);

    if (result.isRight()) {
      await loadTransactions(); // Recharger la liste
    }

    return result;
  }

  Future<Either<String, Transaction>> rejectTransaction(String transactionId, dynamic approver, String reason) async {
    final result = await rejectTransactionUseCase.call(transactionId, approver, reason);

    if (result.isRight()) {
      await loadTransactions(); // Recharger la liste
    }

    return result;
  }
}

// Providers
final transactionNotifierProvider = StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
  final getTransactionsUseCase = ref.watch(getTransactionsUseCaseProvider);
  final createTransactionUseCase = ref.watch(createTransactionUseCaseProvider);
  final updateTransactionUseCase = ref.watch(updateTransactionUseCaseProvider);
  final deleteTransactionUseCase = ref.watch(deleteTransactionUseCaseProvider);
  final approveTransactionUseCase = ref.watch(approveTransactionUseCaseProvider);
  final rejectTransactionUseCase = ref.watch(rejectTransactionUseCaseProvider);

  return TransactionNotifier(
    getTransactionsUseCase: getTransactionsUseCase,
    createTransactionUseCase: createTransactionUseCase,
    updateTransactionUseCase: updateTransactionUseCase,
    deleteTransactionUseCase: deleteTransactionUseCase,
    approveTransactionUseCase: approveTransactionUseCase,
    rejectTransactionUseCase: rejectTransactionUseCase,
  );
});
import 'package:fintrack_pro/core/utils/either.dart' as either;

import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionsUseCase {
  final TransactionRepository repository;

  GetTransactionsUseCase(this.repository);

  Future<either.Either<String, List<Transaction>>> call() async {
    final result = await repository.getAllTransactions();
    return result.fold(
      (failure) => either.Either.left('Erreur lors de la récupération: ${failure.toString()}'),
      (transactions) => either.Either.right(transactions),
    );
  }
}
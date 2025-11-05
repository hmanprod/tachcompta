import 'package:fpdart/fpdart.dart';

import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class CreateTransactionUseCase {
  final TransactionRepository repository;

  CreateTransactionUseCase(this.repository);

  Future<Either<String, Transaction>> call(Transaction transaction) async {
    if (transaction.amount <= 0) {
      return Left('Le montant doit être positif');
    }

    if (transaction.description.trim().isEmpty) {
      return Left('La description est requise');
    }

    final result = await repository.createTransaction(transaction);
    return result.fold(
      (failure) => Left('Erreur lors de la création: ${failure.toString()}'),
      (transaction) => Right(transaction),
    );
  }
}
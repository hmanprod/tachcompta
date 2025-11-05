import 'package:fpdart/fpdart.dart';

import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class UpdateTransactionUseCase {
  final TransactionRepository repository;

  UpdateTransactionUseCase(this.repository);

  Future<Either<String, Transaction>> call(Transaction transaction) async {
    // Validations
    if (transaction.amount <= 0) {
      return Left('Le montant doit être positif');
    }

    if (transaction.description.trim().isEmpty) {
      return Left('La description est requise');
    }

    // Vérifier que la transaction existe
    final existingTransaction = await repository.getTransactionById(transaction.id);
    final existing = existingTransaction.fold(
      (failure) => null,
      (transaction) => transaction,
    );
    if (existing == null) {
      return Left('Transaction non trouvée');
    }

    // Seuls les initiateurs ou les administrateurs peuvent modifier
    // Cette logique sera gérée dans la couche présentation avec les providers

    // Créer la transaction mise à jour avec les nouvelles valeurs
    final updatedTransaction = transaction.copyWith(
      updatedAt: DateTime.now(),
    );

    final result = await repository.updateTransaction(updatedTransaction);
    return result.fold(
      (failure) => Left('Erreur lors de la mise à jour: ${failure.toString()}'),
      (transaction) => Right(transaction),
    );
  }
}
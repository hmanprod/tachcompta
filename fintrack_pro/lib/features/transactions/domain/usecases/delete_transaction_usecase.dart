import 'package:fpdart/fpdart.dart';

import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class DeleteTransactionUseCase {
  final TransactionRepository repository;

  DeleteTransactionUseCase(this.repository);

  Future<Either<String, void>> call(String transactionId) async {
    if (transactionId.isEmpty) {
      return Left('ID de transaction requis');
    }

    // Vérifier que la transaction existe
    final existingTransaction = await repository.getTransactionById(transactionId);
    final existing = existingTransaction.fold(
      (failure) => null,
      (transaction) => transaction,
    );
    if (existing == null) {
      return Left('Transaction non trouvée');
    }

    // Vérifier que la transaction n'est pas approuvée ou terminée
    if (existing.status == TransactionStatus.approved || existing.status == TransactionStatus.completed) {
      return Left('Impossible de supprimer une transaction approuvée ou terminée');
    }

    // Seuls les initiateurs ou les administrateurs peuvent supprimer
    // Cette logique sera gérée dans la couche présentation avec les providers

    final result = await repository.deleteTransaction(transactionId);
    return result.fold(
      (failure) => Left('Erreur lors de la suppression: ${failure.toString()}'),
      (success) => Right(success),
    );
  }
}
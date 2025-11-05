import 'package:fpdart/fpdart.dart';

import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';
import '../../../auth/domain/entities/user.dart';

class RejectTransactionUseCase {
  final TransactionRepository repository;

  RejectTransactionUseCase(this.repository);

  Future<Either<String, Transaction>> call(String transactionId, User approver, String reason) async {
    // Vérification des permissions
    if (approver.role != UserRole.admin && approver.role != UserRole.agent) {
      return Left('Permission refusée: seuls les agents et administrateurs peuvent rejeter');
    }

    // Validation de la raison
    if (reason.trim().isEmpty) {
      return Left('Une raison de rejet est obligatoire');
    }

    final result = await repository.rejectTransaction(transactionId, approver.id, reason);
    return result.fold(
      (failure) => Left('Erreur lors du rejet: ${failure.toString()}'),
      (transaction) => Right(transaction),
    );
  }
}
import 'package:fpdart/fpdart.dart';

import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';
import '../../../auth/domain/entities/user.dart';

class ApproveTransactionUseCase {
  final TransactionRepository repository;

  ApproveTransactionUseCase(this.repository);

  Future<Either<String, Transaction>> call(String transactionId, User approver) async {
    // Vérification des permissions
    if (approver.role != UserRole.admin && approver.role != UserRole.agent) {
      return Left('Permission refusée: seuls les agents et administrateurs peuvent approuver');
    }

    final result = await repository.approveTransaction(transactionId, approver.id);
    return result.fold(
      (failure) => Left('Erreur lors de l\'approbation: ${failure.toString()}'),
      (transaction) => Right(transaction),
    );
  }
}
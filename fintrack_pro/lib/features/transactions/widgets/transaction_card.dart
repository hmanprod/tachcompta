import 'package:flutter/material.dart';

import '../domain/entities/transaction.dart';
import '../../../../styles/app_theme.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final bool showActions;

  const TransactionCard({
    Key? key,
    required this.transaction,
    this.onTap,
    this.onApprove,
    this.onReject,
    this.showActions = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildTypeIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.description,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(transaction.transactionDate),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildAmount(context),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatusBadge(),
                  const Spacer(),
                  if (showActions && transaction.status == TransactionStatus.pending)
                    _buildActionButtons(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: transaction.type == TransactionType.recette
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        transaction.type == TransactionType.recette
            ? Icons.arrow_upward
            : Icons.arrow_downward,
        color: transaction.type == TransactionType.recette
            ? Colors.green
            : Colors.red,
      ),
    );
  }

  Widget _buildAmount(BuildContext context) {
    return Text(
      '${transaction.amount.toStringAsFixed(2)} €',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: transaction.type == TransactionType.recette
            ? Colors.green
            : Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (transaction.status) {
      case TransactionStatus.pending:
        backgroundColor = Colors.yellow.withOpacity(0.1);
        textColor = Colors.orange;
        statusText = 'En attente';
        break;
      case TransactionStatus.approved:
        backgroundColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue;
        statusText = 'Approuvé';
        break;
      case TransactionStatus.completed:
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        statusText = 'Terminé';
        break;
      case TransactionStatus.rejected:
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        statusText = 'Rejeté';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        IconButton(
          onPressed: onReject,
          icon: const Icon(Icons.close, color: Colors.red),
          tooltip: 'Rejeter',
          style: IconButton.styleFrom(
            backgroundColor: Colors.red.withOpacity(0.1),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onApprove,
          icon: const Icon(Icons.check, color: Colors.green),
          tooltip: 'Approuver',
          style: IconButton.styleFrom(
            backgroundColor: Colors.green.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year}';
  }
}
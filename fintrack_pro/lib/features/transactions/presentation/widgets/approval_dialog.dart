import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/transaction.dart';
import '../providers/transaction_provider.dart';

extension BuildContextExtensions on BuildContext {
  T read<T>(ProviderListenable<T> provider) {
    return ProviderScope.containerOf(this, listen: false).read(provider);
  }
}

class ApprovalDialog extends StatefulWidget {
  final Transaction transaction;
  final User currentUser;

  const ApprovalDialog({
    Key? key,
    required this.transaction,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<ApprovalDialog> createState() => _ApprovalDialogState();
}

class _ApprovalDialogState extends State<ApprovalDialog> {
  final TextEditingController _reasonController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Approuver Transaction'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction: ${widget.transaction.description}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Montant: ${widget.transaction.amount.toStringAsFixed(2)} €',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(
              labelText: 'Commentaire (optionnel)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _approveTransaction,
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('Approuver'),
        ),
      ],
    );
  }

  Future<void> _approveTransaction() async {
    setState(() => _isLoading = true);

    try {
      final result = await context.read(transactionNotifierProvider.notifier)
          .approveTransaction(widget.transaction.id, widget.currentUser);

      if (mounted) {
        result.fold(
          (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur: $error')),
            );
          },
          (transaction) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Transaction approuvée')),
            );
            Navigator.of(context).pop();
          },
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class RejectionDialog extends StatefulWidget {
  final Transaction transaction;
  final User currentUser;

  const RejectionDialog({
    Key? key,
    required this.transaction,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<RejectionDialog> createState() => _RejectionDialogState();
}

class _RejectionDialogState extends State<RejectionDialog> {
  final TextEditingController _reasonController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rejeter Transaction'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction: ${widget.transaction.description}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Montant: ${widget.transaction.amount.toStringAsFixed(2)} €',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _reasonController,
            decoration: const InputDecoration(
              labelText: 'Motif du rejet (obligatoire)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Le motif du rejet est obligatoire';
              }
              return null;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _rejectTransaction,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('Rejeter'),
        ),
      ],
    );
  }

  Future<void> _rejectTransaction() async {
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le motif du rejet est obligatoire')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await context.read(transactionNotifierProvider.notifier)
          .rejectTransaction(widget.transaction.id, widget.currentUser, _reasonController.text.trim());

      if (mounted) {
        result.fold(
          (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur: $error')),
            );
          },
          (transaction) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Transaction rejetée')),
            );
            Navigator.of(context).pop();
          },
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
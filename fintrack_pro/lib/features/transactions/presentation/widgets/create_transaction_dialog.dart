import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/widgets/buttons/fintrack_button.dart';
import '../../domain/entities/transaction.dart';

class CreateTransactionDialog extends ConsumerStatefulWidget {
  const CreateTransactionDialog({super.key});

  @override
  ConsumerState<CreateTransactionDialog> createState() => _CreateTransactionDialogState();
}

class _CreateTransactionDialogState extends ConsumerState<CreateTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  TransactionType _selectedType = TransactionType.recette;
  String? _selectedActivityId;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Nouvelle Transaction',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type de transaction
                  Text(
                    'Type de transaction',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _TransactionTypeSelector(
                    selectedType: _selectedType,
                    onTypeChanged: (type) {
                      setState(() {
                        _selectedType = type;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Montant
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Montant (€)',
                      hintText: '0.00',
                      prefixIcon: Icon(Icons.euro),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Le montant est requis';
                      }
                      final amount = double.tryParse(value!);
                      if (amount == null || amount <= 0) {
                        return 'Le montant doit être positif';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Description de la transaction',
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'La description est requise';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Activité (TODO: Remplacer par dropdown réel)
                  DropdownButtonFormField<String>(
                    value: _selectedActivityId,
                    decoration: const InputDecoration(
                      labelText: 'Activité liée',
                      prefixIcon: Icon(Icons.business),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'activity_1',
                        child: Text('Magasin Central'),
                      ),
                      DropdownMenuItem(
                        value: 'activity_2',
                        child: Text('Service de Transport'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedActivityId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Veuillez sélectionner une activité';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                  child: Text(
                    'Annuler',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FinTrackButton(
                  label: 'Créer',
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _createTransaction,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text);
      final description = _descriptionController.text;

      final transaction = Transaction(
        id: const Uuid().v4(),
        activityId: _selectedActivityId!,
        userId: 'current_user_id', // TODO: Récupérer l'utilisateur actuel
        type: _selectedType,
        amount: amount,
        status: TransactionStatus.pending,
        description: description,
        transactionDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // TODO: Appeler le provider pour créer la transaction
      // final result = await ref.read(transactionNotifierProvider.notifier).createTransaction(transaction);

      // Simulation de succès pour l'instant
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction créée avec succès')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class _TransactionTypeSelector extends StatelessWidget {
  final TransactionType selectedType;
  final Function(TransactionType) onTypeChanged;

  const _TransactionTypeSelector({
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TypeButton(
            type: TransactionType.recette,
            label: 'Recette',
            icon: Icons.arrow_upward,
            isSelected: selectedType == TransactionType.recette,
            onTap: () => onTypeChanged(TransactionType.recette),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _TypeButton(
            type: TransactionType.depense,
            label: 'Dépense',
            icon: Icons.arrow_downward,
            isSelected: selectedType == TransactionType.depense,
            onTap: () => onTypeChanged(TransactionType.depense),
          ),
        ),
      ],
    );
  }
}

class _TypeButton extends StatelessWidget {
  final TransactionType type;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.type,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = type == TransactionType.recette
        ? const Color(0xFF10B981) // green
        : const Color(0xFFEF4444); // red

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? color : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? color : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
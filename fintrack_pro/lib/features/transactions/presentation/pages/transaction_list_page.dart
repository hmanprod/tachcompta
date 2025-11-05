import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/navigation/header.dart';
import '../../../../shared/widgets/buttons/fintrack_button.dart';
import '../../domain/entities/transaction.dart';
import '../../../auth/domain/entities/user.dart';
import '../providers/transaction_provider.dart';
import '../widgets/create_transaction_dialog.dart';
import '../widgets/approval_dialog.dart';

class TransactionListPage extends ConsumerStatefulWidget {
  const TransactionListPage({super.key});

  @override
  ConsumerState<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends ConsumerState<TransactionListPage> {
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _error;
  String _selectedFilter = 'all'; // all, pending, approved, completed

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Charger les transactions via Riverpod
      final transactionNotifier = ref.read(transactionNotifierProvider.notifier);
      await transactionNotifier.loadTransactions();

      // Mettre à jour l'état local depuis le provider
      final updatedState = ref.read(transactionNotifierProvider);
      _transactions = updatedState.transactions;

      // Appliquer le filtre actuel
      _filterTransactions();
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterTransactions() {
    List<Transaction> filtered = _transactions;

    switch (_selectedFilter) {
      case 'pending':
        filtered = _transactions.where((t) => t.status == TransactionStatus.pending).toList();
        break;
      case 'approved':
        filtered = _transactions.where((t) => t.status == TransactionStatus.approved).toList();
        break;
      case 'completed':
        filtered = _transactions.where((t) => t.status == TransactionStatus.completed).toList();
        break;
      case 'rejected':
        filtered = _transactions.where((t) => t.status == TransactionStatus.rejected).toList();
        break;
    }

    setState(() {
      _transactions = filtered;
    });
  }

  void _showCreateTransactionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateTransactionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête avec titre et bouton d'ajout
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transactions',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Journal des transactions financières',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      FinTrackButton(
                        label: 'Nouvelle Transaction',
                        icon: Icons.add,
                        onPressed: () {
                          // Ouvrir dialog/modal de création de transaction
                          _showCreateTransactionDialog(context);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Filtres
                  _FilterChips(
                    selectedFilter: _selectedFilter,
                    onFilterChanged: (filter) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                      _loadTransactions(); // Recharger avec le nouveau filtre
                    },
                  ),

                  const SizedBox(height: 32),

                  // État de chargement
                  if (_isLoading) ...[
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ]
                  // État d'erreur
                  else if (_error != null) ...[
                    _ErrorWidget(
                      error: _error!,
                      onRetry: _loadTransactions,
                    ),
                  ]
                  // Liste des transactions
                  else if (_transactions.isEmpty) ...[
                    const _EmptyTransactionsWidget(),
                  ] else ...[
                    _TransactionsList(transactions: _transactions),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const _FilterChips({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        _FilterChip(
          label: 'Toutes',
          value: 'all',
          selected: selectedFilter == 'all',
          onSelected: onFilterChanged,
        ),
        _FilterChip(
          label: 'En attente',
          value: 'pending',
          selected: selectedFilter == 'pending',
          onSelected: onFilterChanged,
        ),
        _FilterChip(
          label: 'Approuvées',
          value: 'approved',
          selected: selectedFilter == 'approved',
          onSelected: onFilterChanged,
        ),
        _FilterChip(
          label: 'Terminées',
          value: 'completed',
          selected: selectedFilter == 'completed',
          onSelected: onFilterChanged,
        ),
        _FilterChip(
          label: 'Rejetées',
          value: 'rejected',
          selected: selectedFilter == 'rejected',
          onSelected: onFilterChanged,
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final Function(String) onSelected;

  const _FilterChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (selected) {
        if (selected) {
          onSelected(value);
        }
      },
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorWidget({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(32),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Erreur de chargement',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 24),
              FinTrackButton(
                label: 'Réessayer',
                onPressed: onRetry,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyTransactionsWidget extends StatelessWidget {
  const _EmptyTransactionsWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(48),
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 24),
              Text(
                'Aucune transaction',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Les transactions apparaîtront ici une fois créées.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 32),
              FinTrackButton(
                label: 'Créer une transaction',
                icon: Icons.add,
                onPressed: () {
                  // TODO: Ouvrir dialog/modal de création de transaction
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fonctionnalité à implémenter')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionsList extends ConsumerStatefulWidget {
  final List<Transaction> transactions;

  const _TransactionsList({required this.transactions});

  @override
  ConsumerState<_TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends ConsumerState<_TransactionsList> {
  void _showApprovalDialog(Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => ApprovalDialog(
        transaction: transaction,
        currentUser: User(
          id: 'current-user-id', // TODO: Get from auth provider
          firstName: 'Utilisateur',
          lastName: 'Test',
          email: 'test@example.com',
          role: UserRole.admin, // TODO: Get from auth provider
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ),
    );
  }

  void _showRejectionDialog(Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => RejectionDialog(
        transaction: transaction,
        currentUser: User(
          id: 'current-user-id', // TODO: Get from auth provider
          firstName: 'Utilisateur',
          lastName: 'Test',
          email: 'test@example.com',
          role: UserRole.admin, // TODO: Get from auth provider
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.transactions.length,
      itemBuilder: (context, index) {
        final transaction = widget.transactions[index];
        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              // TODO: Ouvrir page de détail de la transaction
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Détail de la transaction ${transaction.id}')),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ligne principale avec montant et statut
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _getTransactionColor(transaction.type),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getTransactionIcon(transaction.type),
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${transaction.amount.toStringAsFixed(2)} €',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: _getAmountColor(transaction.type),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              transaction.description,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _StatusBadge(status: transaction.status),
                          const SizedBox(height: 8),
                          Text(
                            _formatDate(transaction.transactionDate),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          // Boutons d'action pour les transactions en attente
                          if (transaction.status == TransactionStatus.pending) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => _showRejectionDialog(transaction),
                                  icon: const Icon(Icons.close, size: 18),
                                  color: Colors.red,
                                  tooltip: 'Rejeter',
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.red.withValues(alpha: 0.1),
                                    padding: const EdgeInsets.all(8),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () => _showApprovalDialog(transaction),
                                  icon: const Icon(Icons.check, size: 18),
                                  color: Colors.green,
                                  tooltip: 'Approuver',
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.green.withValues(alpha: 0.1),
                                    padding: const EdgeInsets.all(8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),

                  // Informations supplémentaires si rejetée
                  if (transaction.status == TransactionStatus.rejected && transaction.rejectionReason != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Motif du rejet: ${transaction.rejectionReason}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.recette:
        return const Color(0xFF10B981); // green
      case TransactionType.depense:
        return const Color(0xFFEF4444); // red
    }
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.recette:
        return Icons.arrow_upward;
      case TransactionType.depense:
        return Icons.arrow_downward;
    }
  }

  Color _getAmountColor(TransactionType type) {
    switch (type) {
      case TransactionType.recette:
        return const Color(0xFF10B981); // green
      case TransactionType.depense:
        return const Color(0xFFEF4444); // red
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  final TransactionStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStatusColor(),
          width: 1,
        ),
      ),
      child: Text(
        _getStatusText(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: _getStatusColor(),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case TransactionStatus.pending:
        return const Color(0xFFF59E0B); // yellow
      case TransactionStatus.approved:
        return const Color(0xFF10B981); // green
      case TransactionStatus.rejected:
        return const Color(0xFFEF4444); // red
      case TransactionStatus.completed:
        return const Color(0xFF3B82F6); // blue
    }
  }

  String _getStatusText() {
    switch (status) {
      case TransactionStatus.pending:
        return 'En attente';
      case TransactionStatus.approved:
        return 'Approuvée';
      case TransactionStatus.rejected:
        return 'Rejetée';
      case TransactionStatus.completed:
        return 'Terminée';
    }
  }
}
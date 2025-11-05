import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/navigation/header.dart';
import '../../../../shared/widgets/buttons/fintrack_button.dart';
import '../../../../../features/auth/domain/entities/user.dart';

class UserManagementPage extends ConsumerStatefulWidget {
  const UserManagementPage({super.key});

  @override
  ConsumerState<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends ConsumerState<UserManagementPage> {
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;
  String _selectedRoleFilter = 'all'; // all, admin, agent, user

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // TODO: Injecter le provider admin user via Riverpod
      // final adminUserState = ref.read(adminUserNotifierProvider);
      // _users = adminUserState.users;

      // Simulation de données pour l'instant
      await Future.delayed(const Duration(seconds: 1));
      _users = [
        User(
          id: '1',
          email: 'admin@fintrack.com',
          firstName: 'Jean',
          lastName: 'Dupont',
          role: UserRole.admin,
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 365)),
          updatedAt: DateTime.now(),
        ),
        User(
          id: '2',
          email: 'agent.smith@fintrack.com',
          firstName: 'Marie',
          lastName: 'Martin',
          role: UserRole.agent,
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 180)),
          updatedAt: DateTime.now(),
        ),
        User(
          id: '3',
          email: 'user.john@fintrack.com',
          firstName: 'Pierre',
          lastName: 'Dubois',
          role: UserRole.user,
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(days: 90)),
          updatedAt: DateTime.now(),
        ),
        User(
          id: '4',
          email: 'inactive.user@fintrack.com',
          firstName: 'Sophie',
          lastName: 'Leroy',
          role: UserRole.user,
          isActive: false,
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
          updatedAt: DateTime.now(),
        ),
      ];

      // Appliquer le filtre actuel
      _filterUsers();
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterUsers() {
    List<User> filtered = _users;

    switch (_selectedRoleFilter) {
      case 'admin':
        filtered = _users.where((u) => u.role == UserRole.admin).toList();
        break;
      case 'agent':
        filtered = _users.where((u) => u.role == UserRole.agent).toList();
        break;
      case 'user':
        filtered = _users.where((u) => u.role == UserRole.user).toList();
        break;
    }

    setState(() {
      _users = filtered;
    });
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
                            'Utilisateurs',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gestion des comptes utilisateurs',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                      FinTrackButton(
                        label: 'Nouvel Utilisateur',
                        icon: Icons.person_add,
                        onPressed: () {
                          // TODO: Ouvrir dialog/modal de création d'utilisateur
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Fonctionnalité à implémenter')),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Filtres par rôle
                  _RoleFilterChips(
                    selectedFilter: _selectedRoleFilter,
                    onFilterChanged: (filter) {
                      setState(() {
                        _selectedRoleFilter = filter;
                      });
                      _loadUsers(); // Recharger avec le nouveau filtre
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
                      onRetry: _loadUsers,
                    ),
                  ]
                  // Liste des utilisateurs
                  else if (_users.isEmpty) ...[
                    const _EmptyUsersWidget(),
                  ] else ...[
                    _UsersList(users: _users),
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

class _RoleFilterChips extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const _RoleFilterChips({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        _FilterChip(
          label: 'Tous',
          value: 'all',
          selected: selectedFilter == 'all',
          onSelected: onFilterChanged,
        ),
        _FilterChip(
          label: 'Administrateurs',
          value: 'admin',
          selected: selectedFilter == 'admin',
          onSelected: onFilterChanged,
        ),
        _FilterChip(
          label: 'Agents SI',
          value: 'agent',
          selected: selectedFilter == 'agent',
          onSelected: onFilterChanged,
        ),
        _FilterChip(
          label: 'Utilisateurs',
          value: 'user',
          selected: selectedFilter == 'user',
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
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
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

class _EmptyUsersWidget extends StatelessWidget {
  const _EmptyUsersWidget();

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
                Icons.people_outline,
                size: 80,
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
              ),
              const SizedBox(height: 24),
              Text(
                'Aucun utilisateur',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Commencez par créer le premier compte utilisateur.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 32),
              FinTrackButton(
                label: 'Créer un utilisateur',
                icon: Icons.person_add,
                onPressed: () {
                  // TODO: Ouvrir dialog/modal de création d'utilisateur
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

class _UsersList extends StatelessWidget {
  final List<User> users;

  const _UsersList({required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              // TODO: Ouvrir page de détail de l'utilisateur
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Détail de ${user.firstName} ${user.lastName}')),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Avatar utilisateur
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getRoleColor(user.role),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        '${user.firstName[0]}${user.lastName[0]}'.toUpperCase(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Informations utilisateur
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.firstName} ${user.lastName}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _RoleBadge(role: user.role),
                            const SizedBox(width: 12),
                            _StatusBadge(isActive: user.isActive),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Actions et date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Boutons d'action
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              // TODO: Ouvrir dialog d'édition
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Édition à implémenter')),
                              );
                            },
                            icon: const Icon(Icons.edit_outlined),
                            tooltip: 'Modifier',
                          ),
                          IconButton(
                            onPressed: () {
                              // TODO: Ouvrir dialog de suppression
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Suppression à implémenter')),
                              );
                            },
                            icon: const Icon(Icons.delete_outline),
                            tooltip: 'Supprimer',
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ],
                      ),

                      // Date de création
                      Text(
                        'Créé le ${_formatDate(user.createdAt)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return const Color(0xFFEF4444); // red
      case UserRole.agent:
        return const Color(0xFFF59E0B); // yellow
      case UserRole.user:
        return const Color(0xFF3B82F6); // blue
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _RoleBadge extends StatelessWidget {
  final UserRole role;

  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getRoleColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getRoleColor(),
          width: 1,
        ),
      ),
      child: Text(
        _getRoleText(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: _getRoleColor(),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getRoleColor() {
    switch (role) {
      case UserRole.admin:
        return const Color(0xFFEF4444); // red
      case UserRole.agent:
        return const Color(0xFFF59E0B); // yellow
      case UserRole.user:
        return const Color(0xFF3B82F6); // blue
    }
  }

  String _getRoleText() {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.agent:
        return 'Agent SI';
      case UserRole.user:
        return 'Utilisateur';
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isActive;

  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            size: 12,
            color: _getStatusColor(),
          ),
          const SizedBox(width: 4),
          Text(
            isActive ? 'Actif' : 'Inactif',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _getStatusColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    return isActive ? const Color(0xFF10B981) : const Color(0xFF6B7280); // green or gray
  }
}
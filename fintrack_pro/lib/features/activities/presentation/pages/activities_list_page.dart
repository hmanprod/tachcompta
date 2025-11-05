import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/navigation/header.dart';
import '../../../../shared/widgets/buttons/fintrack_button.dart';
import '../../domain/entities/activity.dart';
import '../providers/activity_provider.dart';
import '../widgets/create_activity_dialog.dart';

class ActivitiesListPage extends ConsumerStatefulWidget {
  const ActivitiesListPage({super.key});

  @override
  ConsumerState<ActivitiesListPage> createState() => _ActivitiesListPageState();
}

class _ActivitiesListPageState extends ConsumerState<ActivitiesListPage> {
  @override
  void initState() {
    super.initState();
    // Charger les activités au démarrage
    Future.microtask(() {
      ref.read(activityNotifierProvider.notifier).loadActivities();
    });
  }

  void _showCreateActivityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateActivityDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activityState = ref.watch(activityNotifierProvider);

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
                            'Activités',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gestion des activités financières',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      FinTrackButton(
                        label: 'Nouvelle Activité',
                        icon: Icons.add,
                        onPressed: () {
                          _showCreateActivityDialog(context);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // État de chargement
                  if (activityState.isLoading) ...[
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ]
                  // État d'erreur
                  else if (activityState.error != null) ...[
                    _ErrorWidget(
                      error: activityState.error!,
                      onRetry: () => ref.read(activityNotifierProvider.notifier).loadActivities(),
                    ),
                  ]
                  // Liste des activités
                  else if (activityState.activities.isEmpty) ...[
                    const _EmptyActivitiesWidget(),
                  ] else ...[
                    _ActivitiesList(activities: activityState.activities),
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

class _EmptyActivitiesWidget extends StatelessWidget {
  const _EmptyActivitiesWidget();

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
                Icons.business_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 24),
              Text(
                'Aucune activité',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Commencez par créer votre première activité pour gérer vos finances.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 32),
              FinTrackButton(
                label: 'Créer une activité',
                icon: Icons.add,
                onPressed: () {
                  // TODO: Ouvrir dialog/modal de création d'activité
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

class _ActivitiesList extends StatelessWidget {
  final List<Activity> activities;

  const _ActivitiesList({required this.activities});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              // TODO: Ouvrir page de détail de l'activité
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Détail de ${activity.name}')),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ligne principale avec nom et statut
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _getActivityColor(activity.type),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getActivityIcon(activity.type),
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
                              activity.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              activity.description ?? 'Aucune description',
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
                          _StatusBadge(status: activity.status),
                          const SizedBox(height: 8),
                          Text(
                            'Créé le ${_formatDate(activity.createdAt)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
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

  Color _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.magasin:
        return const Color(0xFF3B82F6); // blue
      case ActivityType.transport:
        return const Color(0xFF10B981); // green
      case ActivityType.autre:
        return const Color(0xFF8B5CF6); // purple
    }
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.magasin:
        return Icons.store;
      case ActivityType.transport:
        return Icons.local_shipping;
      case ActivityType.autre:
        return Icons.business;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  final ActivityStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
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
      case ActivityStatus.active:
        return const Color(0xFF10B981); // green
      case ActivityStatus.closed:
        return const Color(0xFFEF4444); // red
      case ActivityStatus.suspended:
        return const Color(0xFFF59E0B); // yellow
    }
  }

  String _getStatusText() {
    switch (status) {
      case ActivityStatus.active:
        return 'Actif';
      case ActivityStatus.closed:
        return 'Fermé';
      case ActivityStatus.suspended:
        return 'Suspendu';
    }
  }
}
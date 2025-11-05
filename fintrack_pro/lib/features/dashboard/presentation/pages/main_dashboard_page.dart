import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/navigation/header.dart';
import '../../../dashboard/data/models/kpi_model.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/kpi_card_widget.dart';
import '../widgets/dashboard_chart_widget.dart';

class MainDashboardPage extends ConsumerStatefulWidget {
  const MainDashboardPage({super.key});

  @override
  ConsumerState<MainDashboardPage> createState() => _MainDashboardPageState();
}

class _MainDashboardPageState extends ConsumerState<MainDashboardPage> {
  @override
  void initState() {
    super.initState();
    // Charger les données du dashboard au démarrage
    Future.microtask(() {
      ref.read(dashboardNotifierProvider.notifier).loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardNotifierProvider);

    return Scaffold(
      body: Column(
        children: [
          // Header de navigation
          const Header(),

          // Contenu principal du dashboard
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre de la page
                  Text(
                    'Dashboard Principal',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Sous-titre
                  Text(
                    'Vue d\'ensemble de vos finances',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Section des KPIs
                  if (dashboardState.isLoading) ...[
                    const _LoadingKPIsGrid(),
                  ] else if (dashboardState.error != null) ...[
                    _ErrorKPIsWidget(error: dashboardState.error!),
                  ] else if (dashboardState.globalKPIs != null) ...[
                    _KPIsGrid(kpis: dashboardState.globalKPIs!),
                  ] else ...[
                    const _EmptyKPIsGrid(),
                  ],

                  const SizedBox(height: 32),

                  // Section des graphiques
                  if (dashboardState.chartData != null) ...[
                    DashboardChartWidget(chartData: dashboardState.chartData!),
                  ] else if (!dashboardState.isLoading) ...[
                    const _EmptyChartsWidget(),
                  ],

                  const SizedBox(height: 32),

                  // Section des activités récentes (si des données existent)
                  if (dashboardState.activitiesKPIs.isNotEmpty) ...[
                    _RecentActivitiesWidget(activitiesKPIs: dashboardState.activitiesKPIs),
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

class _LoadingKPIsGrid extends StatelessWidget {
  const _LoadingKPIsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        4,
        (index) => Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 48,
                  width: 48,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 36,
                  child: LinearProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorKPIsWidget extends StatelessWidget {
  final String error;

  const _ErrorKPIsWidget({required this.error});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
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
          ],
        ),
      ),
    );
  }
}

class _KPIsGrid extends StatelessWidget {
  final GlobalKPIsModel kpis;

  const _KPIsGrid({required this.kpis});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        KpiCardWidget(kpi: kpis.totalRecettes),
        KpiCardWidget(kpi: kpis.totalDepenses),
        KpiCardWidget(kpi: kpis.resteACollecter),
        KpiCardWidget(kpi: kpis.soldeGlobal),
      ],
    );
  }
}

class _EmptyKPIsGrid extends StatelessWidget {
  const _EmptyKPIsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        4,
        (index) => Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucune donnée disponible',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyChartsWidget extends StatelessWidget {
  const _EmptyChartsWidget();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.bar_chart,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Graphiques Financiers',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aucune donnée disponible pour les graphiques',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentActivitiesWidget extends StatelessWidget {
  final List<ActivityKPIsModel> activitiesKPIs;

  const _RecentActivitiesWidget({required this.activitiesKPIs});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activités Récentes',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activitiesKPIs.length > 5 ? 5 : activitiesKPIs.length,
              itemBuilder: (context, index) {
                final activityKPI = activitiesKPIs[index];
                return ListTile(
                  title: Text(activityKPI.activityName),
                  subtitle: Text(
                    'Reste disponible: ${activityKPI.resteDisponible.value.toStringAsFixed(2)} €',
                  ),
                  trailing: Icon(
                    activityKPI.resteDisponible.value >= 0
                        ? Icons.trending_up
                        : Icons.trending_down,
                    color: activityKPI.resteDisponible.value >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
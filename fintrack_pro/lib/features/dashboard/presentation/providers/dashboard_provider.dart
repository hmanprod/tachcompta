import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/database_provider.dart';
import '../../../../features/transactions/data/repositories/transaction_repository_impl.dart';
import '../../../../features/transactions/data/datasources/transaction_local_datasource.dart';
import '../../../../features/activities/data/repositories/activity_repository_impl.dart';
import '../../../../features/activities/data/datasources/activity_local_datasource.dart';
import '../../data/models/kpi_model.dart';
import '../../data/models/chart_data_model.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../../../core/database/database.dart';
import '../../domain/usecases/get_global_kpis_usecase.dart';

// État du dashboard
class DashboardState {
  final GlobalKPIsModel? globalKPIs;
  final List<ActivityKPIsModel> activitiesKPIs;
  final ChartDataModel? chartData;
  final bool isLoading;
  final String? error;

  const DashboardState({
    this.globalKPIs,
    this.activitiesKPIs = const [],
    this.chartData,
    this.isLoading = false,
    this.error,
  });

  DashboardState copyWith({
    GlobalKPIsModel? globalKPIs,
    List<ActivityKPIsModel>? activitiesKPIs,
    ChartDataModel? chartData,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      globalKPIs: globalKPIs ?? this.globalKPIs,
      activitiesKPIs: activitiesKPIs ?? this.activitiesKPIs,
      chartData: chartData ?? this.chartData,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Notifier pour le dashboard
class DashboardNotifier extends StateNotifier<DashboardState> {
  final GetGlobalKPIsUseCase _getGlobalKPIsUseCase;
  final DashboardRepository _dashboardRepository;

  DashboardNotifier(this._getGlobalKPIsUseCase, this._dashboardRepository) : super(const DashboardState());

  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Charger les KPIs globaux via le use case
      final globalKPIs = await _getGlobalKPIsUseCase.execute();

      // Charger les KPIs des activités
      final activitiesKPIs = await _dashboardRepository.getAllActivitiesKPIs(null, null);

      // Charger les données des graphiques
      final chartData = await _dashboardRepository.getChartData(null, null);

      state = state.copyWith(
        globalKPIs: globalKPIs,
        activitiesKPIs: activitiesKPIs,
        chartData: chartData,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refreshData() async {
    await loadDashboardData();
  }

  /// Méthode pour rafraîchir les KPIs après une modification de transaction
  Future<void> refreshKPIsAfterTransactionChange() async {
    try {
      final globalKPIs = await _getGlobalKPIsUseCase.execute();
      state = state.copyWith(globalKPIs: globalKPIs);
    } catch (e) {
      // En cas d'erreur, garder l'état actuel
    }
  }
}

// Provider pour le repository dashboard
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  // TODO: Créer les providers pour transaction et activity repositories
  // Pour le MVP, on utilise directement les implémentations
  // final transactionRepository = ref.watch(transactionRepositoryProvider);
  // final activityRepository = ref.watch(activityRepositoryProvider);
  // return DashboardRepositoryImpl(
  //   transactionRepository,
  //   activityRepository,
  // );
  throw UnimplementedError('Dashboard repository provider needs to be implemented');
});

// Provider pour le use case des KPIs
final getGlobalKPIsUseCaseProvider = Provider<GetGlobalKPIsUseCase>((ref) {
  // TEMP: Créer directement l'implémentation pour le MVP
  final database = ref.watch(appDatabaseProvider);
  final transactionRepository = TransactionRepositoryImpl(TransactionLocalDataSourceImpl(database));
  final activityRepository = ActivityRepositoryImpl(ActivityLocalDataSourceImpl(database));
  final repository = DashboardRepositoryImpl(transactionRepository, activityRepository);
  return GetGlobalKPIsUseCase(repository);
});

// Provider pour le notifier dashboard
final dashboardNotifierProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  // TEMP: Créer directement l'implémentation pour le MVP
  // TODO: Utiliser le provider une fois que les repository providers sont implémentés
  final getGlobalKPIsUseCase = ref.watch(getGlobalKPIsUseCaseProvider);
  final database = ref.watch(appDatabaseProvider);
  final transactionRepository = TransactionRepositoryImpl(TransactionLocalDataSourceImpl(database));
  final activityRepository = ActivityRepositoryImpl(ActivityLocalDataSourceImpl(database));
  final repository = DashboardRepositoryImpl(transactionRepository, activityRepository);
  return DashboardNotifier(getGlobalKPIsUseCase, repository);
});

// Provider pour les KPIs globaux
final globalKPIsProvider = Provider<GlobalKPIsModel?>((ref) {
  return ref.watch(dashboardNotifierProvider).globalKPIs;
});

// Provider pour les KPIs des activités
final activitiesKPIsProvider = Provider<List<ActivityKPIsModel>>((ref) {
  return ref.watch(dashboardNotifierProvider).activitiesKPIs;
});

// Provider pour les données des graphiques
final chartDataProvider = Provider<ChartDataModel?>((ref) {
  return ref.watch(dashboardNotifierProvider).chartData;
});
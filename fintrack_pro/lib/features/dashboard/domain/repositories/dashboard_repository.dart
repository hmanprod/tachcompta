import '../../data/models/kpi_model.dart';
import '../../data/models/chart_data_model.dart';

/// Interface pour le repository des données du dashboard
abstract class DashboardRepository {
  /// Récupère les KPIs globaux pour une période donnée
  Future<GlobalKPIsModel> getGlobalKPIs(DateTime? startDate, DateTime? endDate);

  /// Récupère les KPIs pour une activité spécifique
  Future<ActivityKPIsModel> getActivityKPIs(String activityId, DateTime? startDate, DateTime? endDate);

  /// Récupère les données pour les graphiques
  Future<ChartDataModel> getChartData(DateTime? startDate, DateTime? endDate);

  /// Récupère les données pour les graphiques d'une activité
  Future<ChartDataModel> getActivityChartData(String activityId, DateTime? startDate, DateTime? endDate);

  /// Récupère la liste des activités avec leurs KPIs
  Future<List<ActivityKPIsModel>> getAllActivitiesKPIs(DateTime? startDate, DateTime? endDate);
}
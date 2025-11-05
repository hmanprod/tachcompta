import '../../data/models/kpi_model.dart';
import '../../data/repositories/dashboard_repository.dart';

/// Use case pour récupérer les KPIs globaux
class GetGlobalKPIsUseCase {
  final DashboardRepository _dashboardRepository;

  GetGlobalKPIsUseCase(this._dashboardRepository);

  /// Exécute le use case pour récupérer les KPIs globaux
  /// [startDate] et [endDate] sont optionnels pour filtrer par période
  Future<GlobalKPIsModel> execute({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      return await _dashboardRepository.getGlobalKPIs(startDate, endDate);
    } catch (e) {
      // En cas d'erreur, retourner des KPIs vides avec gestion d'erreur
      return GlobalKPIsModel.empty();
    }
  }
}
// TODO: Create domain entities first
// import '../../domain/entities/kpi.dart';
// import '../../domain/entities/dashboard_data.dart';

import 'package:flutter/material.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../activities/domain/entities/activity.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../../activities/domain/repositories/activity_repository.dart';
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

/// Implémentation du repository dashboard
class DashboardRepositoryImpl implements DashboardRepository {
  final TransactionRepository _transactionRepository;
  final ActivityRepository _activityRepository;

  DashboardRepositoryImpl(
    this._transactionRepository,
    this._activityRepository,
  );

  @override
  Future<GlobalKPIsModel> getGlobalKPIs(DateTime? startDate, DateTime? endDate) async {
    final transactionsResult = await _transactionRepository.getAllTransactions();

    if (transactionsResult.isLeft()) {
      // Return empty KPIs on error
      return GlobalKPIsModel.empty();
    }

    final transactions = transactionsResult.getOrElse((_) => []);

    // Filtrer par période si nécessaire
    final filteredTransactions = _filterTransactionsByPeriod(transactions, startDate, endDate);

    // Calculer les KPIs globaux avec les nouvelles méthodes optimisées
    final totalRecettes = _calculateTotalRecettes(filteredTransactions);
    final totalDepenses = _calculateTotalDepenses(filteredTransactions);
    final resteACollecter = _calculateResteACollecter(filteredTransactions);
    final soldeGlobal = totalRecettes - totalDepenses;

    return GlobalKPIsModel(
      totalRecettes: KPIModel(
        id: 'total_recettes',
        title: 'Total Recettes',
        value: totalRecettes,
        unit: '€',
        iconName: 'trending_up',
        type: KPIType.recettes,
        trend: KPITrend.up,
      ),
      totalDepenses: KPIModel(
        id: 'total_depenses',
        title: 'Total Dépenses',
        value: totalDepenses,
        unit: '€',
        iconName: 'trending_down',
        type: KPIType.depenses,
        trend: KPITrend.down,
      ),
      resteACollecter: KPIModel(
        id: 'reste_a_collecter',
        title: 'Restes à Collecter',
        value: resteACollecter,
        unit: '€',
        iconName: 'clock',
        type: KPIType.resteACollecter,
        trend: resteACollecter > 0 ? KPITrend.up : KPITrend.neutral,
      ),
      soldeGlobal: KPIModel(
        id: 'solde_global',
        title: 'Solde Global',
        value: soldeGlobal,
        unit: '€',
        iconName: 'wallet',
        type: KPIType.soldeGlobal,
        trend: soldeGlobal >= 0 ? KPITrend.up : KPITrend.down,
      ),
    );
  }

  @override
  Future<ActivityKPIsModel> getActivityKPIs(String activityId, DateTime? startDate, DateTime? endDate) async {
    final transactionsResult = await _transactionRepository.getTransactionsByActivity(activityId);

    if (transactionsResult.isLeft()) {
      // Return empty KPIs on error
      return ActivityKPIsModel.empty(activityId, 'Activity $activityId');
    }

    final transactions = transactionsResult.getOrElse((_) => []);

    // Get activity name
    final activityResult = await _activityRepository.getActivityById(activityId);
    final activityName = activityResult.fold(
      (failure) => 'Activity $activityId',
      (activity) => activity?.name ?? 'Activity $activityId',
    );

    // Filtrer par période si nécessaire
    final filteredTransactions = _filterTransactionsByPeriod(transactions, startDate, endDate);

    // Calculer les KPIs pour l'activité
    final recettesEnAttente = _calculateRecettesEnAttente(filteredTransactions);
    final depensesEnAttente = _calculateDepensesEnAttente(filteredTransactions);
    final recettesAcquises = _calculateRecettesAcquises(filteredTransactions);
    final depensesAcquises = _calculateDepensesAcquises(filteredTransactions);
    final resteDisponible = recettesAcquises - depensesAcquises;

    return ActivityKPIsModel(
      activityId: activityId,
      activityName: activityName,
      recettesEnAttente: KPIModel(
        id: 'recettes_en_attente_$activityId',
        title: 'Recettes en Attente',
        value: recettesEnAttente,
        unit: '€',
        iconName: 'pending',
        type: KPIType.recettesEnAttente,
        trend: KPITrend.neutral,
      ),
      depensesEnAttente: KPIModel(
        id: 'depenses_en_attente_$activityId',
        title: 'Dépenses en Attente',
        value: depensesEnAttente,
        unit: '€',
        iconName: 'pending',
        type: KPIType.depensesEnAttente,
        trend: KPITrend.neutral,
      ),
      recettesAcquises: KPIModel(
        id: 'recettes_acquises_$activityId',
        title: 'Recettes Acquises',
        value: recettesAcquises,
        unit: '€',
        iconName: 'check_circle',
        type: KPIType.recettesAcquises,
        trend: KPITrend.up,
      ),
      depensesAcquises: KPIModel(
        id: 'depenses_acquises_$activityId',
        title: 'Dépenses Acquises',
        value: depensesAcquises,
        unit: '€',
        iconName: 'check_circle',
        type: KPIType.depensesAcquises,
        trend: KPITrend.down,
      ),
      resteDisponible: KPIModel(
        id: 'reste_disponible_$activityId',
        title: 'Reste Disponible',
        value: resteDisponible,
        unit: '€',
        iconName: 'account_balance_wallet',
        type: KPIType.resteDisponible,
        trend: resteDisponible >= 0 ? KPITrend.up : KPITrend.down,
      ),
    );
  }

  @override
  Future<ChartDataModel> getChartData(DateTime? startDate, DateTime? endDate) async {
    final transactionsResult = await _transactionRepository.getAllTransactions();

    if (transactionsResult.isLeft()) {
      // Return empty chart data on error
      return ChartDataModel.empty();
    }

    final transactions = transactionsResult.getOrElse((_) => []);

    // Filtrer par période si nécessaire
    final filteredTransactions = _filterTransactionsByPeriod(transactions, startDate, endDate);

    // Calculer les données pour les graphiques
    final pieChartData = _calculatePieChartData(filteredTransactions);
    final barChartData = _calculateBarChartData(filteredTransactions);
    final lineChartData = _calculateLineChartData(filteredTransactions);

    return ChartDataModel(
      pieChartData: pieChartData,
      barChartData: barChartData,
      lineChartData: lineChartData,
    );
  }

  @override
  Future<ChartDataModel> getActivityChartData(String activityId, DateTime? startDate, DateTime? endDate) async {
    final transactionsResult = await _transactionRepository.getTransactionsByActivity(activityId);

    if (transactionsResult.isLeft()) {
      // Return empty chart data on error
      return ChartDataModel.empty();
    }

    final transactions = transactionsResult.getOrElse((_) => []);

    // Filtrer par période si nécessaire
    final filteredTransactions = _filterTransactionsByPeriod(transactions, startDate, endDate);

    // Calculer les données pour les graphiques de l'activité
    final pieChartData = _calculatePieChartData(filteredTransactions);
    final barChartData = _calculateBarChartData(filteredTransactions);
    final lineChartData = _calculateLineChartData(filteredTransactions);

    return ChartDataModel(
      pieChartData: pieChartData,
      barChartData: barChartData,
      lineChartData: lineChartData,
    );
  }

  @override
  Future<List<ActivityKPIsModel>> getAllActivitiesKPIs(DateTime? startDate, DateTime? endDate) async {
    final activitiesResult = await _activityRepository.getAllActivities();
    final activities = activitiesResult.getOrElse((_) => []);
    final activitiesKPIs = <ActivityKPIsModel>[];

    for (final activity in activities) {
      final kpis = await getActivityKPIs(activity.id, startDate, endDate);
      activitiesKPIs.add(kpis);
    }

    return activitiesKPIs;
  }

  // Méthodes utilitaires pour les calculs

  List<Transaction> _filterTransactionsByPeriod(
    List<Transaction> transactions,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    if (startDate == null && endDate == null) {
      return transactions;
    }

    return transactions.where((transaction) {
      final transactionDate = transaction.transactionDate;
      final isAfterStart = startDate == null || transactionDate.isAfter(startDate) || transactionDate.isAtSameMomentAs(startDate);
      final isBeforeEnd = endDate == null || transactionDate.isBefore(endDate) || transactionDate.isAtSameMomentAs(endDate);
      return isAfterStart && isBeforeEnd;
    }).toList();
  }

  double _calculateTotalRecettes(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == TransactionType.recette && (t.status == TransactionStatus.approved || t.status == TransactionStatus.completed))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _calculateTotalDepenses(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == TransactionType.depense && (t.status == TransactionStatus.approved || t.status == TransactionStatus.completed))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _calculateResteACollecter(List<Transaction> transactions) {
    return transactions
        .where((t) => t.status == TransactionStatus.pending)
        .fold(0.0, (sum, t) => sum + (t.type == TransactionType.recette ? t.amount : -t.amount));
  }

  double _calculateRecettesEnAttente(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == TransactionType.recette && t.status == TransactionStatus.pending)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _calculateDepensesEnAttente(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == TransactionType.depense && t.status == TransactionStatus.pending)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _calculateRecettesAcquises(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == TransactionType.recette && (t.status == TransactionStatus.approved || t.status == TransactionStatus.completed))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _calculateDepensesAcquises(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == TransactionType.depense && (t.status == TransactionStatus.approved || t.status == TransactionStatus.completed))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  List<PieChartDataPoint> _calculatePieChartData(List<Transaction> transactions) {
    final recettes = _calculateTotalRecettes(transactions);
    final depenses = _calculateTotalDepenses(transactions);

    return [
      if (recettes > 0) PieChartDataPoint(label: 'Recettes', value: recettes, color: Color(0xFF1A5554)),
      if (depenses > 0) PieChartDataPoint(label: 'Dépenses', value: depenses, color: Color(0xFFD32F2F)),
    ];
  }

  List<BarChartDataPoint> _calculateBarChartData(List<Transaction> transactions) {
    // Grouper par mois
    final monthlyData = <DateTime, Map<String, double>>{};

    for (final transaction in transactions) {
      final month = DateTime(transaction.transactionDate.year, transaction.transactionDate.month);
      monthlyData[month] ??= {'recettes': 0, 'depenses': 0};

      if (transaction.status == TransactionStatus.approved || transaction.status == TransactionStatus.completed) {
        if (transaction.type == TransactionType.recette) {
          monthlyData[month]!['recettes'] = (monthlyData[month]!['recettes'] ?? 0) + transaction.amount;
        } else {
          monthlyData[month]!['depenses'] = (monthlyData[month]!['depenses'] ?? 0) + transaction.amount;
        }
      }
    }

    return monthlyData.entries.map((entry) {
      return BarChartDataPoint(
        label: '${entry.key.month}/${entry.key.year}',
        recettes: entry.value['recettes'] ?? 0,
        depenses: entry.value['depenses'] ?? 0,
      );
    }).toList()
      ..sort((a, b) => a.label.compareTo(b.label));
  }

  List<LineChartDataPoint> _calculateLineChartData(List<Transaction> transactions) {
    // Calculer le solde cumulatif par jour
    final dailyBalances = <DateTime, double>{};
    double cumulativeBalance = 0;

    final sortedTransactions = transactions
        .where((t) => t.status == TransactionStatus.approved || t.status == TransactionStatus.completed)
        .toList()
      ..sort((a, b) => a.transactionDate.compareTo(b.transactionDate));

    for (final transaction in sortedTransactions) {
      final day = DateTime(transaction.transactionDate.year, transaction.transactionDate.month, transaction.transactionDate.day);
      if (transaction.type == TransactionType.recette) {
        cumulativeBalance += transaction.amount;
      } else {
        cumulativeBalance -= transaction.amount;
      }
      dailyBalances[day] = cumulativeBalance;
    }

    return dailyBalances.entries.map((entry) {
      return LineChartDataPoint(
        date: entry.key,
        value: entry.value,
      );
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }
}
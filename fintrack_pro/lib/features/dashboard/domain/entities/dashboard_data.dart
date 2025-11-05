import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'kpi.dart';
import '../../../../core/types/kpi_type.dart';

/// Entité de domaine pour les données du dashboard
class DashboardData extends Equatable {
  final GlobalKPIs globalKPIs;
  final List<ActivityKPIs> activitiesKPIs;
  final ChartData chartData;
  final DashboardPeriod period;

  const DashboardData({
    required this.globalKPIs,
    required this.activitiesKPIs,
    required this.chartData,
    required this.period,
  });

  /// Crée des données vides pour le dashboard
  factory DashboardData.empty() {
    return DashboardData(
      globalKPIs: GlobalKPIs(
        totalRecettes: KPI(
          id: 'total_recettes',
          title: 'Total Recettes',
          value: 0,
          unit: '€',
          iconName: 'trending_up',
        ),
        totalDepenses: KPI(
          id: 'total_depenses',
          title: 'Total Dépenses',
          value: 0,
          unit: '€',
          iconName: 'trending_down',
        ),
        resteACollecter: KPI(
          id: 'reste_a_collecter',
          title: 'Restes à Collecter',
          value: 0,
          unit: '€',
          iconName: 'clock',
        ),
        soldeGlobal: KPI(
          id: 'solde_global',
          title: 'Solde Global',
          value: 0,
          unit: '€',
          iconName: 'wallet',
        ),
      ),
      activitiesKPIs: [],
      chartData: ChartData.empty(),
      period: DashboardPeriod.currentYear(),
    );
  }

  /// Vérifie si le dashboard a des données
  bool get hasData =>
      (globalKPIs.totalRecettes.value > 0 ||
       globalKPIs.totalDepenses.value > 0 ||
       globalKPIs.resteACollecter.value > 0 ||
       globalKPIs.soldeGlobal.value != 0) ||
      activitiesKPIs.isNotEmpty ||
      chartData.hasData;

  /// Calcule le nombre total d'activités
  int get totalActivities => activitiesKPIs.length;

  /// Calcule le nombre d'activités rentables
  int get profitableActivities =>
      activitiesKPIs.where((activity) => activity.isProfitable).length;

  /// Calcule le taux de réussite global
  double get successRate {
    if (totalActivities == 0) return 0.0;
    return (profitableActivities / totalActivities) * 100;
  }

  @override
  List<Object?> get props => [
    globalKPIs,
    activitiesKPIs,
    chartData,
    period,
  ];
}

/// Période pour le dashboard
class DashboardPeriod extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;
  final String label;

  const DashboardPeriod({
    required this.startDate,
    required this.endDate,
    required this.label,
  });

  /// Période pour l'année courante
  factory DashboardPeriod.currentYear() {
    final now = DateTime.now();
    return DashboardPeriod(
      startDate: DateTime(now.year, 1, 1),
      endDate: DateTime(now.year, 12, 31),
      label: '${now.year}',
    );
  }

  /// Période pour l'année dernière
  factory DashboardPeriod.lastYear() {
    final now = DateTime.now();
    final lastYear = now.year - 1;
    return DashboardPeriod(
      startDate: DateTime(lastYear, 1, 1),
      endDate: DateTime(lastYear, 12, 31),
      label: '$lastYear',
    );
  }

  /// Période pour les deux dernières années
  factory DashboardPeriod.lastTwoYears() {
    final now = DateTime.now();
    final lastYear = now.year - 1;
    return DashboardPeriod(
      startDate: DateTime(lastYear, 1, 1),
      endDate: DateTime(now.year, 12, 31),
      label: '$lastYear-${now.year}',
    );
  }

  /// Période pour toutes les données
  factory DashboardPeriod.allTime() {
    return const DashboardPeriod(
      startDate: null,
      endDate: null,
      label: 'Toutes périodes',
    );
  }

  /// Période personnalisée
  factory DashboardPeriod.custom(DateTime start, DateTime end) {
    return DashboardPeriod(
      startDate: start,
      endDate: end,
      label: '${start.year}-${end.year}',
    );
  }

  /// Liste des périodes prédéfinies
  static List<DashboardPeriod> get predefinedPeriods => [
    DashboardPeriod.currentYear(),
    DashboardPeriod.lastYear(),
    DashboardPeriod.lastTwoYears(),
    DashboardPeriod.allTime(),
  ];

  /// Vérifie si une date est dans la période
  bool containsDate(DateTime date) {
    if (startDate == null && endDate == null) return true;
    if (startDate != null && date.isBefore(startDate!)) return false;
    if (endDate != null && date.isAfter(endDate!)) return false;
    return true;
  }

  /// Calcule la durée en jours
  int? get durationInDays {
    if (startDate == null || endDate == null) return null;
    return endDate!.difference(startDate!).inDays;
  }

  @override
  List<Object?> get props => [startDate, endDate, label];
}

/// Données pour les graphiques
class ChartData extends Equatable {
  final List<PieChartDataPoint> pieChartData;
  final List<BarChartDataPoint> barChartData;
  final List<LineChartDataPoint> lineChartData;

  const ChartData({
    required this.pieChartData,
    required this.barChartData,
    required this.lineChartData,
  });

  /// Crée des données vides pour les graphiques
  factory ChartData.empty() {
    return const ChartData(
      pieChartData: [],
      barChartData: [],
      lineChartData: [],
    );
  }

  /// Vérifie si les données sont disponibles
  bool get hasData =>
      pieChartData.isNotEmpty ||
      barChartData.isNotEmpty ||
      lineChartData.isNotEmpty;

  /// Calcule le total pour le graphique en secteurs
  double get pieChartTotal => pieChartData.fold(0.0, (sum, point) => sum + point.value);

  /// Calcule les valeurs min/max pour le graphique en ligne
  double get lineChartMin => lineChartData.isEmpty
      ? 0.0
      : lineChartData.map((point) => point.value).reduce((a, b) => a < b ? a : b);

  double get lineChartMax => lineChartData.isEmpty
      ? 0.0
      : lineChartData.map((point) => point.value).reduce((a, b) => a > b ? a : b);

  /// Calcule les valeurs min/max pour le graphique en barres
  double get barChartMaxRecettes => barChartData.isEmpty
      ? 0.0
      : barChartData.map((point) => point.recettes).reduce((a, b) => a > b ? a : b);

  double get barChartMaxDepenses => barChartData.isEmpty
      ? 0.0
      : barChartData.map((point) => point.depenses).reduce((a, b) => a > b ? a : b);

  @override
  List<Object?> get props => [pieChartData, barChartData, lineChartData];
}

/// Point de données pour les graphiques en secteurs
class PieChartDataPoint extends Equatable {
  final String label;
  final double value;
  final Color color;
  final double? percentage;

  const PieChartDataPoint({
    required this.label,
    required this.value,
    required this.color,
    this.percentage,
  });

  /// Calcule le pourcentage automatiquement
  double calculatePercentage(double total) {
    if (total == 0) return 0.0;
    return (value / total) * 100;
  }

  @override
  List<Object?> get props => [label, value, color, percentage];
}

/// Point de données pour les graphiques en barres
class BarChartDataPoint extends Equatable {
  final String label;
  final double recettes;
  final double depenses;

  const BarChartDataPoint({
    required this.label,
    required this.recettes,
    required this.depenses,
  });

  /// Calcule le solde (recettes - dépenses)
  double get solde => recettes - depenses;

  /// Vérifie si c'est positif
  bool get isPositive => solde >= 0;

  @override
  List<Object?> get props => [label, recettes, depenses];
}

/// Point de données pour les graphiques en ligne
class LineChartDataPoint extends Equatable {
  final DateTime date;
  final double value;

  const LineChartDataPoint({
    required this.date,
    required this.value,
  });

  @override
  List<Object?> get props => [date, value];
}
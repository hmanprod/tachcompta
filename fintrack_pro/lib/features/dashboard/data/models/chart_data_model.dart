import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/// Point de données pour les graphiques en secteurs
class PieChartDataPoint extends Equatable {
  final String label;
  final double value;
  final Color color;

  const PieChartDataPoint({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  List<Object?> get props => [label, value, color];
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

  double get solde => recettes - depenses;

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

/// Modèle de données pour tous les graphiques du dashboard
class ChartDataModel extends Equatable {
  final List<PieChartDataPoint> pieChartData;
  final List<BarChartDataPoint> barChartData;
  final List<LineChartDataPoint> lineChartData;

  const ChartDataModel({
    required this.pieChartData,
    required this.barChartData,
    required this.lineChartData,
  });

  /// Factory pour créer des données de graphiques vides
  factory ChartDataModel.empty() {
    return const ChartDataModel(
      pieChartData: [],
      barChartData: [],
      lineChartData: [],
    );
  }

  /// Vérifie si les données sont vides
  bool get isEmpty =>
      pieChartData.isEmpty &&
      barChartData.isEmpty &&
      lineChartData.isEmpty;

  /// Vérifie si les données sont disponibles
  bool get hasData =>
      pieChartData.isNotEmpty ||
      barChartData.isNotEmpty ||
      lineChartData.isNotEmpty;

  /// Calcule le total des valeurs pour le graphique en secteurs
  double get pieChartTotal => pieChartData.fold(0.0, (sum, point) => sum + point.value);

  /// Calcule les valeurs min/max pour le graphique en ligne
  double get lineChartMin => lineChartData.isEmpty
      ? 0.0
      : lineChartData.map((point) => point.value).reduce((a, b) => a < b ? a : b);

  double get lineChartMax => lineChartData.isEmpty
      ? 0.0
      : lineChartData.map((point) => point.value).reduce((a, b) => a > b ? a : b);

  @override
  List<Object?> get props => [pieChartData, barChartData, lineChartData];
}
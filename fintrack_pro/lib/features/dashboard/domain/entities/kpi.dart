import 'package:equatable/equatable.dart';

/// Entité de domaine pour un KPI
class KPI extends Equatable {
  final String id;
  final String title;
  final double value;
  final double? previousValue;
  final String unit;
  final String iconName;
  final KPITrend trend;
  final double? percentageChange;

  const KPI({
    required this.id,
    required this.title,
    required this.value,
    this.previousValue,
    required this.unit,
    required this.iconName,
    this.trend = KPITrend.neutral,
    this.percentageChange,
  });

  /// Calcule le pourcentage de changement automatiquement
  double? get calculatedPercentageChange {
    if (previousValue == null || previousValue == 0) return null;
    return ((value - previousValue!) / previousValue!.abs()) * 100;
  }

  /// Détermine la tendance basée sur le changement
  KPITrend get calculatedTrend {
    final change = calculatedPercentageChange;
    if (change == null) return KPITrend.neutral;
    if (change > 0) return KPITrend.up;
    if (change < 0) return KPITrend.down;
    return KPITrend.neutral;
  }

  /// Formate la valeur pour l'affichage
  String get formattedValue {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M $unit';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k $unit';
    } else {
      return '${value.toStringAsFixed(2)} $unit';
    }
  }

  /// Crée une copie avec des valeurs modifiées
  KPI copyWith({
    String? id,
    String? title,
    double? value,
    double? previousValue,
    String? unit,
    String? iconName,
    KPITrend? trend,
    double? percentageChange,
  }) {
    return KPI(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
      previousValue: previousValue ?? this.previousValue,
      unit: unit ?? this.unit,
      iconName: iconName ?? this.iconName,
      trend: trend ?? this.trend,
      percentageChange: percentageChange ?? this.percentageChange,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    value,
    previousValue,
    unit,
    iconName,
    trend,
    percentageChange,
  ];
}

/// Types de tendances pour les KPIs
enum KPITrend {
  up,
  down,
  neutral;

  String get displayText {
    switch (this) {
      case KPITrend.up:
        return '+';
      case KPITrend.down:
        return '-';
      case KPITrend.neutral:
        return '';
    }
  }

  bool get isPositive => this == KPITrend.up;
  bool get isNegative => this == KPITrend.down;
  bool get isNeutral => this == KPITrend.neutral;
}

/// Collection des KPIs globaux
class GlobalKPIs extends Equatable {
  final KPI totalRecettes;
  final KPI totalDepenses;
  final KPI resteACollecter;
  final KPI soldeGlobal;

  const GlobalKPIs({
    required this.totalRecettes,
    required this.totalDepenses,
    required this.resteACollecter,
    required this.soldeGlobal,
  });

  /// Calcule le solde global à partir des autres KPIs
  double get calculatedSoldeGlobal => totalRecettes.value - totalDepenses.value;

  /// Vérifie si tous les KPIs sont positifs
  bool get isOverallPositive => soldeGlobal.value >= 0;

  /// Calcule le taux de marge (recettes - dépenses) / recettes
  double? get marginRate {
    if (totalRecettes.value == 0) return null;
    return (calculatedSoldeGlobal / totalRecettes.value) * 100;
  }

  @override
  List<Object?> get props => [
    totalRecettes,
    totalDepenses,
    resteACollecter,
    soldeGlobal,
  ];
}

/// KPIs pour une activité spécifique
class ActivityKPIs extends Equatable {
  final String activityId;
  final String activityName;
  final KPI recettesEnAttente;
  final KPI depensesEnAttente;
  final KPI recettesAcquises;
  final KPI depensesAcquises;
  final KPI resteDisponible;

  const ActivityKPIs({
    required this.activityId,
    required this.activityName,
    required this.recettesEnAttente,
    required this.depensesEnAttente,
    required this.recettesAcquises,
    required this.depensesAcquises,
    required this.resteDisponible,
  });

  /// Calcule le reste disponible automatiquement
  double get calculatedResteDisponible => recettesAcquises.value - depensesAcquises.value;

  /// Calcule le total des recettes (en attente + acquises)
  double get totalRecettes => recettesEnAttente.value + recettesAcquises.value;

  /// Calcule le total des dépenses (en attente + acquises)
  double get totalDepenses => depensesEnAttente.value + depensesAcquises.value;

  /// Vérifie si l'activité est rentable
  bool get isProfitable => calculatedResteDisponible > 0;

  /// Calcule le taux de réalisation des recettes
  double? get recettesCompletionRate {
    final total = totalRecettes;
    if (total == 0) return null;
    return (recettesAcquises.value / total) * 100;
  }

  /// Calcule le taux de réalisation des dépenses
  double? get depensesCompletionRate {
    final total = totalDepenses;
    if (total == 0) return null;
    return (depensesAcquises.value / total) * 100;
  }

  @override
  List<Object?> get props => [
    activityId,
    activityName,
    recettesEnAttente,
    depensesEnAttente,
    recettesAcquises,
    depensesAcquises,
    resteDisponible,
  ];
}
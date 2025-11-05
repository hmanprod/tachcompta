import 'package:equatable/equatable.dart';

/// Modèle pour un KPI individuel
class KPIModel extends Equatable {
  final String id;
  final String title;
  final double value;
  final double? previousValue;
  final String unit;
  final String iconName;
  final KPIType type;
  final KPITrend trend;
  final double? percentageChange;

  const KPIModel({
    required this.id,
    required this.title,
    required this.value,
    this.previousValue,
    required this.unit,
    required this.iconName,
    required this.type,
    this.trend = KPITrend.neutral,
    this.percentageChange,
  });

  /// Calcule le pourcentage de changement
  double? get percentageChangeValue {
    if (previousValue == null || previousValue == 0) return null;
    return ((value - previousValue!) / previousValue!.abs()) * 100;
  }

  /// Factory pour créer un KPI vide
  factory KPIModel.empty(String id, String title, KPIType type, String iconName) {
    return KPIModel(
      id: id,
      title: title,
      value: 0,
      unit: '€',
      iconName: iconName,
      type: type,
    );
  }

  KPIModel copyWith({
    String? id,
    String? title,
    double? value,
    double? previousValue,
    String? unit,
    String? iconName,
    KPIType? type,
    KPITrend? trend,
    double? percentageChange,
  }) {
    return KPIModel(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
      previousValue: previousValue ?? this.previousValue,
      unit: unit ?? this.unit,
      iconName: iconName ?? this.iconName,
      type: type ?? this.type,
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
    type,
    trend,
    percentageChange,
  ];
}

/// Types de KPIs
enum KPIType {
  recettes('recettes'),
  depenses('depenses'),
  resteACollecter('reste_a_collecter'),
  soldeGlobal('solde_global'),
  recettesEnAttente('recettes_en_attente'),
  depensesEnAttente('depenses_en_attente'),
  recettesAcquises('recettes_acquises'),
  depensesAcquises('depenses_acquises'),
  resteDisponible('reste_disponible');

  const KPIType(this.value);
  final String value;

  static KPIType fromString(String value) {
    return KPIType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => KPIType.recettes,
    );
  }
}

/// Tendance d'un KPI
enum KPITrend {
  up('up'),
  down('down'),
  neutral('neutral');

  const KPITrend(this.value);
  final String value;

  static KPITrend fromString(String value) {
    return KPITrend.values.firstWhere(
      (trend) => trend.value == value,
      orElse: () => KPITrend.neutral,
    );
  }
}

/// Collection de KPIs pour le dashboard principal
class GlobalKPIsModel extends Equatable {
  final KPIModel totalRecettes;
  final KPIModel totalDepenses;
  final KPIModel resteACollecter;
  final KPIModel soldeGlobal;

  const GlobalKPIsModel({
    required this.totalRecettes,
    required this.totalDepenses,
    required this.resteACollecter,
    required this.soldeGlobal,
  });

  /// Factory pour créer des KPIs vides
  factory GlobalKPIsModel.empty() {
    return const GlobalKPIsModel(
      totalRecettes: KPIModel(
        id: 'total_recettes',
        title: 'Total Recettes',
        value: 0,
        unit: '€',
        iconName: 'trending_up',
        type: KPIType.recettes,
      ),
      totalDepenses: KPIModel(
        id: 'total_depenses',
        title: 'Total Dépenses',
        value: 0,
        unit: '€',
        iconName: 'trending_down',
        type: KPIType.depenses,
      ),
      resteACollecter: KPIModel(
        id: 'reste_a_collecter',
        title: 'Restes à Collecter',
        value: 0,
        unit: '€',
        iconName: 'clock',
        type: KPIType.resteACollecter,
      ),
      soldeGlobal: KPIModel(
        id: 'solde_global',
        title: 'Solde Global',
        value: 0,
        unit: '€',
        iconName: 'wallet',
        type: KPIType.soldeGlobal,
      ),
    );
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
class ActivityKPIsModel extends Equatable {
  final String activityId;
  final String activityName;
  final KPIModel recettesEnAttente;
  final KPIModel depensesEnAttente;
  final KPIModel recettesAcquises;
  final KPIModel depensesAcquises;
  final KPIModel resteDisponible;

  const ActivityKPIsModel({
    required this.activityId,
    required this.activityName,
    required this.recettesEnAttente,
    required this.depensesEnAttente,
    required this.recettesAcquises,
    required this.depensesAcquises,
    required this.resteDisponible,
  });

  /// Factory pour créer des KPIs vides pour une activité
  factory ActivityKPIsModel.empty(String activityId, String activityName) {
    return ActivityKPIsModel(
      activityId: activityId,
      activityName: activityName,
      recettesEnAttente: KPIModel(
        id: 'recettes_en_attente_$activityId',
        title: 'Recettes en Attente',
        value: 0,
        unit: '€',
        iconName: 'pending',
        type: KPIType.recettesEnAttente,
      ),
      depensesEnAttente: KPIModel(
        id: 'depenses_en_attente_$activityId',
        title: 'Dépenses en Attente',
        value: 0,
        unit: '€',
        iconName: 'pending',
        type: KPIType.depensesEnAttente,
      ),
      recettesAcquises: KPIModel(
        id: 'recettes_acquises_$activityId',
        title: 'Recettes Acquises',
        value: 0,
        unit: '€',
        iconName: 'check_circle',
        type: KPIType.recettesAcquises,
      ),
      depensesAcquises: KPIModel(
        id: 'depenses_acquises_$activityId',
        title: 'Dépenses Acquises',
        value: 0,
        unit: '€',
        iconName: 'check_circle',
        type: KPIType.depensesAcquises,
      ),
      resteDisponible: KPIModel(
        id: 'reste_disponible_$activityId',
        title: 'Reste Disponible',
        value: 0,
        unit: '€',
        iconName: 'account_balance_wallet',
        type: KPIType.resteDisponible,
      ),
    );
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
/// Statuts possibles pour une activité
enum ActivityStatus {
  /// Activité active et opérationnelle
  active,

  /// Activité fermée
  closed,

  /// Activité suspendue temporairement
  suspended,

  /// Activité en brouillon
  draft,
}
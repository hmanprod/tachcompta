/// Types de KPI disponibles dans le tableau de bord
enum KPIType {
  /// Recettes totales
  recettes,

  /// Dépenses totales
  depenses,

  /// Solde net (recettes - dépenses)
  solde,

  /// Nombre d'activités actives
  activitesActives,

  /// Nombre de transactions en attente
  transactionsEnAttente,

  /// Taux d'approbation des transactions
  tauxApprobation,

  /// Nombre d'utilisateurs actifs
  utilisateursActifs,

  /// Budget restant
  budgetRestant,
}
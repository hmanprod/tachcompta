/// Types de transactions disponibles dans l'application
enum TransactionType {
  /// Dépense - sortie d'argent
  depense,

  /// Recette - entrée d'argent
  recette,

  /// Transfert - mouvement entre comptes
  transfert,

  /// Ajustement - correction de balance
  ajustement,
}
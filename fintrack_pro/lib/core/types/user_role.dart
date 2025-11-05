/// Rôles disponibles pour les utilisateurs du système
enum UserRole {
  /// Administrateur - accès complet au système
  admin,

  /// Agent système - gestion des activités et transactions
  agent,

  /// Utilisateur standard - accès limité aux fonctionnalités
  user,

  /// Comptable - gestion financière
  comptable,

  /// Superviseur - validation et approbation
  superviseur,
}
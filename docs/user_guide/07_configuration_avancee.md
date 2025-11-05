# Configuration Avancée - FinTrack Pro

## Vue d'ensemble

Ce guide détaille les paramètres avancés de configuration de FinTrack Pro, accessibles principalement aux administrateurs système pour personnaliser l'application selon les besoins spécifiques de l'entreprise.

## Paramètres Système

### Configuration de Base de Données

#### Emplacement des Données
- **Dossier par défaut** : `%APPDATA%/fintrack_pro/data`
- **Personnalisation** : Choix dossier custom avec permissions
- **Migration** : Outil de déplacement données existantes

#### Optimisation Performance
```yaml
# Configuration avancée base de données
database:
  cache_size: 100MB          # Taille cache SQLite
  journal_mode: WAL          # Mode journal optimisé
  synchronous: NORMAL        # Niveau synchronisation
  temp_store: MEMORY         # Stockage temporaire
```

#### Maintenance Automatique
- **VACUUM** : Nettoyage fragmentation (hebdomadaire)
- **REINDEX** : Reconstruction index (mensuel)
- **ANALYZE** : Mise à jour statistiques (quotidien)

### Paramètres de Sécurité

#### Politiques de Mot de Passe
```dart
class PasswordPolicy {
  int minLength = 8;              // Longueur minimum
  bool requireUppercase = true;   // Majuscules requises
  bool requireLowercase = true;   // Minuscules requises
  bool requireNumbers = true;     // Chiffres requis
  bool requireSpecialChars = false; // Caractères spéciaux
  int maxAgeDays = 90;            // Expiration mot de passe
  int historyCount = 5;           // Mémorisation anciens mots de passe
}
```

#### Gestion des Sessions
- **Timeout inactivité** : 15-120 minutes
- **Limite connexions simultanées** : Par utilisateur
- **Blocage compte** : Après X tentatives échouées
- **Session prolongée** : "Se souvenir de moi"

#### Chiffrement des Données
- **Algorithme** : AES-256-GCM
- **Clés** : Génération automatique, rotation périodique
- **Scope** : Données sensibles uniquement (mots de passe, documents)

### Configuration Réseau (Optionnel)

#### Proxy et Connectivité
```yaml
network:
  proxy:
    enabled: false
    host: proxy.entreprise.com
    port: 8080
    auth_required: true
  timeout: 30s                 # Timeout requêtes
  retry_count: 3              # Tentatives automatiques
```

#### Synchronisation Cloud
- **Endpoint Supabase** : Configuration URL projet
- **Clés API** : Stockage sécurisé chiffré
- **Mode sync** : Bidirectionnel, unidirectionnel, manuel

## Configuration Métier

### Règles d'Approbation des Transactions

#### Seuils Automatiques
```dart
class AutoApprovalRules {
  // Par montant
  double maxAutoApproveAmount = 1000.0;
  double agentApprovalThreshold = 5000.0;
  double doubleApprovalThreshold = 25000.0;

  // Par type transaction
  Map<TransactionType, double> typeThresholds = {
    TransactionType.recette: 5000.0,
    TransactionType.depense: 2000.0,
  };

  // Par utilisateur (exceptions)
  Map<String, double> userOverrides = {};
}
```

#### Workflows d'Approbation Multi-niveaux
- **Simple** : Agent uniquement
- **Double** : Agent + Superviseur
- **Triple** : Agent + Superviseur + Direction
- **Conditionnel** : Selon règles métier complexes

#### Règles Métier Personnalisées
- **Cohérence temporelle** : Date transaction vs date saisie
- **Limites fréquence** : Nombre transactions/jour/utilisateur
- **Contrôles cross-activité** : Vérifications globales

### Gestion des Activités

#### Workflows de Clôture
```dart
class ClosureWorkflow {
  bool requireAllApproved = true;        // Toutes transactions approuvées
  bool requireZeroBalance = false;       // Solde nul obligatoire
  bool allowNegativeBalance = true;      // Autoriser soldes négatifs
  TransferStrategy transferStrategy;     // Stratégie transfert soldes
  List<String> requiredDocuments;        // Documents justificatifs
}
```

#### Assignations Automatiques
- **Par défaut** : Nouveaux utilisateurs → activités prédéfinies
- **Par poste** : Règles basées sur le titre du poste
- **Par département** : Assignations collectives

#### Objectifs et Seuils
- **Budgétaires** : Alertes dépassement par activité
- **Performance** : KPIs cibles par période
- **Qualité** : Taux rejet maximum autorisé

### Configuration des Notifications

#### Modèles d'Emails Personnalisés
```html
<!-- Template notification approbation -->
<!DOCTYPE html>
<html>
<body>
  <h2>Transaction Approuvée</h2>
  <p>Bonjour {{user.firstName}},</p>
  <p>Votre transaction de {{transaction.amount}}€ pour "{{transaction.description}}" a été approuvée.</p>
  <p>Montant approuvé : <strong>{{transaction.amount}}€</strong></p>
  <p>Approuvé par : {{approver.fullName}}</p>
  <p>Date approbation : {{approvalDate}}</p>
  <br>
  <p>Cordialement,<br>FinTrack Pro</p>
</body>
</html>
```

#### Règles d'Escalade
- **Temps réponse** : Notification si pas de réponse sous 24h
- **Seuils dépassés** : Escalade automatique hiérarchique
- **Fréquences** : Batch quotidien/hebdomadaire pour résumés

## Paramètres Régionaux et Internationaux

### Configuration Devise

#### Devise Principale
```dart
class CurrencyConfig {
  String code = 'EUR';              // Code ISO (EUR, USD, XAF)
  String symbol = '€';              // Symbole affiché
  String displayName = 'Euro';      // Nom complet
  int decimalPlaces = 2;            // Décimales (2 pour EUR, 0 pour JPY)
  String thousandsSeparator = ' ';  // Séparateur milliers
  String decimalSeparator = ',';    // Séparateur décimales
  bool symbolBeforeAmount = false;  // Position symbole
}
```

#### Devises Secondaires
- Support multi-devises pour entreprises internationales
- Taux de change manuels ou API externes
- Conversion automatique selon contexte

### Formats Date et Nombre

#### Personnalisation Formats
```dart
class LocaleConfig {
  // Date
  String dateFormat = 'dd/MM/yyyy';      // Format affichage
  String timeFormat = 'HH:mm';           // Format heure
  String dateTimeFormat = 'dd/MM/yyyy HH:mm'; // Complet

  // Nombres
  String numberFormat = '#,##0.00';      // Format numérique
  String percentFormat = '#,##0.00%';    // Format pourcentage

  // Texte
  TextDirection textDirection = TextDirection.ltr;
  String localeCode = 'fr_FR';           // Code locale
}
```

#### Calendriers Spécialisés
- Support calendrier grégorien standard
- Préparation pour calendriers locaux (optionnel)

## Configuration Avancée Utilisateur

### Profils Utilisateur Personnalisés

#### Préférences Interface
```dart
class UserPreferences {
  ThemeMode theme = ThemeMode.system;    // Thème clair/sombre/auto
  double fontSize = 1.0;                 // Taille police (0.8-1.4)
  bool highContrast = false;             // Mode contraste élevé
  bool reducedMotion = false;            // Animations réduites
  Map<String, Shortcut> customShortcuts; // Raccourcis personnalisés
}
```

#### Tableaux de Bord Personnalisés
- Widgets sélectionnés et positionnés
- Filtres par défaut sauvegardés
- Périodes favorites mémorisées

### Droits et Permissions Granulaires

#### Permissions Détaillées
```dart
class GranularPermissions {
  // Transactions
  bool canCreateTransactions = true;
  bool canEditOwnTransactions = true;
  bool canDeleteOwnTransactions = false;
  bool canViewAllTransactions = false;

  // Activités
  bool canCreateActivities = false;
  bool canEditAssignedActivities = true;
  bool canCloseActivities = false;

  // Utilisateurs (Admin seulement)
  bool canManageUsers = false;
  bool canAssignRoles = false;
  bool canResetPasswords = false;

  // Exports
  bool canExportOwnData = true;
  bool canExportAllData = false;
  List<ExportFormat> allowedFormats;
}
```

#### Rôles Personnalisés (Extension Future)
- Création rôles métier spécifiques
- Combinaisons permissions personnalisées
- Hiérarchies rôles complexes

## Configuration des Exports

### Modèles d'Export Personnalisés

#### Configuration CSV/Excel
```yaml
export_templates:
  transaction_export:
    columns:
      - name: date
        label: "Date"
        format: "dd/MM/yyyy"
      - name: activity
        label: "Activité"
        width: 20
      - name: type
        label: "Type"
        transform: "capitalize"
      - name: amount
        label: "Montant"
        format: "currency"
    filters:
      date_range: "last_month"
      status: ["approved", "completed"]
```

#### Rapports PDF Personnalisés
- Mise en page configurable (en-têtes, pieds de page)
- Logos et couleurs entreprise
- Sections conditionnelles
- Formatage riche (gras, couleurs, tableaux)

### Exports Programmés

#### Planification Avancée
```dart
class ScheduledExport {
  String name;
  ExportTemplate template;
  Schedule schedule;           // Quotidien, hebdomadaire, mensuel
  List<String> recipients;     // Emails destinataires
  bool attachDocuments;        // Inclure justificatifs
  CompressionFormat compression; // ZIP, aucun
  RetentionPolicy retention;   // Durée conservation
}
```

#### Automatisation
- Triggers événementiels (clôture activité, seuil dépassé)
- Intégrations externes (SFTP, API REST)
- Workflows conditionnels

## Monitoring et Diagnostics

### Métriques Système

#### Collecte Automatique
```dart
class SystemMetrics {
  // Performance
  double cpuUsage;
  double memoryUsage;
  int activeConnections;
  Duration averageResponseTime;

  // Base de données
  int databaseSize;
  int activeTransactions;
  double cacheHitRate;
  List<SlowQuery> slowQueries;

  // Utilisation
  int concurrentUsers;
  Map<String, int> endpointCalls;
  List<ErrorLog> recentErrors;
}
```

#### Tableaux de Bord Admin
- Graphiques temps réel métriques
- Alertes seuils configurables
- Historique tendances
- Rapports performance

### Outils de Diagnostic

#### Tests Automatisés
- **Intégrité base** : Vérification contraintes, index
- **Performance** : Tests charge simulés
- **Connectivité** : Tests réseau et API externes
- **Sécurité** : Audit permissions et chiffrement

#### Logs Détaillés
- Niveaux : ERROR, WARN, INFO, DEBUG
- Rotation automatique fichiers
- Recherche et filtrage avancés
- Export pour analyse externe

## Maintenance et Sauvegarde

### Stratégies de Sauvegarde

#### Configuration Avancée
```yaml
backup:
  strategy: incremental          # Complet, incrémental, différentiel
  frequency: daily              # Quotidien, hebdomadaire
  retention:
    daily: 7                    # 7 jours quotidiens
    weekly: 4                   # 4 semaines hebdomadaires
    monthly: 12                 # 12 mois mensuels
  compression: gzip             # Compression sauvegardes
  encryption: aes256            # Chiffrement AES-256
  location:                     # Destinations multiples
    - local: /backup/fintrack
    - cloud: s3://bucket/backup
    - network: \\server\backup
```

#### Restauration
- **Test régulier** : Validation mensuelle restaurations
- **Plan récupération** : Procédures documentées
- **Récupération point-in-time** : Restauration à date précise

### Mises à Jour Automatiques

#### Configuration
```yaml
updates:
  channel: stable              # Stable, beta, dev
  check_frequency: daily       # Quotidienne
  auto_download: true          # Téléchargement automatique
  auto_install: false          # Installation manuelle requise
  maintenance_window:          # Fenêtre maintenance
    start: "02:00"
    duration: "4h"
  rollback_enabled: true       # Rollback automatique si échec
```

#### Gestion Versions
- Historique versions installé
- Possibilité rollback versions précédentes
- Tests compatibilité avant mise à jour

## Intégrations Externes

### APIs et Webhooks

#### Configuration Générique
```yaml
integrations:
  webhooks:
    - name: "ERP Sync"
      url: "https://erp.entreprise.com/api/fintrack"
      method: "POST"
      headers:
        Authorization: "Bearer {{api_key}}"
        Content-Type: "application/json"
      events: ["transaction.approved", "activity.closed"]
      retry_policy:
        max_attempts: 3
        backoff: exponential

  apis:
    - name: "Exchange Rates"
      url: "https://api.exchangerate-api.com/v4/latest/EUR"
      method: "GET"
      schedule: "daily"
      transform: "rates"
```

#### Sécurité APIs
- Clés API chiffrées en base
- Rate limiting configurable
- Logging appels complet
- Gestion erreurs robuste

### Synchronisation Externe

#### Formats d'Échange
- **CSV/Excel** : Pour ERPs classiques
- **API REST** : Pour systèmes modernes
- **SFTP** : Transferts sécurisés
- **Base de données** : Réplication directe (avancé)

#### Mapping Données
- Configuration champs source → destination
- Transformations données (formats, calculs)
- Gestion conflits synchronisation
- Logging détaillé échanges

---

*FinTrack Pro v1.0 - Configuration Avancée - Mis à jour le 31/10/2025*
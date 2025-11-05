# Documentation de la Base de Données FinTrack Pro

## Vue d'ensemble

La base de données SQLite de FinTrack Pro utilise Drift comme ORM pour gérer les données financières d'entreprise. Elle est conçue pour être performante, sécurisée et maintenable.

## Architecture

### Technologies utilisées
- **SQLite** : Base de données embarquée
- **Drift** : ORM Dart génératif
- **Path Provider** : Gestion des chemins de fichiers
- **Crypto** : Hashage des mots de passe

### Structure des fichiers
```
lib/core/database/
├── database.dart              # Configuration principale
├── database.g.dart            # Code généré automatiquement
├── migrations/                # Scripts de migration
└── tables/                    # Définition des tables
    ├── users.dart
    ├── activities.dart
    ├── activity_assignments.dart
    ├── transactions.dart
    └── notifications.dart
```

## Tables

### 1. Users (Utilisateurs)
```sql
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,        -- Hashé avec SHA-256
  role TEXT CHECK(role IN ('admin', 'agent', 'user')) NOT NULL,
  firstName TEXT NOT NULL,
  lastName TEXT NOT NULL,
  avatarUrl TEXT,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  isActive BOOLEAN DEFAULT 1
);
```

**Indexes :**
- `idx_users_email` sur `email`
- `idx_users_role` sur `role`

### 2. Activities (Activités)
```sql
CREATE TABLE activities (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  type TEXT CHECK(type IN ('magasin', 'transport', 'autre')) NOT NULL,
  status TEXT CHECK(status IN ('active', 'closed', 'suspended')) NOT NULL,
  createdBy TEXT REFERENCES users(id) NOT NULL,
  color TEXT,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  closedAt DATETIME
);
```

**Indexes :**
- `idx_activities_status` sur `status`
- `idx_activities_type` sur `type`

### 3. ActivityAssignments (Assignations d'activités)
```sql
CREATE TABLE activity_assignments (
  id TEXT PRIMARY KEY,
  activityId TEXT REFERENCES activities(id) NOT NULL,
  userId TEXT REFERENCES users(id) NOT NULL,
  assignedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  isActive BOOLEAN DEFAULT 1,

  UNIQUE(activityId, userId)
);
```

**Indexes :**
- `idx_activity_assignments_activity_id` sur `activityId`
- `idx_activity_assignments_user_id` sur `userId`

### 4. Transactions (Transactions)
```sql
CREATE TABLE transactions (
  id TEXT PRIMARY KEY,
  activityId TEXT REFERENCES activities(id) NOT NULL,
  userId TEXT REFERENCES users(id) NOT NULL,
  type TEXT CHECK(type IN ('recette', 'depense')) NOT NULL,
  amount REAL NOT NULL,
  status TEXT CHECK(status IN ('pending', 'approved', 'rejected', 'completed')) NOT NULL,
  description TEXT NOT NULL,
  transactionDate DATETIME NOT NULL,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  approvedBy TEXT REFERENCES users(id),
  approvedAt DATETIME,
  rejectionReason TEXT
);
```

**Indexes :**
- `idx_transactions_status` sur `status`
- `idx_transactions_activity_id` sur `activityId`
- `idx_transactions_user_id` sur `userId`
- `idx_transactions_date` sur `transactionDate`

### 5. Notifications (Notifications)
```sql
CREATE TABLE notifications (
  id TEXT PRIMARY KEY,
  userId TEXT REFERENCES users(id) NOT NULL,
  type TEXT CHECK(type IN ('activity_closed', 'new_user', 'pending_expense', 'alert_threshold')) NOT NULL,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  isRead BOOLEAN DEFAULT 0,
  data TEXT,                    -- JSON avec données additionnelles
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

**Indexes :**
- `idx_notifications_user_id` sur `userId`
- `idx_notifications_is_read` sur `isRead`

## Données de test (Seed Data)

### Utilisateurs de test
| Email | Rôle | Prénom | Nom |
|-------|------|--------|-----|
| admin@fintrack.pro | admin | Admin | System |
| agent@fintrack.pro | agent | Agent | IT |
| user@fintrack.pro | user | User | Standard |

**Mot de passe par défaut :** `password123` (hashé)

### Activités de test
| Nom | Type | Assignations |
|-----|------|--------------|
| Magasin Central | magasin | Admin, Agent, User |
| Transport A | transport | Agent, User |
| Boutique B | magasin | User |
| Transport B | transport | Agent, User |

### Transactions de test
- **15-20 transactions** avec différents statuts
- **Types :** recettes et dépenses
- **Statuts :** pending, approved, rejected, completed
- **Montants :** entre 1250.00 et 2200.75

### Notifications de test
- Nouvelles inscriptions utilisateur
- Dépenses en attente d'approbation
- Activités clôturées
- Alertes de seuils budgétaires

## API de la base de données

### Initialisation
```dart
final database = AppDatabase();
await database.init(); // Initialise et seed si vide
```

### Méthodes principales

#### Gestion des données
```dart
// Seed les données de test
await database.seedTestData();

// Vide toutes les données
await database.clearAllData();

// Vérifie si la base est vide
bool isEmpty = await database.isEmpty();
```

#### Statistiques et monitoring
```dart
// Statistiques de la base
Map<String, int> stats = await database.getDatabaseStats();
// Retourne: {'users': X, 'activities': Y, 'transactions': Z, 'notifications': W}
```

#### Maintenance
```dart
// Nettoie les notifications anciennes (>30 jours)
await database.cleanupOldNotifications(daysOld: 30);

// Suspend les activités inactives (>90 jours)
await database.cleanupInactiveActivities(daysInactive: 90);
```

#### Backup/Restore
```dart
// Exporte toutes les données en JSON
String jsonData = await database.exportData();

// Importe les données depuis JSON
await database.importData(jsonData);
```

### DAOs (Data Access Objects)

Chaque table a un DAO généré automatiquement :
```dart
final usersDao = database.usersDao;
final activitiesDao = database.activitiesDao;
final transactionsDao = database.transactionsDao;
final notificationsDao = database.notificationsDao;
final activityAssignmentsDao = database.activityAssignmentsDao;
```

## Optimisations de performance

### Indexes stratégiques
1. **Recherches fréquentes :** email, rôle utilisateur
2. **Filtres courants :** statut activité, type activité
3. **Jointures :** activityId, userId dans transactions
4. **Tri temporel :** dates de transaction et création

### Requêtes optimisées
- Utilisation de `LIMIT` et `ORDER BY` pour la pagination
- Indexes composites pour les recherches multi-critères
- Requêtes préparées pour les opérations répétitives

### Structure des données
- UUID v4 pour tous les identifiants
- Types énumérés pour les contraintes
- Champs nullable seulement quand nécessaire
- Timestamps automatiques pour audit

## Sécurité

### Authentification
- Mots de passe hashés avec SHA-256
- Salage recommandé pour production
- Tokens JWT pour les sessions

### Contraintes d'intégrité
- Clés étrangères avec `REFERENCES`
- Contraintes `CHECK` sur les énumérations
- Unicité sur les emails utilisateurs

## Migration

### Version actuelle : 1
- Tables de base créées
- Indexes optimisés
- Seed data automatique

### Futures migrations
Prévu pour la version 2 :
- Nouveaux champs dans transactions
- Tables d'audit
- Indexes composites avancés

## Tests

### Tests unitaires
- Création et validation des données
- Contraintes d'intégrité
- Performance des requêtes
- Backup/Restore

### Tests d'intégration
- Workflows complets
- Relations entre tables
- Gestion des erreurs

### Tests de performance
- Requêtes sur gros volumes
- Index efficiency
- Memory usage

## Déploiement

### Développement
```bash
# Générer le code Drift
flutter pub run build_runner build --delete-conflicting-outputs

# Mode watch pour le développement
flutter pub run build_runner watch
```

### Production
- Base de données créée automatiquement au premier lancement
- Seed data seulement si base vide
- Migrations automatiques lors des updates

## Monitoring

### Métriques à surveiller
- Taille de la base de données
- Nombre de transactions par jour
- Performance des requêtes principales
- Utilisation des indexes

### Logs recommandés
- Création/modification d'utilisateurs
- Transactions importantes
- Échecs de contraintes
- Opérations de maintenance

## Recommandations

### Pour les développeurs
1. Toujours utiliser les DAOs générés
2. Respecter les types énumérés
3. Gérer les erreurs de contraintes
4. Tester les migrations

### Pour la production
1. Sauvegarde régulière des données
2. Monitoring des performances
3. Nettoyage périodique des données obsolètes
4. Validation des contraintes d'intégrité

### Évolutivité
1. Indexes adaptés aux nouveaux patterns de requêtes
2. Partitionnement si volumétrie importante
3. Cache applicatif pour les données fréquemment lues
4. Optimisation des requêtes complexes

Cette documentation doit être mise à jour à chaque modification significative de la structure de la base de données.
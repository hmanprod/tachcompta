# Annexes Techniques - FinTrack Pro

## Vue d'ensemble

Ce document fournit les informations techniques détaillées sur l'architecture, les spécifications techniques et les procédures de maintenance de FinTrack Pro.

## Architecture Technique

### Stack Technologique

#### Frontend (Flutter Desktop)
```yaml
flutter: ^3.0.0
flutter_localizations: ^0.0.0
cupertino_icons: ^1.0.6

# State Management
flutter_riverpod: ^2.4.9
riverpod_annotation: ^2.3.3

# UI Components
fl_chart: ^0.66.0        # Graphiques
shimmer: ^3.0.0          # États de chargement
lottie: ^2.7.0           # Animations

# Platform Integration
window_manager: ^0.3.7   # Gestion fenêtres desktop
desktop_lifecycle: ^0.1.0 # Cycle de vie app desktop
go_router: ^16.3.0       # Navigation
```

#### Backend (Local SQLite)
```yaml
# Database ORM
drift: ^2.14.0
sqlite3_flutter_libs: ^0.5.15
path_provider: ^2.1.1

# Security
crypto: ^3.0.3           # Hashage mots de passe
shared_preferences: ^2.2.2 # Stockage local
jwt_decoder: ^2.0.1      # Validation JWT

# File Operations
file_picker: ^6.1.1      # Sélection fichiers
excel: ^2.1.0            # Export Excel
pdf: ^3.10.7             # Export PDF
open_file: ^3.3.2        # Ouverture fichiers
```

#### Synchronisation Cloud (Optionnel)
```yaml
supabase_flutter: ^1.10.25 # Backend as a Service
connectivity_plus: ^5.0.2  # État connexion
```

### Architecture Logicielle

#### Clean Architecture Implémentée
```
lib/
├── core/                    # Couche centrale
│   ├── constants/          # Constantes globales
│   ├── database/           # Configuration base de données
│   ├── utils/              # Utilitaires transversaux
│   ├── services/           # Services partagés
│   └── errors/             # Gestion erreurs
│
├── features/               # Modules métier
│   ├── auth/              # Authentification
│   │   ├── data/          # Couche données
│   │   ├── domain/        # Logique métier
│   │   └── presentation/  # Interface utilisateur
│   │
│   ├── activities/        # Gestion activités
│   ├── transactions/      # Transactions financières
│   ├── dashboard/         # Tableaux de bord
│   └── users/             # Gestion utilisateurs
│
├── shared/                # Composants partagés
│   ├── models/            # Modèles de données
│   ├── widgets/           # Composants UI réutilisables
│   ├── providers/         # Providers Riverpod
│   └── services/          # Services partagés
│
└── styles/                # Thème et styles
    ├── app_theme.dart     # Configuration thème
    ├── text_styles.dart   # Styles typographiques
    └── spacing.dart       # Système d'espacement
```

#### Patterns Architecturaux

**Repository Pattern** :
```dart
abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions({
    required String activityId,
    TransactionFilters? filters,
  });
  Future<void> createTransaction(Transaction transaction);
  Future<void> updateTransaction(Transaction transaction);
  Future<void> deleteTransaction(String id);
}

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource _localDataSource;

  @override
  Future<List<Transaction>> getTransactions({
    required String activityId,
    TransactionFilters? filters,
  }) async {
    final models = await _localDataSource.getTransactionModels(
      activityId: activityId,
      filters: filters,
    );
    return models.map((model) => model.toEntity()).toList();
  }
}
```

**Provider Pattern (Riverpod)** :
```dart
// Repository Provider
@riverpod
TransactionRepository transactionRepository(TransactionRepositoryRef ref) {
  final dataSource = ref.watch(transactionLocalDataSourceProvider);
  return TransactionRepositoryImpl(dataSource);
}

// Use Case Provider
@riverpod
CreateTransactionUseCase createTransactionUseCase(CreateTransactionUseCaseRef ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return CreateTransactionUseCase(repository);
}

// State Notifier Provider
@riverpod
class TransactionNotifier extends _$TransactionNotifier {
  @override
  TransactionState build() {
    // Initialize state
    return TransactionState.initial();
  }

  Future<void> createTransaction(CreateTransactionParams params) async {
    state = state.copyWith(isLoading: true);

    try {
      final useCase = ref.read(createTransactionUseCaseProvider);
      await useCase(params);
      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
```

## Modèle de Données

### Schéma Base de Données (Drift)

#### Tables Principales
```dart
// Utilisateurs
class Users extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get email => text()();
  TextColumn get password => text()(); // Hashé SHA-256 + salt
  TextColumn get role => text().check(
    (role).isIn(['admin', 'agent', 'user'])
  )();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get avatarUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [{email}];
}

// Activités
class Activities extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get type => text().check(
    (type).isIn(['magasin', 'transport', 'autre'])
  )();
  TextColumn get status => text().check(
    (status).isIn(['active', 'closed', 'suspended'])
  )();
  TextColumn get createdBy => text().references(Users, #id)();
  TextColumn get color => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn? get closedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Transactions
class Transactions extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get activityId => text().references(Activities, #id)();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get type => text().check(
    (type).isIn(['recette', 'depense'])
  )();
  RealColumn get amount => real()();
  TextColumn get status => text().check(
    (status).isIn(['pending', 'approved', 'rejected', 'completed'])
  )();
  TextColumn get description => text()();
  DateTimeColumn get transactionDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn? get approvedBy => text().references(Users, #id).nullable()();
  DateTimeColumn? get approvedAt => dateTime().nullable()();
  TextColumn? get rejectionReason => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

#### Relations et Contraintes
```sql
-- Relations définies via Drift
-- Users 1:N Activities (createdBy)
-- Users 1:N Transactions (userId, approvedBy)
-- Activities 1:N Transactions (activityId)
-- Activities N:M Users (via ActivityAssignments)

-- Index pour performances
CREATE INDEX idx_transactions_activity_date ON transactions(activity_id, transaction_date);
CREATE INDEX idx_transactions_status ON transactions(status);
CREATE INDEX idx_transactions_user ON transactions(user_id);
CREATE INDEX idx_activities_status ON activities(status);
```

### Modèles de Domaine

#### Entités Business
```dart
// Utilisateur
class User extends Equatable {
  final String id;
  final String email;
  final UserRole role;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const User({
    required this.id,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, email, role, firstName, lastName];
}

enum UserRole { admin, agent, user }

// Activité
class Activity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final ActivityType type;
  final ActivityStatus status;
  final String createdBy;
  final List<String> assignedUsers;
  final String? color;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? closedAt;

  const Activity({/* paramètres */});

  @override
  List<Object?> get props => [id, name, type, status];
}

enum ActivityType { magasin, transport, autre }
enum ActivityStatus { active, closed, suspended }

// Transaction
class Transaction extends Equatable {
  final String id;
  final String activityId;
  final String userId;
  final TransactionType type;
  final double amount;
  final TransactionStatus status;
  final String description;
  final DateTime transactionDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? rejectionReason;

  const Transaction({/* paramètres */});

  @override
  List<Object?> get props => [id, activityId, type, amount, status];
}

enum TransactionType { recette, depense }
enum TransactionStatus { pending, approved, rejected, completed }
```

## APIs et Interfaces

### APIs Internes

#### Services Métier
```dart
// Service Authentification
abstract class AuthService {
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<void> resetPassword(String email);
}

// Service Transactions
abstract class TransactionService {
  Future<List<Transaction>> getTransactions({
    required String activityId,
    TransactionFilters? filters,
  });
  Future<void> createTransaction(Transaction transaction);
  Future<void> approveTransaction(String transactionId, String approvedBy);
  Future<void> rejectTransaction(String transactionId, String reason);
}

// Service KPIs
abstract class KPIService {
  Future<GlobalKPIs> getGlobalKPIs(DateRange range);
  Future<ActivityKPIs> getActivityKPIs(String activityId, DateRange range);
  Stream<GlobalKPIs> watchGlobalKPIs(DateRange range);
  Stream<ActivityKPIs> watchActivityKPIs(String activityId, DateRange range);
}
```

### APIs Externes (Optionnel)

#### Supabase Integration
```dart
class SupabaseService {
  final SupabaseClient _client;

  Future<void> syncUserData(String userId) async {
    // Synchronisation utilisateurs
  }

  Future<void> syncTransactions(String activityId) async {
    // Synchronisation transactions
  }

  Future<void> uploadFile(File file, String path) async {
    // Upload fichiers cloud
  }
}
```

#### Webhooks
```json
// Structure webhook transaction approuvée
{
  "event": "transaction.approved",
  "timestamp": "2025-01-31T10:00:00Z",
  "data": {
    "transaction_id": "txn_12345",
    "activity_id": "act_67890",
    "amount": 1250.50,
    "approved_by": "user_admin",
    "approved_at": "2025-01-31T10:00:00Z"
  }
}
```

## Sécurité et Conformité

### Chiffrement des Données

#### Algorithmes Utilisés
- **Mots de passe** : PBKDF2 + SHA-256 + salt aléatoire
- **Données sensibles** : AES-256-GCM
- **Fichiers** : AES-256 en mode CBC
- **Communications** : TLS 1.3 (pour APIs externes)

#### Gestion des Clés
```dart
class EncryptionService {
  static const String _algorithm = 'AES-256-GCM';

  Future<String> encrypt(String plainText, String key) async {
    final keyBytes = utf8.encode(key);
    final plainBytes = utf8.encode(plainText);

    final encrypted = await _encryptAES(plainBytes, keyBytes);
    return base64.encode(encrypted);
  }

  Future<String> decrypt(String encryptedText, String key) async {
    final keyBytes = utf8.encode(key);
    final encryptedBytes = base64.decode(encryptedText);

    final decrypted = await _decryptAES(encryptedBytes, keyBytes);
    return utf8.decode(decrypted);
  }
}
```

### Audit et Traçabilité

#### Journal d'Audit
```dart
class AuditEntry {
  final String id;
  final DateTime timestamp;
  final String userId;
  final AuditAction action;
  final String resourceType;
  final String resourceId;
  final Map<String, dynamic> changes;
  final String ipAddress;
  final String userAgent;

  const AuditEntry({
    required this.id,
    required this.timestamp,
    required this.userId,
    required this.action,
    required this.resourceType,
    required this.resourceId,
    required this.changes,
    required this.ipAddress,
    required this.userAgent,
  });
}

enum AuditAction {
  create,
  read,
  update,
  delete,
  login,
  logout,
  export,
  import
}
```

#### Conformité RGPD
- **Droit d'accès** : Export données utilisateur
- **Droit d'effacement** : Suppression complète anonymisée
- **Droit de rectification** : Modification données personnelles
- **Minimisation** : Collecte données strictement nécessaires

## Performance et Optimisation

### Métriques Performance

#### Indicateurs Clés
```dart
class PerformanceMetrics {
  // Temps de réponse
  Duration get averageResponseTime;
  Duration get maxResponseTime;
  Duration get minResponseTime;

  // Utilisation ressources
  double get cpuUsage;
  double get memoryUsage;
  int get activeConnections;

  // Base de données
  int get queryCount;
  double get averageQueryTime;
  int get cacheHitRate;

  // Application
  int get activeUsers;
  int get concurrentSessions;
  double get appStartupTime;
}
```

### Optimisations Implémentées

#### Base de Données
```sql
-- Index optimisés
CREATE INDEX idx_transactions_composite
ON transactions(activity_id, status, transaction_date);

CREATE INDEX idx_activities_active
ON activities(status, created_at)
WHERE status = 'active';

-- Requêtes optimisées avec pagination
SELECT * FROM transactions
WHERE activity_id = ?
ORDER BY created_at DESC
LIMIT ? OFFSET ?;
```

#### Cache et Mise en Cache
```dart
class CacheService {
  static const Duration _defaultTTL = Duration(minutes: 5);

  Future<T> getOrSet<T>(
    String key,
    Future<T> Function() fetcher, {
    Duration ttl = _defaultTTL,
  }) async {
    final cached = await _getFromCache<T>(key);
    if (cached != null && !_isExpired(cached.timestamp, ttl)) {
      return cached.value;
    }

    final value = await fetcher();
    await _setCache(key, value);
    return value;
  }
}
```

#### Lazy Loading et Pagination
```dart
class PaginatedResult<T> {
  final List<T> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginatedResult({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });
}
```

## Déploiement et Maintenance

### Build et Package

#### Configuration Build
```yaml
# Windows
flutter:
  build:
    windows:
      target: windows/runner/main.cpp
      icon: windows/runner/resources/app_icon.ico

# macOS
flutter:
  build:
    macos:
      target: macos/Runner/MainFlutterWindow.swift
      icon: macos/Runner/Assets.xcassets/AppIcon.appiconset

# Linux
flutter:
  build:
    linux:
      target: linux/main.cc
      icon: linux/flutter/app_icon.png
```

#### Génération Installers
```bash
# Windows
flutter build windows --release
# Génère fintrack_pro.exe dans build/windows/runner/Release/

# macOS
flutter build macos --release
# Génère FinTrack Pro.app dans build/macos/Build/Products/Release/

# Linux
flutter build linux --release
# Génère bundle dans build/linux/x64/release/bundle/
```

### Procédures de Maintenance

#### Sauvegarde Automatique
```dart
class BackupService {
  Future<void> createBackup({
    required BackupType type,
    required String destination,
    bool compress = true,
    bool encrypt = true,
  }) async {
    // Création sauvegarde structurée
    // - Base de données
    // - Fichiers justificatifs
    // - Configuration utilisateur
    // - Logs d'audit
  }

  Future<void> restoreBackup(String backupPath) async {
    // Restauration complète
    // Vérification intégrité
    // Rollback en cas d'erreur
  }
}
```

#### Mise à Jour Automatique
```dart
class UpdateService {
  Future<UpdateInfo?> checkForUpdates() async {
    // Vérification nouvelles versions
    // Téléchargement en arrière-plan
    // Installation sans interruption
  }

  Future<void> applyUpdate(UpdateInfo update) async {
    // Sauvegarde pré-update
    // Installation update
    // Migration données si nécessaire
    // Redémarrage application
  }
}
```

### Monitoring et Observabilité

#### Métriques Collectées
- **Performance** : Temps réponse, utilisation CPU/mémoire
- **Usage** : Utilisateurs actifs, sessions concurrentes
- **Erreurs** : Taux d'erreur, types d'exceptions
- **Business** : Transactions créées, taux approbation

#### Alertes et Notifications
- **Critique** : Application indisponible, données corrompues
- **Important** : Performance dégradée, erreurs fréquentes
- **Info** : Mises à jour disponibles, seuils franchis

## Tests et Qualité

### Stratégie de Test

#### Tests Unitaires
```dart
// Test repository
void main() {
  group('TransactionRepository', () {
    late MockTransactionDataSource mockDataSource;
    late TransactionRepository repository;

    setUp(() {
      mockDataSource = MockTransactionDataSource();
      repository = TransactionRepositoryImpl(mockDataSource);
    });

    test('should return transactions when data source succeeds', () async {
      // Arrange
      final models = [transactionModel];
      when(mockDataSource.getTransactions(any))
          .thenAnswer((_) async => models);

      // Act
      final result = await repository.getTransactions('activity1');

      // Assert
      expect(result, hasLength(1));
      expect(result.first.id, equals(transactionModel.id));
    });
  });
}
```

#### Tests d'Intégration
```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('complete transaction workflow', (tester) async {
      // Initialisation app
      await tester.pumpWidget(const FinTrackApp());

      // Connexion
      await tester.enterText(find.byKey(loginEmailKey), 'admin@fintrack.pro');
      await tester.enterText(find.byKey(loginPasswordKey), 'password');
      await tester.tap(find.byKey(loginButtonKey));
      await tester.pumpAndSettle();

      // Création activité
      await tester.tap(find.byKey(createActivityButtonKey));
      await tester.enterText(find.byKey(activityNameKey), 'Test Activity');
      await tester.tap(find.byKey(saveActivityButtonKey));
      await tester.pumpAndSettle();

      // Saisie transaction
      await tester.tap(find.byKey(newTransactionButtonKey));
      await tester.enterText(find.byKey(amountKey), '100.50');
      await tester.enterText(find.byKey(descriptionKey), 'Test transaction');
      await tester.tap(find.byKey(saveTransactionButtonKey));
      await tester.pumpAndSettle();

      // Vérification
      expect(find.text('100.50'), findsOneWidget);
    });
  });
}
```

#### Tests de Performance
```dart
void main() {
  group('Performance Tests', () {
    test('should handle 1000 transactions efficiently', () async {
      final stopwatch = Stopwatch()..start();

      // Création 1000 transactions
      for (var i = 0; i < 1000; i++) {
        await repository.createTransaction(testTransaction);
      }

      stopwatch.stop();

      // Vérification performance
      expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // < 5 secondes
    });
  });
}
```

### Qualité Code

#### Analyse Statique
```yaml
# analysis_options.yaml
include: package:very_good_analysis/analysis_options.yaml

linter:
  rules:
    - always_declare_return_types
    - always_put_control_body_on_new_line
    - always_put_required_named_parameters_first
    - always_require_non_null_named_parameters
    - always_specify_types
    - annotate_overrides
    - avoid_annotating_with_dynamic
    - avoid_as
    - avoid_bool_literals_in_conditional_expressions
    - avoid_catches_without_on_clauses
    - avoid_catching_errors
    - avoid_classes_with_only_static_members
    - avoid_double_and_int_checks
    - avoid_dynamic_calls
    - avoid_empty_else
    - avoid_equals_and_hash_code_on_mutable_classes
    - avoid_escaping_inner_quotes
    - avoid_field_initializers_in_const_classes
    - avoid_final_parameters
    - avoid_function_literals_in_foreach_calls
    - avoid_implementing_value_types
    - avoid_init_to_null
    - avoid_js_rounded_ints
    - avoid_multiple_declarations_per_line
    - avoid_null_checks_in_equality_operators
    - avoid_positional_boolean_parameters
    - avoid_prefer_mixin
    - avoid_print
    - avoid_private_typedef_functions
    - avoid_redundant_argument_values
    - avoid_relative_lib_imports
    - avoid_renaming_method_parameters
    - avoid_return_types_on_setters
    - avoid_returning_null
    - avoid_returning_null_for_future
    - avoid_returning_null_for_void
    - avoid_returning_this
    - avoid_setters_without_getters
    - avoid_shadowing_type_parameters
    - avoid_single_cascade_in_expression_statements
    - avoid_slow_async_io
    - avoid_type_to_string
    - avoid_types_as_parameter_names
    - avoid_unnecessary_containers
    - avoid_unnecessary_getters
    - avoid_unnecessary_parenthesis
    - avoid_unnecessary_statements
    - avoid_unstable_final_fields
    - avoid_unused_constructor_parameters
    - avoid_void_async
    - avoid_web_libraries_in_flutter
    - await_only_futures
    - camel_case_extensions
    - camel_case_types
    - cancel_subscriptions
    - cascade_invocations
    - cast_nullable_to_non_nullable
    - close_sinks
    - comment_references
    - constant_identifier_names
    - control_flow_in_finally
    - curly_braces_in_flow_control_structures
    - depend_on_referenced_packages
    - deprecated_consistency
    - diagnostic_describe_all_properties
    - directives_ordering
    - do_not_use_environment
    - empty_catches
    - empty_constructor_bodies
    - empty_statements
    - eol_at_end_of_file
    - exhaustive_cases
    - file_names
    - flutter_style_todos
    - hash_and_equals
    - implementation_imports
    - implicit_call_tearoffs
    - implicit_reopen
    - invalid_case_patterns
    - join_return_with_assignment
    - leading_newlines_in_multiline_strings
    - library_names
    - library_prefixes
    - library_private_types_in_public_api
    - lines_longer_than_80_chars
    - list_remove_unrelated_type
    - literal_only_boolean_expressions
    - missing_whitespace_between_adjacent_strings
    - no_adjacent_strings_in_list
    - no_default_cases
    - no_duplicate_case_values
    - no_leading_underscores_for_library_prefixes
    - no_leading_underscores_for_local_identifiers
    - no_literal_bool_comparisons
    - no_logic_in_create_state
    - no_runtimeType_toString
    - no_wildcard_variable_uses
    - non_constant_identifier_names
    - noop_primitive_operations
    - null_check_on_nullable_type_annotation
    - null_closures
    - omit_local_variable_types
    - one_member_abstracts
    - only_throw_errors
    - overridden_fields
    - package_api_docs
    - package_names
    - package_prefixed_library_names
    - parameter_assignments
    - parameters_ordering
    - prefer_adjacent_string_concatenation
    - prefer_asserts_in_initializer_lists
    - prefer_asserts_with_message
    - prefer_bool_in_asserts
    - prefer_collection_literals
    - prefer_conditional_assignment
    - prefer_const_constructors
    - prefer_const_constructors_in_immutables
    - prefer_const_declarations
    - prefer_const_literals_to_create_immutables
    - prefer_constructors_over_static_methods
    - prefer_contains
    - prefer_double_quotes
    - prefer_equal_for_default_values
    - prefer_expression_function_bodies
    - prefer_final_fields
    - prefer_final_in_for_each
    - prefer_final_locals
    - prefer_final_parameters
    - prefer_for_elements_to_map_fromIterable
    - prefer_foreach
    - prefer_function_declarations_over_variables
    - prefer_generic_function_type_aliases
    - prefer_if_elements_to_conditional_expressions
    - prefer_if_null_operators
    - prefer_initializing_formals
    - prefer_inlined_adds
    - prefer_int_literals
    - prefer_interpolation_to_compose_strings
    - prefer_is_empty
    - prefer_is_not_empty
    - prefer_is_not_operator
    - prefer_iterable_whereType
    - prefer_mixin
    - prefer_named_bool_parameters
    - prefer_null_aware_method_calls
    - prefer_null_aware_operators
    - prefer_private_generics
    - prefer_relative_imports
    - prefer_single_quotes
    - prefer_spread_collections
    - prefer_static_class
    - prefer_typing_uninitialized_variables
    - prefer_void_to_null
    - provide_deprecation_message
    - public_member_api_docs
    - recursive_getters
    - require_trailing_commas
    - secure_pubspec_urls
    - sized_box_for_whitespace
    - sized_box_shrink_expand
    - slash_for_doc_comments
    - sort_child_properties_last
    - sort_constructors_first
    - sort_pub_dependencies
    - sort_unnamed_constructors_first
    - test_types_in_equals
    - throw_in_finally
    - tighten_type_of_initializing_formals
    - type_annotate_public_apis
    - type_init_formals
    - type_literal_in_constant_pattern
    - type_literal_in_constant_pattern
    - unawaited_futures
    - unnecessary_await_in_return
    - unnecessary_brace_in_string_interps
    - unnecessary_breaks
    - unnecessary_const
    - unnecessary_constructor_name
    - unnecessary_getters_setters
    - unnecessary_lambdas
    - unnecessary_late
    - unnecessary_library_directive
    - unnecessary_library_name
    - unnecessary_new
    - unnecessary_null_aware_assignments
    - unnecessary_null_aware_operator_on_extension_on_nullable
    - unnecessary_null_checks
    - unnecessary_null_in_if_null_operators
    - unnecessary_nullable_for_final_variable_declarations
    - unnecessary_overrides
    - unnecessary_parenthesis
    - unnecessary_raw_strings
    - unnecessary_statements
    - unnecessary_string_escapes
    - unnecessary_string_interpolations
    - unnecessary_this
    - unnecessary_to_list_in_spreads
    - unnecessary_type_check
    - use_build_context_synchronously
    - use_colored_box
    - use_decorated_box
    - use_enums
    - use_full_hex_values_for_flutter_colors
    - use_function_type_syntax_for_parameters
    - use_if_null_to_convert_nulls_to_bools
    - use_is_even_rather_than_modulo
    - use_is_odd_rather_than_modulo
    - use_key_in_widget_constructors
    - use_late_for_private_fields_and_variables
    - use_named_constants
    - use_raw_strings
    - use_rethrow_when_possible
    - use_setters_to_change_properties
    - use_string_buffers
    - use_string_in_part_of_directives
    - use_super_parameters
    - use_test_throws_matchers
    - use_to_and_as_if_applicable
    - use_trailing_comma
    - valid_regexps
    - void_checks
```

---

*FinTrack Pro v1.0 - Annexes Techniques - Mis à jour le 31/10/2025*
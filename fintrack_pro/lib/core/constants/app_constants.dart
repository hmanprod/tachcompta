// Constantes générales de l'application
class AppConstants {
  // Routes de l'application
  static const String routeLogin = '/login';
  static const String routeDashboard = '/dashboard';
  static const String routeActivities = '/activities';
  static const String routeTransactions = '/transactions';
  static const String routeUsers = '/users';

  // Dimensions
  static const double headerHeight = 80.0;
  static const double sidebarWidth = 280.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 10.0;
  static const double inputHeight = 48.0;

  // Pagination
  static const int defaultPageSize = 50;
  static const int maxPageSize = 100;

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration debounceTime = Duration(milliseconds: 300);
  static const Duration snackbarDuration = Duration(seconds: 3);

  // Animations
  static const Duration animationDuration = Duration(milliseconds: 250);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  // Breakpoints responsive (desktop)
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;

  // Limites
  static const int maxActivityNameLength = 100;
  static const int maxTransactionDescriptionLength = 255;
  static const int maxUserNameLength = 50;

  // Formats de date
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String monthYearFormat = 'MM/yyyy';

  // Formats de nombre
  static const String currencyFormat = '#,##0.00 €';
  static const String percentageFormat = '#0.0%';

  // Messages génériques
  static const String appName = 'FinTrack Pro';
  static const String loadingMessage = 'Chargement en cours...';
  static const String errorMessage = 'Une erreur est survenue';
  static const String noDataMessage = 'Aucune donnée disponible';

  // Rôles utilisateur
  static const String roleAdmin = 'admin';
  static const String roleAgent = 'agent';
  static const String roleUser = 'user';

  // Types d'activité
  static const String activityTypeMagasin = 'magasin';
  static const String activityTypeTransport = 'transport';
  static const String activityTypeAutre = 'autre';

  // Statuts d'activité
  static const String activityStatusActive = 'active';
  static const String activityStatusClosed = 'closed';
  static const String activityStatusSuspended = 'suspended';

  // Types de transaction
  static const String transactionTypeRecette = 'recette';
  static const String transactionTypeDepense = 'depense';

  // Statuts de transaction
  static const String transactionStatusPending = 'pending';
  static const String transactionStatusApproved = 'approved';
  static const String transactionStatusRejected = 'rejected';
  static const String transactionStatusCompleted = 'completed';

  // Types de notification
  static const String notificationTypeActivityClosed = 'activity_closed';
  static const String notificationTypeNewUser = 'new_user';
  static const String notificationTypePendingExpense = 'pending_expense';
  static const String notificationTypeAlertThreshold = 'alert_threshold';
}
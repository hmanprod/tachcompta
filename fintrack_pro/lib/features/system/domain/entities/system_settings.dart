import 'package:equatable/equatable.dart';

/// Entité de domaine pour les paramètres système
class SystemSettings extends Equatable {
  final GeneralSettings general;
  final SecuritySettings security;
  final NotificationSettings notifications;
  final FinancialSettings financial;
  final AuditSettings audit;

  const SystemSettings({
    required this.general,
    required this.security,
    required this.notifications,
    required this.financial,
    required this.audit,
  });

  /// Factory pour créer des paramètres par défaut
  factory SystemSettings.defaultSettings() {
    return SystemSettings(
      general: GeneralSettings.defaultSettings(),
      security: SecuritySettings.defaultSettings(),
      notifications: NotificationSettings.defaultSettings(),
      financial: FinancialSettings.defaultSettings(),
      audit: AuditSettings.defaultSettings(),
    );
  }

  /// Factory pour créer depuis JSON
  factory SystemSettings.fromJson(Map<String, dynamic> json) {
    return SystemSettings(
      general: GeneralSettings.fromJson(json['general'] ?? {}),
      security: SecuritySettings.fromJson(json['security'] ?? {}),
      notifications: NotificationSettings.fromJson(json['notifications'] ?? {}),
      financial: FinancialSettings.fromJson(json['financial'] ?? {}),
      audit: AuditSettings.fromJson(json['audit'] ?? {}),
    );
  }

  /// Convertit en JSON
  Map<String, dynamic> toJson() {
    return {
      'general': general.toJson(),
      'security': security.toJson(),
      'notifications': notifications.toJson(),
      'financial': financial.toJson(),
      'audit': audit.toJson(),
    };
  }

  /// Crée une copie avec des modifications
  SystemSettings copyWith({
    GeneralSettings? general,
    SecuritySettings? security,
    NotificationSettings? notifications,
    FinancialSettings? financial,
    AuditSettings? audit,
  }) {
    return SystemSettings(
      general: general ?? this.general,
      security: security ?? this.security,
      notifications: notifications ?? this.notifications,
      financial: financial ?? this.financial,
      audit: audit ?? this.audit,
    );
  }

  @override
  List<Object?> get props => [general, security, notifications, financial, audit];
}

/// Paramètres généraux du système
class GeneralSettings extends Equatable {
  final String companyName;
  final String? logoUrl;
  final String defaultCurrency;
  final String language;
  final String timezone;
  final DateTime maintenanceStart;
  final DateTime maintenanceEnd;
  final bool maintenanceMode;

  const GeneralSettings({
    required this.companyName,
    this.logoUrl,
    required this.defaultCurrency,
    required this.language,
    required this.timezone,
    required this.maintenanceStart,
    required this.maintenanceEnd,
    this.maintenanceMode = false,
  });

  /// Factory pour créer des paramètres par défaut
  factory GeneralSettings.defaultSettings() {
    final now = DateTime.now();
    return GeneralSettings(
      companyName: 'FinTrack Pro',
      logoUrl: null,
      defaultCurrency: 'EUR',
      language: 'fr',
      timezone: 'Europe/Paris',
      maintenanceStart: now,
      maintenanceEnd: now.add(const Duration(hours: 2)),
      maintenanceMode: false,
    );
  }

  factory GeneralSettings.fromJson(Map<String, dynamic> json) {
    return GeneralSettings(
      companyName: json['companyName'] ?? 'FinTrack Pro',
      logoUrl: json['logoUrl'],
      defaultCurrency: json['defaultCurrency'] ?? 'EUR',
      language: json['language'] ?? 'fr',
      timezone: json['timezone'] ?? 'Europe/Paris',
      maintenanceStart: DateTime.parse(json['maintenanceStart'] ?? DateTime.now().toIso8601String()),
      maintenanceEnd: DateTime.parse(json['maintenanceEnd'] ?? DateTime.now().add(const Duration(hours: 2)).toIso8601String()),
      maintenanceMode: json['maintenanceMode'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'logoUrl': logoUrl,
      'defaultCurrency': defaultCurrency,
      'language': language,
      'timezone': timezone,
      'maintenanceStart': maintenanceStart.toIso8601String(),
      'maintenanceEnd': maintenanceEnd.toIso8601String(),
      'maintenanceMode': maintenanceMode,
    };
  }

  GeneralSettings copyWith({
    String? companyName,
    String? logoUrl,
    String? defaultCurrency,
    String? language,
    String? timezone,
    DateTime? maintenanceStart,
    DateTime? maintenanceEnd,
    bool? maintenanceMode,
  }) {
    return GeneralSettings(
      companyName: companyName ?? this.companyName,
      logoUrl: logoUrl ?? this.logoUrl,
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      language: language ?? this.language,
      timezone: timezone ?? this.timezone,
      maintenanceStart: maintenanceStart ?? this.maintenanceStart,
      maintenanceEnd: maintenanceEnd ?? this.maintenanceEnd,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
    );
  }

  @override
  List<Object?> get props => [
    companyName,
    logoUrl,
    defaultCurrency,
    language,
    timezone,
    maintenanceStart,
    maintenanceEnd,
    maintenanceMode,
  ];
}

/// Paramètres de sécurité
class SecuritySettings extends Equatable {
  final int passwordMinLength;
  final bool passwordRequireSpecialChars;
  final bool passwordRequireNumbers;
  final int sessionTimeoutMinutes;
  final int maxLoginAttempts;
  final int lockoutDurationMinutes;
  final bool twoFactorEnabled;
  final bool forcePasswordChange;
  final int passwordExpirationDays;
  final bool auditLoginEnabled;
  final bool auditSensitiveActionsEnabled;

  const SecuritySettings({
    required this.passwordMinLength,
    required this.passwordRequireSpecialChars,
    required this.passwordRequireNumbers,
    required this.sessionTimeoutMinutes,
    required this.maxLoginAttempts,
    required this.lockoutDurationMinutes,
    required this.twoFactorEnabled,
    required this.forcePasswordChange,
    required this.passwordExpirationDays,
    required this.auditLoginEnabled,
    required this.auditSensitiveActionsEnabled,
  });

  factory SecuritySettings.defaultSettings() {
    return const SecuritySettings(
      passwordMinLength: 8,
      passwordRequireSpecialChars: true,
      passwordRequireNumbers: true,
      sessionTimeoutMinutes: 60,
      maxLoginAttempts: 5,
      lockoutDurationMinutes: 30,
      twoFactorEnabled: false,
      forcePasswordChange: false,
      passwordExpirationDays: 90,
      auditLoginEnabled: true,
      auditSensitiveActionsEnabled: true,
    );
  }

  factory SecuritySettings.fromJson(Map<String, dynamic> json) {
    return SecuritySettings(
      passwordMinLength: json['passwordMinLength'] ?? 8,
      passwordRequireSpecialChars: json['passwordRequireSpecialChars'] ?? true,
      passwordRequireNumbers: json['passwordRequireNumbers'] ?? true,
      sessionTimeoutMinutes: json['sessionTimeoutMinutes'] ?? 60,
      maxLoginAttempts: json['maxLoginAttempts'] ?? 5,
      lockoutDurationMinutes: json['lockoutDurationMinutes'] ?? 30,
      twoFactorEnabled: json['twoFactorEnabled'] ?? false,
      forcePasswordChange: json['forcePasswordChange'] ?? false,
      passwordExpirationDays: json['passwordExpirationDays'] ?? 90,
      auditLoginEnabled: json['auditLoginEnabled'] ?? true,
      auditSensitiveActionsEnabled: json['auditSensitiveActionsEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'passwordMinLength': passwordMinLength,
      'passwordRequireSpecialChars': passwordRequireSpecialChars,
      'passwordRequireNumbers': passwordRequireNumbers,
      'sessionTimeoutMinutes': sessionTimeoutMinutes,
      'maxLoginAttempts': maxLoginAttempts,
      'lockoutDurationMinutes': lockoutDurationMinutes,
      'twoFactorEnabled': twoFactorEnabled,
      'forcePasswordChange': forcePasswordChange,
      'passwordExpirationDays': passwordExpirationDays,
      'auditLoginEnabled': auditLoginEnabled,
      'auditSensitiveActionsEnabled': auditSensitiveActionsEnabled,
    };
  }

  SecuritySettings copyWith({
    int? passwordMinLength,
    bool? passwordRequireSpecialChars,
    bool? passwordRequireNumbers,
    int? sessionTimeoutMinutes,
    int? maxLoginAttempts,
    int? lockoutDurationMinutes,
    bool? twoFactorEnabled,
    bool? forcePasswordChange,
    int? passwordExpirationDays,
    bool? auditLoginEnabled,
    bool? auditSensitiveActionsEnabled,
  }) {
    return SecuritySettings(
      passwordMinLength: passwordMinLength ?? this.passwordMinLength,
      passwordRequireSpecialChars: passwordRequireSpecialChars ?? this.passwordRequireSpecialChars,
      passwordRequireNumbers: passwordRequireNumbers ?? this.passwordRequireNumbers,
      sessionTimeoutMinutes: sessionTimeoutMinutes ?? this.sessionTimeoutMinutes,
      maxLoginAttempts: maxLoginAttempts ?? this.maxLoginAttempts,
      lockoutDurationMinutes: lockoutDurationMinutes ?? this.lockoutDurationMinutes,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      forcePasswordChange: forcePasswordChange ?? this.forcePasswordChange,
      passwordExpirationDays: passwordExpirationDays ?? this.passwordExpirationDays,
      auditLoginEnabled: auditLoginEnabled ?? this.auditLoginEnabled,
      auditSensitiveActionsEnabled: auditSensitiveActionsEnabled ?? this.auditSensitiveActionsEnabled,
    );
  }

  @override
  List<Object?> get props => [
    passwordMinLength,
    passwordRequireSpecialChars,
    passwordRequireNumbers,
    sessionTimeoutMinutes,
    maxLoginAttempts,
    lockoutDurationMinutes,
    twoFactorEnabled,
    forcePasswordChange,
    passwordExpirationDays,
    auditLoginEnabled,
    auditSensitiveActionsEnabled,
  ];
}

/// Paramètres de notifications
class NotificationSettings extends Equatable {
  final bool emailEnabled;
  final bool pushEnabled;
  final bool smsEnabled;
  final String emailTemplate;
  final String smsTemplate;
  final bool notifyOnNewTransaction;
  final bool notifyOnTransactionApproval;
  final bool notifyOnTransactionRejection;
  final bool notifyOnActivityChange;
  final bool notifyOnUserAction;
  final List<String> adminEmails;

  const NotificationSettings({
    required this.emailEnabled,
    required this.pushEnabled,
    required this.smsEnabled,
    required this.emailTemplate,
    required this.smsTemplate,
    required this.notifyOnNewTransaction,
    required this.notifyOnTransactionApproval,
    required this.notifyOnTransactionRejection,
    required this.notifyOnActivityChange,
    required this.notifyOnUserAction,
    required this.adminEmails,
  });

  factory NotificationSettings.defaultSettings() {
    return const NotificationSettings(
      emailEnabled: true,
      pushEnabled: true,
      smsEnabled: false,
      emailTemplate: 'Bonjour {user},\n\n{notification}\n\nCordialement,\nFinTrack Pro',
      smsTemplate: 'FinTrack: {notification}',
      notifyOnNewTransaction: true,
      notifyOnTransactionApproval: true,
      notifyOnTransactionRejection: true,
      notifyOnActivityChange: true,
      notifyOnUserAction: true,
      adminEmails: [],
    );
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      emailEnabled: json['emailEnabled'] ?? true,
      pushEnabled: json['pushEnabled'] ?? true,
      smsEnabled: json['smsEnabled'] ?? false,
      emailTemplate: json['emailTemplate'] ?? 'Bonjour {user},\n\n{notification}\n\nCordialement,\nFinTrack Pro',
      smsTemplate: json['smsTemplate'] ?? 'FinTrack: {notification}',
      notifyOnNewTransaction: json['notifyOnNewTransaction'] ?? true,
      notifyOnTransactionApproval: json['notifyOnTransactionApproval'] ?? true,
      notifyOnTransactionRejection: json['notifyOnTransactionRejection'] ?? true,
      notifyOnActivityChange: json['notifyOnActivityChange'] ?? true,
      notifyOnUserAction: json['notifyOnUserAction'] ?? true,
      adminEmails: List<String>.from(json['adminEmails'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emailEnabled': emailEnabled,
      'pushEnabled': pushEnabled,
      'smsEnabled': smsEnabled,
      'emailTemplate': emailTemplate,
      'smsTemplate': smsTemplate,
      'notifyOnNewTransaction': notifyOnNewTransaction,
      'notifyOnTransactionApproval': notifyOnTransactionApproval,
      'notifyOnTransactionRejection': notifyOnTransactionRejection,
      'notifyOnActivityChange': notifyOnActivityChange,
      'notifyOnUserAction': notifyOnUserAction,
      'adminEmails': adminEmails,
    };
  }

  NotificationSettings copyWith({
    bool? emailEnabled,
    bool? pushEnabled,
    bool? smsEnabled,
    String? emailTemplate,
    String? smsTemplate,
    bool? notifyOnNewTransaction,
    bool? notifyOnTransactionApproval,
    bool? notifyOnTransactionRejection,
    bool? notifyOnActivityChange,
    bool? notifyOnUserAction,
    List<String>? adminEmails,
  }) {
    return NotificationSettings(
      emailEnabled: emailEnabled ?? this.emailEnabled,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      emailTemplate: emailTemplate ?? this.emailTemplate,
      smsTemplate: smsTemplate ?? this.smsTemplate,
      notifyOnNewTransaction: notifyOnNewTransaction ?? this.notifyOnNewTransaction,
      notifyOnTransactionApproval: notifyOnTransactionApproval ?? this.notifyOnTransactionApproval,
      notifyOnTransactionRejection: notifyOnTransactionRejection ?? this.notifyOnTransactionRejection,
      notifyOnActivityChange: notifyOnActivityChange ?? this.notifyOnActivityChange,
      notifyOnUserAction: notifyOnUserAction ?? this.notifyOnUserAction,
      adminEmails: adminEmails ?? this.adminEmails,
    );
  }

  @override
  List<Object?> get props => [
    emailEnabled,
    pushEnabled,
    smsEnabled,
    emailTemplate,
    smsTemplate,
    notifyOnNewTransaction,
    notifyOnTransactionApproval,
    notifyOnTransactionRejection,
    notifyOnActivityChange,
    notifyOnUserAction,
    adminEmails,
  ];
}

/// Paramètres financiers
class FinancialSettings extends Equatable {
  final double maxTransactionAmount;
  final double approvalThreshold;
  final int transactionRetentionDays;
  final bool autoApprovalEnabled;
  final double autoApprovalLimit;
  final List<String> restrictedCurrencies;
  final bool multiCurrencyEnabled;
  final double maxDailyTransactionAmount;
  final double maxMonthlyTransactionAmount;
  final int decimalPlaces;

  const FinancialSettings({
    required this.maxTransactionAmount,
    required this.approvalThreshold,
    required this.transactionRetentionDays,
    required this.autoApprovalEnabled,
    required this.autoApprovalLimit,
    required this.restrictedCurrencies,
    required this.multiCurrencyEnabled,
    required this.maxDailyTransactionAmount,
    required this.maxMonthlyTransactionAmount,
    required this.decimalPlaces,
  });

  factory FinancialSettings.defaultSettings() {
    return const FinancialSettings(
      maxTransactionAmount: 1000000.0,
      approvalThreshold: 5000.0,
      transactionRetentionDays: 365 * 7, // 7 ans
      autoApprovalEnabled: false,
      autoApprovalLimit: 1000.0,
      restrictedCurrencies: [],
      multiCurrencyEnabled: false,
      maxDailyTransactionAmount: 50000.0,
      maxMonthlyTransactionAmount: 500000.0,
      decimalPlaces: 2,
    );
  }

  factory FinancialSettings.fromJson(Map<String, dynamic> json) {
    return FinancialSettings(
      maxTransactionAmount: (json['maxTransactionAmount'] ?? 1000000.0).toDouble(),
      approvalThreshold: (json['approvalThreshold'] ?? 5000.0).toDouble(),
      transactionRetentionDays: json['transactionRetentionDays'] ?? 365 * 7,
      autoApprovalEnabled: json['autoApprovalEnabled'] ?? false,
      autoApprovalLimit: (json['autoApprovalLimit'] ?? 1000.0).toDouble(),
      restrictedCurrencies: List<String>.from(json['restrictedCurrencies'] ?? []),
      multiCurrencyEnabled: json['multiCurrencyEnabled'] ?? false,
      maxDailyTransactionAmount: (json['maxDailyTransactionAmount'] ?? 50000.0).toDouble(),
      maxMonthlyTransactionAmount: (json['maxMonthlyTransactionAmount'] ?? 500000.0).toDouble(),
      decimalPlaces: json['decimalPlaces'] ?? 2,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maxTransactionAmount': maxTransactionAmount,
      'approvalThreshold': approvalThreshold,
      'transactionRetentionDays': transactionRetentionDays,
      'autoApprovalEnabled': autoApprovalEnabled,
      'autoApprovalLimit': autoApprovalLimit,
      'restrictedCurrencies': restrictedCurrencies,
      'multiCurrencyEnabled': multiCurrencyEnabled,
      'maxDailyTransactionAmount': maxDailyTransactionAmount,
      'maxMonthlyTransactionAmount': maxMonthlyTransactionAmount,
      'decimalPlaces': decimalPlaces,
    };
  }

  FinancialSettings copyWith({
    double? maxTransactionAmount,
    double? approvalThreshold,
    int? transactionRetentionDays,
    bool? autoApprovalEnabled,
    double? autoApprovalLimit,
    List<String>? restrictedCurrencies,
    bool? multiCurrencyEnabled,
    double? maxDailyTransactionAmount,
    double? maxMonthlyTransactionAmount,
    int? decimalPlaces,
  }) {
    return FinancialSettings(
      maxTransactionAmount: maxTransactionAmount ?? this.maxTransactionAmount,
      approvalThreshold: approvalThreshold ?? this.approvalThreshold,
      transactionRetentionDays: transactionRetentionDays ?? this.transactionRetentionDays,
      autoApprovalEnabled: autoApprovalEnabled ?? this.autoApprovalEnabled,
      autoApprovalLimit: autoApprovalLimit ?? this.autoApprovalLimit,
      restrictedCurrencies: restrictedCurrencies ?? this.restrictedCurrencies,
      multiCurrencyEnabled: multiCurrencyEnabled ?? this.multiCurrencyEnabled,
      maxDailyTransactionAmount: maxDailyTransactionAmount ?? this.maxDailyTransactionAmount,
      maxMonthlyTransactionAmount: maxMonthlyTransactionAmount ?? this.maxMonthlyTransactionAmount,
      decimalPlaces: decimalPlaces ?? this.decimalPlaces,
    );
  }

  @override
  List<Object?> get props => [
    maxTransactionAmount,
    approvalThreshold,
    transactionRetentionDays,
    autoApprovalEnabled,
    autoApprovalLimit,
    restrictedCurrencies,
    multiCurrencyEnabled,
    maxDailyTransactionAmount,
    maxMonthlyTransactionAmount,
    decimalPlaces,
  ];
}

/// Paramètres d'audit
class AuditSettings extends Equatable {
  final bool enabled;
  final int retentionDays;
  final List<String> auditedActions;
  final bool logFailedLogins;
  final bool logSuccessfulLogins;
  final bool logPasswordChanges;
  final bool logUserModifications;
  final bool logTransactionModifications;
  final bool logSystemSettingsChanges;
  final String logLevel;

  const AuditSettings({
    required this.enabled,
    required this.retentionDays,
    required this.auditedActions,
    required this.logFailedLogins,
    required this.logSuccessfulLogins,
    required this.logPasswordChanges,
    required this.logUserModifications,
    required this.logTransactionModifications,
    required this.logSystemSettingsChanges,
    required this.logLevel,
  });

  factory AuditSettings.defaultSettings() {
    return const AuditSettings(
      enabled: true,
      retentionDays: 365 * 5, // 5 ans
      auditedActions: [
        'user.login',
        'user.logout',
        'user.create',
        'user.update',
        'user.delete',
        'transaction.create',
        'transaction.update',
        'transaction.approve',
        'transaction.reject',
        'activity.create',
        'activity.update',
        'activity.delete',
        'system.settings.update',
      ],
      logFailedLogins: true,
      logSuccessfulLogins: true,
      logPasswordChanges: true,
      logUserModifications: true,
      logTransactionModifications: true,
      logSystemSettingsChanges: true,
      logLevel: 'INFO',
    );
  }

  factory AuditSettings.fromJson(Map<String, dynamic> json) {
    return AuditSettings(
      enabled: json['enabled'] ?? true,
      retentionDays: json['retentionDays'] ?? 365 * 5,
      auditedActions: List<String>.from(json['auditedActions'] ?? [
        'user.login',
        'user.logout',
        'user.create',
        'user.update',
        'user.delete',
        'transaction.create',
        'transaction.update',
        'transaction.approve',
        'transaction.reject',
        'activity.create',
        'activity.update',
        'activity.delete',
        'system.settings.update',
      ]),
      logFailedLogins: json['logFailedLogins'] ?? true,
      logSuccessfulLogins: json['logSuccessfulLogins'] ?? true,
      logPasswordChanges: json['logPasswordChanges'] ?? true,
      logUserModifications: json['logUserModifications'] ?? true,
      logTransactionModifications: json['logTransactionModifications'] ?? true,
      logSystemSettingsChanges: json['logSystemSettingsChanges'] ?? true,
      logLevel: json['logLevel'] ?? 'INFO',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'retentionDays': retentionDays,
      'auditedActions': auditedActions,
      'logFailedLogins': logFailedLogins,
      'logSuccessfulLogins': logSuccessfulLogins,
      'logPasswordChanges': logPasswordChanges,
      'logUserModifications': logUserModifications,
      'logTransactionModifications': logTransactionModifications,
      'logSystemSettingsChanges': logSystemSettingsChanges,
      'logLevel': logLevel,
    };
  }

  AuditSettings copyWith({
    bool? enabled,
    int? retentionDays,
    List<String>? auditedActions,
    bool? logFailedLogins,
    bool? logSuccessfulLogins,
    bool? logPasswordChanges,
    bool? logUserModifications,
    bool? logTransactionModifications,
    bool? logSystemSettingsChanges,
    String? logLevel,
  }) {
    return AuditSettings(
      enabled: enabled ?? this.enabled,
      retentionDays: retentionDays ?? this.retentionDays,
      auditedActions: auditedActions ?? this.auditedActions,
      logFailedLogins: logFailedLogins ?? this.logFailedLogins,
      logSuccessfulLogins: logSuccessfulLogins ?? this.logSuccessfulLogins,
      logPasswordChanges: logPasswordChanges ?? this.logPasswordChanges,
      logUserModifications: logUserModifications ?? this.logUserModifications,
      logTransactionModifications: logTransactionModifications ?? this.logTransactionModifications,
      logSystemSettingsChanges: logSystemSettingsChanges ?? this.logSystemSettingsChanges,
      logLevel: logLevel ?? this.logLevel,
    );
  }

  @override
  List<Object?> get props => [
    enabled,
    retentionDays,
    auditedActions,
    logFailedLogins,
    logSuccessfulLogins,
    logPasswordChanges,
    logUserModifications,
    logTransactionModifications,
    logSystemSettingsChanges,
    logLevel,
  ];
}
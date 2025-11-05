import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' as drift;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:fintrack_pro/core/database/database.dart';
import 'package:fintrack_pro/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> login(String email, String password);
  Future<UserModel> register(String email, String password, String firstName, String lastName, String role);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<List<UserModel>> getAllUsers();
  Future<UserModel?> getUserById(String id);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String id);
  Future<bool> isUserLoggedIn();
  Future<String?> getStoredToken();
  Future<void> storeToken(String token);
  Future<void> clearToken();
  Future<void> storeSessionData(String key, String value);
  Future<String?> getSessionData(String key);
  Future<void> clearSessionData(String key);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final AppDatabase database;
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({
    required this.database,
    required this.sharedPreferences,
  });

  // Clés pour SharedPreferences
  static const String _tokenKey = 'auth_token';
  static const String _currentUserIdKey = 'current_user_id';
  static const String _sessionDataPrefix = 'session_';

  // Générateur d'UUID
  final Uuid _uuid = const Uuid();

  // Hashage du mot de passe avec SHA-256 + salt
  String _hashPassword(String password, String salt) {
    final key = utf8.encode(password + salt);
    final hash = sha256.convert(key);
    return hash.toString();
  }

  // Génération d'un salt aléatoire
  String _generateSalt() {
    return _uuid.v4();
  }

  // Création d'un token JWT simulé (simple pour ce prototype)
  String _generateToken(String userId) {
    final now = DateTime.now();
    final payload = {
      'userId': userId,
      'iat': now.millisecondsSinceEpoch ~/ 1000,
      'exp': (now.add(const Duration(hours: 24))).millisecondsSinceEpoch ~/ 1000,
    };
    final header = {'alg': 'HS256', 'typ': 'JWT'};
    final encodedHeader = base64Url.encode(utf8.encode(jsonEncode(header)));
    final encodedPayload = base64Url.encode(utf8.encode(jsonEncode(payload)));
    final signature = _hashPassword('$encodedHeader.$encodedPayload', 'fintrack_secret_key');
    return '$encodedHeader.$encodedPayload.$signature';
  }

  @override
  Future<UserModel?> login(String email, String password) async {
    // Recherche de l'utilisateur dans la base de données
    final userEntity = await (database.select(database.users)
          ..where((tbl) => tbl.email.equals(email)))
        .getSingleOrNull();

    if (userEntity == null) {
      return null;
    }

    // Extraction du salt et hash du mot de passe stocké
    // Format: salt:hash
    final storedPassword = userEntity.password;
    final parts = storedPassword.split(':');
    if (parts.length != 2) {
      return null;
    }

    final salt = parts[0];
    final storedHash = parts[1];
    final inputHash = _hashPassword(password, salt);

    if (inputHash != storedHash || !userEntity.isActive) {
      return null;
    }

    // Création du modèle utilisateur
    final userModel = UserModel.fromEntity(userEntity);

    // Génération et stockage du token
    final token = _generateToken(userModel.id);
    await storeToken(token);

    // Stockage de l'ID utilisateur courant
    await sharedPreferences.setString(_currentUserIdKey, userModel.id);

    return userModel;
  }

  @override
  Future<UserModel> register(String email, String password, String firstName, String lastName, String role) async {
    // Vérification si l'email existe déjà
    final existingUser = await (database.select(database.users)
          ..where((tbl) => tbl.email.equals(email)))
        .getSingleOrNull();

    if (existingUser != null) {
      throw Exception('Un utilisateur avec cet email existe déjà');
    }

    // Génération du salt et hashage du mot de passe
    final salt = _generateSalt();
    final hashedPassword = '$salt:${_hashPassword(password, salt)}';

    // Création de l'entité utilisateur
    final userId = _uuid.v4();
    final now = DateTime.now();

    // Insertion en base
    await database.into(database.users).insert(UsersCompanion(
          id: drift.Value(userId),
          email: drift.Value(email),
          password: drift.Value(hashedPassword),
          role: drift.Value(role),
          firstName: drift.Value(firstName),
          lastName: drift.Value(lastName),
          createdAt: drift.Value(now),
          updatedAt: drift.Value(now),
        ));

    // Récupération de l'utilisateur créé
    final createdUser = await (database.select(database.users)
          ..where((tbl) => tbl.email.equals(email)))
        .getSingle();

    return UserModel.fromEntity(createdUser);
  }

  @override
  Future<void> logout() async {
    await clearToken();
    await sharedPreferences.remove(_currentUserIdKey);

    // Nettoyage des données de session
    final keys = sharedPreferences.getKeys();
    for (final key in keys) {
      if (key.startsWith(_sessionDataPrefix)) {
        await sharedPreferences.remove(key);
      }
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final userId = sharedPreferences.getString(_currentUserIdKey);
    if (userId == null) {
      return null;
    }

    final userEntity = await (database.select(database.users)
          ..where((tbl) => tbl.id.equals(userId)))
        .getSingleOrNull();

    return userEntity != null ? UserModel.fromEntity(userEntity) : null;
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final userEntities = await database.select(database.users).get();
    return userEntities.map((entity) => UserModel.fromEntity(entity)).toList();
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    final userEntity = await (database.select(database.users)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    return userEntity != null ? UserModel.fromEntity(userEntity) : null;
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await (database.update(database.users)
          ..where((tbl) => tbl.id.equals(user.id)))
        .write(UsersCompanion(
              email: drift.Value(user.email),
              role: drift.Value(user.role),
              firstName: drift.Value(user.firstName),
              lastName: drift.Value(user.lastName),
              avatarUrl: drift.Value(user.avatarUrl),
              updatedAt: drift.Value(DateTime.now()),
              isActive: drift.Value(user.isActive),
            ));
  }

  @override
  Future<void> deleteUser(String id) async {
    await (database.delete(database.users)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final token = await getStoredToken();
    final userId = sharedPreferences.getString(_currentUserIdKey);
    return token != null && userId != null;
  }

  @override
  Future<String?> getStoredToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<void> storeToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  @override
  Future<void> clearToken() async {
    await sharedPreferences.remove(_tokenKey);
  }

  @override
  Future<void> storeSessionData(String key, String value) async {
    await sharedPreferences.setString('$_sessionDataPrefix$key', value);
  }

  @override
  Future<String?> getSessionData(String key) async {
    return sharedPreferences.getString('$_sessionDataPrefix$key');
  }

  @override
  Future<void> clearSessionData(String key) async {
    await sharedPreferences.remove('$_sessionDataPrefix$key');
  }
}
import 'package:fintrack_pro/core/utils/either.dart' as either;
import 'package:fintrack_pro/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:fintrack_pro/features/auth/data/models/user_model.dart';
import 'package:fintrack_pro/features/auth/domain/entities/user.dart';
import 'package:fintrack_pro/features/auth/domain/entities/auth_failure.dart';
import 'package:fintrack_pro/features/auth/domain/repositories/auth_repository.dart' as domain;

class AuthRepositoryImpl implements domain.AuthRepository {
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<either.Either<domain.AuthFailure, User>> login(String email, String password) async {
    try {
      final userModel = await localDataSource.login(email, password);
      if (userModel == null) {
        return either.Either.left(const domain.AuthFailure('Email ou mot de passe incorrect'));
      }
      return either.Either.right(userModel.toDomain());
    } catch (e) {
      return either.Either.left(domain.AuthFailure('Erreur lors de la connexion: ${e.toString()}'));
    }
  }

  @override
  Future<either.Either<domain.AuthFailure, User>> register(String email, String password, String firstName, String lastName, String role) async {
    try {
      final userModel = await localDataSource.register(email, password, firstName, lastName, role);
      return either.Either.right(userModel.toDomain());
    } catch (e) {
      return either.Either.left(domain.AuthFailure('Erreur lors de l\'inscription: ${e.toString()}'));
    }
  }

  @override
  Future<either.Either<domain.AuthFailure, void>> logout() async {
    try {
      await localDataSource.logout();
      return either.Either.right(null);
    } catch (e) {
      return either.Either.left(domain.AuthFailure('Erreur lors de la déconnexion: ${e.toString()}'));
    }
  }

  @override
  Future<either.Either<domain.AuthFailure, User?>> getCurrentUser() async {
    try {
      final userModel = await localDataSource.getCurrentUser();
      return either.Either.right(userModel?.toDomain());
    } catch (e) {
      return either.Either.left(domain.AuthFailure('Erreur lors de la récupération de l\'utilisateur: ${e.toString()}'));
    }
  }

  @override
  Future<either.Either<domain.AuthFailure, List<User>>> getAllUsers() async {
    try {
      final userModels = await localDataSource.getAllUsers();
      final users = userModels.map((model) => model.toDomain()).toList();
      return either.Either.right(users);
    } catch (e) {
      return either.Either.left(domain.AuthFailure('Erreur lors de la récupération des utilisateurs: ${e.toString()}'));
    }
  }

  @override
  Future<either.Either<domain.AuthFailure, User?>> getUserById(String id) async {
    try {
      final userModel = await localDataSource.getUserById(id);
      return either.Either.right(userModel?.toDomain());
    } catch (e) {
      return either.Either.left(domain.AuthFailure('Erreur lors de la récupération de l\'utilisateur: ${e.toString()}'));
    }
  }

  @override
  Future<either.Either<domain.AuthFailure, void>> updateUser(User user) async {
    try {
      final userModel = UserModel.fromDomain(user);
      await localDataSource.updateUser(userModel);
      return either.Either.right(null);
    } catch (e) {
      return either.Either.left(domain.AuthFailure('Erreur lors de la mise à jour de l\'utilisateur: ${e.toString()}'));
    }
  }

  @override
  Future<either.Either<domain.AuthFailure, void>> deleteUser(String id) async {
    try {
      await localDataSource.deleteUser(id);
      return either.Either.right(null);
    } catch (e) {
      return either.Either.left(domain.AuthFailure('Erreur lors de la suppression de l\'utilisateur: ${e.toString()}'));
    }
  }

  @override
  Future<either.Either<domain.AuthFailure, bool>> isUserLoggedIn() async {
    try {
      final isLoggedIn = await localDataSource.isUserLoggedIn();
      return either.Either.right(isLoggedIn);
    } catch (e) {
      return either.Either.left(domain.AuthFailure('Erreur lors de la vérification de la connexion: ${e.toString()}'));
    }
  }

  @override
  Future<either.Either<domain.AuthFailure, String?>> getStoredToken() async {
    try {
      final token = await localDataSource.getStoredToken();
      return either.Either.right(token);
    } catch (e) {
      return either.Either.left(domain.AuthFailure('Erreur lors de la récupération du token: ${e.toString()}'));
    }
  }

  @override
  Future<either.Either<domain.AuthFailure, void>> storeToken(String token) async {
    try {
      await localDataSource.storeToken(token);
      return either.Either.right(null);
    } catch (e) {
      return either.Either.left(domain.AuthFailure('Erreur lors du stockage du token: ${e.toString()}'));
    }
  }

  @override
  Future<either.Either<domain.AuthFailure, void>> clearToken() async {
    try {
      await localDataSource.clearToken();
      return either.Either.right(null);
    } catch (e) {
      return either.Either.left(domain.AuthFailure('Erreur lors de la suppression du token: ${e.toString()}'));
    }
  }

  @override
  Future<either.Either<domain.AuthFailure, void>> storeSessionData(String key, String value) async {
    try {
      await localDataSource.storeSessionData(key, value);
      return either.Either.right(null);
    } catch (e) {
      return either.Either.left(domain.AuthFailure('Erreur lors du stockage des données de session: ${e.toString()}'));
    }
  }

  @override
  Future<either.Either<domain.AuthFailure, String?>> getSessionData(String key) async {
    try {
      final value = await localDataSource.getSessionData(key);
      return either.Either.right(value);
    } catch (e) {
      return either.Either.left(domain.AuthFailure('Erreur lors de la récupération des données de session: ${e.toString()}'));
    }
  }

  @override
  Future<either.Either<domain.AuthFailure, void>> clearSessionData(String key) async {
    try {
      await localDataSource.clearSessionData(key);
      return either.Either.right(null);
    } catch (e) {
      return either.Either.left(domain.AuthFailure('Erreur lors de la suppression des données de session: ${e.toString()}'));
    }
  }
}
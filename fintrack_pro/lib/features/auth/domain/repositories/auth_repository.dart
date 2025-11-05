import 'package:fintrack_pro/core/utils/either.dart' as either;
import 'package:fintrack_pro/features/auth/domain/entities/user.dart';

class AuthFailure implements Exception {
  final String message;
  const AuthFailure(this.message);

  @override
  String toString() => 'AuthFailure: $message';
}

abstract class AuthRepository {
  Future<either.Either<AuthFailure, User>> login(String email, String password);
  Future<either.Either<AuthFailure, User>> register(String email, String password, String firstName, String lastName, String role);
  Future<either.Either<AuthFailure, void>> logout();
  Future<either.Either<AuthFailure, User?>> getCurrentUser();
  Future<either.Either<AuthFailure, List<User>>> getAllUsers();
  Future<either.Either<AuthFailure, User?>> getUserById(String id);
  Future<either.Either<AuthFailure, void>> updateUser(User user);
  Future<either.Either<AuthFailure, void>> deleteUser(String id);
  Future<either.Either<AuthFailure, bool>> isUserLoggedIn();
  Future<either.Either<AuthFailure, String?>> getStoredToken();
  Future<either.Either<AuthFailure, void>> storeToken(String token);
  Future<either.Either<AuthFailure, void>> clearToken();
  Future<either.Either<AuthFailure, void>> storeSessionData(String key, String value);
  Future<either.Either<AuthFailure, String?>> getSessionData(String key);
  Future<either.Either<AuthFailure, void>> clearSessionData(String key);
}

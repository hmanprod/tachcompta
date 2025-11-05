import 'package:fintrack_pro/core/utils/either.dart' as either;
import 'package:fintrack_pro/features/auth/domain/entities/user.dart';
import 'package:fintrack_pro/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  Future<either.Either<AuthFailure, User>> call(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return either.Either.left(const AuthFailure('Email et mot de passe sont requis'));
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return either.Either.left(const AuthFailure('Format d\'email invalide'));
    }

    if (password.length < 6) {
      return either.Either.left(const AuthFailure('Le mot de passe doit contenir au moins 6 caractères'));
    }

    return await repository.login(email, password);
  }
}
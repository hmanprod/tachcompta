import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fintrack_pro/core/utils/either.dart' as either;
import 'package:fintrack_pro/features/auth/domain/entities/user.dart';
import 'package:fintrack_pro/features/auth/domain/repositories/auth_repository.dart';
import 'package:fintrack_pro/features/auth/domain/usecases/login_usecase.dart';
import 'package:fintrack_pro/shared/providers/repository_providers.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final LoginUseCase _loginUseCase;

  AuthNotifier(this._authRepository, this._loginUseCase)
      : super(const AuthState()) {
    _initializeAuthState();
  }

  Future<void> _initializeAuthState() async {
    state = state.copyWith(isLoading: true);

    final result = await _authRepository.isUserLoggedIn();
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (isLoggedIn) {
        if (isLoggedIn == true) {
          _authRepository.getCurrentUser().then((userResult) {
            userResult.fold(
              (failure) => state = state.copyWith(
                isLoading: false,
                errorMessage: failure.message,
              ),
              (user) => state = state.copyWith(
                user: user,
                isAuthenticated: true,
                isLoading: false,
              ),
            );
          });
        } else {
          state = state.copyWith(isLoading: false);
        }
      },
    );
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _loginUseCase(email, password);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
        errorMessage: null,
      ),
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authRepository.logout();
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (_) => state = const AuthState(),
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// Providers
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginUseCase(authRepository);
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final loginUseCase = ref.watch(loginUseCaseProvider);
  return AuthNotifier(authRepository, loginUseCase);
});

// Convenience providers
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authNotifierProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).isAuthenticated;
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authNotifierProvider).errorMessage;
});
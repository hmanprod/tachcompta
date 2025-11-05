import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/dashboard/presentation/pages/main_dashboard_page.dart';
import '../features/activities/presentation/pages/activities_list_page.dart';
import '../features/transactions/presentation/pages/transaction_list_page.dart';
import '../features/users/presentation/pages/user_management_page.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

class AppRouter {
  static GoRouter createRouter(WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return GoRouter(
      initialLocation: authState.isAuthenticated ? '/dashboard' : '/login',
      redirect: (context, state) {
        final isAuthenticated = authState.isAuthenticated;
        final isGoingToLogin = state.matchedLocation == '/login';

        // Si l'utilisateur n'est pas authentifié et n'est pas sur la page de login
        if (!isAuthenticated && !isGoingToLogin) {
          return '/login';
        }

        // Si l'utilisateur est authentifié et est sur la page de login
        if (isAuthenticated && isGoingToLogin) {
          return '/dashboard';
        }

        // Pas de redirection nécessaire
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const MainDashboardPage(),
        ),
        GoRoute(
          path: '/activities',
          builder: (context, state) => const ActivitiesListPage(),
        ),
        GoRoute(
          path: '/transactions',
          builder: (context, state) => const TransactionListPage(),
        ),
        GoRoute(
          path: '/users',
          builder: (context, state) => const UserManagementPage(),
        ),
      ],
    );
  }
}
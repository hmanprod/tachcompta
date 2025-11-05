import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Extension pour accéder aux méthodes de navigation GoRouter depuis BuildContext
extension GoRouterExtension on BuildContext {
  /// Accès au router GoRouter
  GoRouter get goRouter => GoRouter.of(this);

  /// Navigation vers une route (remplace la pile)
  void go(String location, {Object? extra}) {
    goRouter.go(location, extra: extra);
  }

  /// Navigation vers une route (ajoute à la pile)
  void push(String location, {Object? extra}) {
    goRouter.push(location, extra: extra);
  }

  /// Retour en arrière
  void pop<T extends Object?>([T? result]) {
    goRouter.pop(result);
  }

  /// Remplacer la route actuelle
  void pushReplacement(String location, {Object? extra}) {
    goRouter.pushReplacement(location, extra: extra);
  }

  /// Vider la pile et aller à une route
  void goNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    goRouter.goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Push une route nommée
  void pushNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    goRouter.pushNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Vérifie si on peut revenir en arrière
  bool get canPop => goRouter.canPop();
}
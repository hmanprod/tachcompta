/// Classe Either pour gérer les résultats d'opérations avec succès ou échec.
/// Utilise le pattern Either pour représenter soit un succès (Right) soit un échec (Left).
class Either<L, R> {
  final L? left;
  final R? right;
  final bool isLeft;

  const Either._(this.left, this.right, this.isLeft);

  /// Crée un Either représentant un échec (côté gauche)
  factory Either.left(L value) => Either._(value, null, true);

  /// Crée un Either représentant un succès (côté droit)
  factory Either.right(R value) => Either._(null, value, false);

  /// Vérifie si c'est un succès
  bool get isRight => !isLeft;

  /// Applique une fonction selon le côté de l'Either
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) {
    return isLeft ? onLeft(left!) : onRight(right!);
  }

  /// Récupère la valeur d'échec (doit être appelée seulement si isLeft est true)
  L getLeft() => left!;

  /// Récupère la valeur de succès (doit être appelée seulement si isRight est true)
  R getRight() => right!;
}
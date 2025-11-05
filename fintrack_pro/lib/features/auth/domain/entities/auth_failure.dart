/// Représente une erreur d'authentification
class AuthFailure {
  final String message;

  const AuthFailure(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthFailure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'AuthFailure(message: $message)';
}
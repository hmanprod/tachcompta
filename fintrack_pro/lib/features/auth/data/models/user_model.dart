import 'package:fintrack_pro/features/auth/domain/entities/user.dart';

class UserModel {
  final String id;
  final String email;
  final String role;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  // Factory pour créer depuis UserEntity (Drift)
  factory UserModel.fromEntity(dynamic entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      role: entity.role,
      firstName: entity.firstName,
      lastName: entity.lastName,
      avatarUrl: entity.avatarUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isActive: entity.isActive,
    );
  }

  // Factory pour créer depuis User (Domaine)
  factory UserModel.fromDomain(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      role: user.role.value,
      firstName: user.firstName,
      lastName: user.lastName,
      avatarUrl: user.avatarUrl,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      isActive: user.isActive,
    );
  }

  // Méthode pour convertir en User (Domaine)
  User toDomain() {
    return User(
      id: id,
      email: email,
      role: UserRole.fromString(role),
      firstName: firstName,
      lastName: lastName,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
    );
  }

  // Méthode pour convertir en Map (pour Drift)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
    };
  }

  // Factory pour créer depuis Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      avatarUrl: map['avatarUrl'] as String?,
      createdAt: map['createdAt'] as DateTime,
      updatedAt: map['updatedAt'] as DateTime,
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? role,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.role == role &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.avatarUrl == avatarUrl &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      email,
      role,
      firstName,
      lastName,
      avatarUrl,
      createdAt,
      updatedAt,
      isActive,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, role: $role, firstName: $firstName, lastName: $lastName, avatarUrl: $avatarUrl, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive)';
  }
}
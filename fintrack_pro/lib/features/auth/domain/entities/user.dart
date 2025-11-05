import 'package:equatable/equatable.dart';

enum UserRole {
  admin('admin'),
  agent('agent'),
  user('user');

  const UserRole(this.value);
  final String value;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.user,
    );
  }
}

class User extends Equatable {
  final String id;
  final String email;
  final UserRole role;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const User({
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
  factory User.fromEntity(dynamic entity) {
    return User(
      id: entity.id,
      email: entity.email,
      role: UserRole.fromString(entity.role),
      firstName: entity.firstName,
      lastName: entity.lastName,
      avatarUrl: entity.avatarUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isActive: entity.isActive,
    );
  }

  // Méthode pour convertir en UserEntity
  dynamic toEntity() {
    return {
      'id': id,
      'email': email,
      'role': role.value,
      'firstName': firstName,
      'lastName': lastName,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
    };
  }

  User copyWith({
    String? id,
    String? email,
    UserRole? role,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return User(
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
  List<Object?> get props => [
    id,
    email,
    role,
    firstName,
    lastName,
    avatarUrl,
    createdAt,
    updatedAt,
    isActive,
  ];
}
import 'package:equatable/equatable.dart';

enum ActivityType {
  magasin('magasin'),
  transport('transport'),
  autre('autre');

  const ActivityType(this.value);
  final String value;

  static ActivityType fromString(String value) {
    return ActivityType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ActivityType.autre,
    );
  }
}

enum ActivityStatus {
  active('active'),
  closed('closed'),
  suspended('suspended');

  const ActivityStatus(this.value);
  final String value;

  static ActivityStatus fromString(String value) {
    return ActivityStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ActivityStatus.active,
    );
  }
}

class Activity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final ActivityType type;
  final ActivityStatus status;
  final String createdBy;
  final String? color;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? closedAt;

  const Activity({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.status,
    required this.createdBy,
    this.color,
    required this.createdAt,
    required this.updatedAt,
    this.closedAt,
  });

  // Factory pour créer depuis ActivityEntity (Drift)
  factory Activity.fromEntity(dynamic entity) {
    return Activity(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      type: ActivityType.fromString(entity.type),
      status: ActivityStatus.fromString(entity.status),
      createdBy: entity.createdBy,
      color: entity.color,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      closedAt: entity.closedAt,
    );
  }

  // Méthode pour convertir en ActivityEntity
  dynamic toEntity() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.value,
      'status': status.value,
      'createdBy': createdBy,
      'color': color,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'closedAt': closedAt,
    };
  }

  Activity copyWith({
    String? id,
    String? name,
    String? description,
    ActivityType? type,
    ActivityStatus? status,
    String? createdBy,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? closedAt,
  }) {
    return Activity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description,
      type: type ?? this.type,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      closedAt: closedAt ?? this.closedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    type,
    status,
    createdBy,
    color,
    createdAt,
    updatedAt,
    closedAt,
  ];
}
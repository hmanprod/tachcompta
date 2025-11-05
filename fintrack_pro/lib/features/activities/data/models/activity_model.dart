import 'package:fintrack_pro/features/activities/domain/entities/activity.dart';

class ActivityModel extends Activity {
  const ActivityModel({
    required super.id,
    required super.name,
    super.description,
    required super.type,
    required super.status,
    required super.createdBy,
    super.color,
    required super.createdAt,
    required super.updatedAt,
    super.closedAt,
  });

  // Factory pour créer depuis ActivityEntity (Drift)
  factory ActivityModel.fromEntity(dynamic entity) {
    return ActivityModel(
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

  // Factory pour créer depuis Activity (domaine)
  factory ActivityModel.fromDomain(Activity activity) {
    return ActivityModel(
      id: activity.id,
      name: activity.name,
      description: activity.description,
      type: activity.type,
      status: activity.status,
      createdBy: activity.createdBy,
      color: activity.color,
      createdAt: activity.createdAt,
      updatedAt: activity.updatedAt,
      closedAt: activity.closedAt,
    );
  }

  // Méthode pour convertir en entité Drift
  Map<String, dynamic> toEntityMap() {
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

  // Méthode pour obtenir l'entité domaine
  Activity toDomain() {
    return Activity(
      id: id,
      name: name,
      description: description,
      type: type,
      status: status,
      createdBy: createdBy,
      color: color,
      createdAt: createdAt,
      updatedAt: updatedAt,
      closedAt: closedAt,
    );
  }
}
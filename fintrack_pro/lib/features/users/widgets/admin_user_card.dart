import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fintrack_pro/features/users/data/models/admin_user_model.dart';
import 'package:fintrack_pro/features/auth/domain/entities/user.dart';
import 'package:fintrack_pro/styles/app_theme.dart';
import 'package:fintrack_pro/styles/text_styles.dart';
import 'package:fintrack_pro/core/constants/colors.dart' as app_colors;
import 'package:fintrack_pro/styles/text_styles.dart' as text_styles;
import 'package:fintrack_pro/core/constants/colors.dart' as colors;


/// Carte pour afficher un utilisateur dans l'interface d'administration
class AdminUserCard extends ConsumerWidget {
  final AdminUserModel user;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onResetPassword;
  final VoidCallback? onToggleStatus;

  const AdminUserCard({
    super.key,
    required this.user,
    this.onEdit,
    this.onDelete,
    this.onResetPassword,
    this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec avatar, nom et statut
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 24,
                  backgroundColor: app_colors.FinTrackColors.primary.withOpacity(0.1),
                  child: user.user.avatarUrl != null
                      ? ClipOval(
                          child: Image.network(
                            user.user.avatarUrl!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildAvatarFallback(),
                          ),
                        )
                      : _buildAvatarFallback(),
                ),
                const SizedBox(width: 12),

                // Informations principales
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: text_styles.FinTrackTextStyles.headlineMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.user.email,
                        style: text_styles.FinTrackTextStyles.bodyMedium.copyWith(
                          color: app_colors.FinTrackColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Badge de rôle
                _buildRoleBadge(),

                // Menu d'actions
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                      case 'reset_password':
                        onResetPassword?.call();
                        break;
                      case 'toggle_status':
                        onToggleStatus?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Modifier'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'reset_password',
                      child: Row(
                        children: [
                          Icon(Icons.lock_reset, size: 18),
                          SizedBox(width: 8),
                          Text('Réinitialiser MDP'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'toggle_status',
                      child: Row(
                        children: [
                          Icon(Icons.toggle_on, size: 18),
                          SizedBox(width: 8),
                          Text('Changer statut'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Supprimer', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Informations supplémentaires
            Row(
              children: [
                // Statut de connexion
                _buildStatusIndicator(),

                const SizedBox(width: 16),

                // Dernière connexion
                if (user.lastLogin != null)
                  Expanded(
                    child: Text(
                      'Dernière connexion: ${_formatDate(user.lastLogin!)}',
                      style: text_styles.FinTrackTextStyles.labelSmall.copyWith(
                        color: app_colors.FinTrackColors.textSecondary,
                      ),
                    ),
                  ),

                // Date de création
                Text(
                  'Créé le ${_formatDate(user.user.createdAt)}',
                  style: text_styles.FinTrackTextStyles.labelSmall.copyWith(
                    color: app_colors.FinTrackColors.textSecondary,
                  ),
                ),
              ],
            ),

            // Activités assignées (aperçu)
            if (user.assignedActivities.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: user.assignedActivities
                    .take(3)
                    .map((activityId) => Chip(
                          label: Text(
                            activityId,
                            style: text_styles.FinTrackTextStyles.labelSmall.copyWith(
                              color: app_colors.FinTrackColors.primary,
                            ),
                          ),
                          backgroundColor: app_colors.FinTrackColors.primary.withOpacity(0.1),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
              ),
              if (user.assignedActivities.length > 3)
                Text(
                  '+${user.assignedActivities.length - 3} autres',
                  style: text_styles.FinTrackTextStyles.labelSmall.copyWith(
                    color: app_colors.FinTrackColors.textSecondary,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Text(
      user.user.firstName[0].toUpperCase(),
      style: text_styles.FinTrackTextStyles.titleMedium.copyWith(
        color: app_colors.FinTrackColors.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildRoleBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getRoleColor(user.user.role),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getRoleLabel(user.user.role),
        style: text_styles.FinTrackTextStyles.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: user.user.isActive ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          user.user.isActive ? 'Actif' : 'Inactif',
          style: text_styles.FinTrackTextStyles.labelSmall.copyWith(
            color: user.user.isActive ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.red;
      case UserRole.agent:
        return Colors.blue;
      case UserRole.user:
        return Colors.green;
    }
  }

  String _getRoleLabel(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.agent:
        return 'Agent';
      case UserRole.user:
        return 'User';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year}';
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/buttons/fintrack_button.dart';
import '../../domain/entities/activity.dart';
import '../providers/activity_provider.dart';

class CreateActivityDialog extends ConsumerStatefulWidget {
  const CreateActivityDialog({super.key});

  @override
  ConsumerState<CreateActivityDialog> createState() => _CreateActivityDialogState();
}

class _CreateActivityDialogState extends ConsumerState<CreateActivityDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  ActivityType _selectedType = ActivityType.magasin;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final activity = Activity(
        id: '', // Sera généré par la base de données
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        type: _selectedType,
        status: ActivityStatus.active,
        createdBy: 'current-user-id', // TODO: Get from auth provider
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await ref.read(activityNotifierProvider.notifier).createActivity(activity);

      if (mounted) {
        result.fold(
          (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur: $error')),
            );
          },
          (createdActivity) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Activité créée avec succès')),
            );
            Navigator.of(context).pop();
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Row(
              children: [
                Icon(
                  Icons.business,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Nouvelle Activité',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Formulaire
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom de l'activité
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom de l\'activité *',
                      hintText: 'Ex: Magasin Central, Transport Express...',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Le nom est obligatoire';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description (optionnel)',
                      hintText: 'Description de l\'activité...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Type d'activité
                  DropdownButtonFormField<ActivityType>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Type d\'activité *',
                      border: OutlineInputBorder(),
                    ),
                    items: ActivityType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_getActivityTypeText(type)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedType = value);
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Boutons d'action
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                  child: const Text('Annuler'),
                ),
                const SizedBox(width: 12),
                FinTrackButton(
                  label: 'Créer',
                  isLoading: _isSubmitting,
                  onPressed: _isSubmitting ? null : _submitForm,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getActivityTypeText(ActivityType type) {
    switch (type) {
      case ActivityType.magasin:
        return 'Magasin';
      case ActivityType.transport:
        return 'Transport';
      case ActivityType.autre:
        return 'Autre';
    }
  }
}
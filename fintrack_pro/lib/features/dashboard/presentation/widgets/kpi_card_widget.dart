import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../styles/text_styles.dart';
import '../../data/models/kpi_model.dart';

class KpiCardWidget extends StatelessWidget {
  final KPIModel kpi;

  const KpiCardWidget({
    super.key,
    required this.kpi,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icône et titre
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getIconBackgroundColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconData(),
                    color: _getIconBackgroundColor(),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    kpi.title,
                    style: FinTrackTextStyles.titleMedium.copyWith(
                      color: FinTrackColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Valeur principale
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  _formatValue(),
                  style: FinTrackTextStyles.kpiNumber.copyWith(
                    color: FinTrackColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  kpi.unit,
                  style: FinTrackTextStyles.bodyMedium.copyWith(
                    color: FinTrackColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            // Pourcentage de changement
            if (kpi.percentageChange != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    _getTrendIcon(),
                    size: 16,
                    color: _getTrendColor(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${kpi.percentageChange!.abs().toStringAsFixed(1)}%',
                    style: _getTrendTextStyle(),
                  ),
                  if (kpi.previousValue != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      'vs ${_formatPreviousValue()}',
                      style: FinTrackTextStyles.bodySmall.copyWith(
                        color: FinTrackColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getIconBackgroundColor() {
    switch (kpi.type) {
      case KPIType.recettes:
      case KPIType.recettesEnAttente:
      case KPIType.recettesAcquises:
        return const Color(0xFF10B981); // success green
      case KPIType.depenses:
      case KPIType.depensesEnAttente:
      case KPIType.depensesAcquises:
        return const Color(0xFFEF4444); // error red
      case KPIType.resteACollecter:
      case KPIType.resteDisponible:
        return const Color(0xFFF59E0B); // warning orange
      case KPIType.soldeGlobal:
        return FinTrackColors.primary;
    }
  }

  IconData _getIconData() {
    switch (kpi.iconName) {
      case 'trending_up':
        return Icons.trending_up;
      case 'trending_down':
        return Icons.trending_down;
      case 'wallet':
        return Icons.account_balance_wallet;
      case 'clock':
        return Icons.schedule;
      case 'pending':
        return Icons.pending;
      case 'check_circle':
        return Icons.check_circle;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      default:
        return Icons.analytics;
    }
  }

  String _formatValue() {
    if (kpi.value >= 1000000) {
      return '${(kpi.value / 1000000).toStringAsFixed(1)}M';
    } else if (kpi.value >= 1000) {
      return '${(kpi.value / 1000).toStringAsFixed(1)}k';
    } else {
      return kpi.value.toStringAsFixed(kpi.value % 1 == 0 ? 0 : 2);
    }
  }

  String _formatPreviousValue() {
    if (kpi.previousValue == null) return '';

    if (kpi.previousValue! >= 1000000) {
      return '${(kpi.previousValue! / 1000000).toStringAsFixed(1)}M ${kpi.unit}';
    } else if (kpi.previousValue! >= 1000) {
      return '${(kpi.previousValue! / 1000).toStringAsFixed(1)}k ${kpi.unit}';
    } else {
      return '${kpi.previousValue!.toStringAsFixed(kpi.previousValue! % 1 == 0 ? 0 : 2)} ${kpi.unit}';
    }
  }

  IconData _getTrendIcon() {
    switch (kpi.trend) {
      case KPITrend.up:
        return Icons.arrow_upward;
      case KPITrend.down:
        return Icons.arrow_downward;
      case KPITrend.neutral:
        return Icons.remove;
    }
  }

  Color _getTrendColor() {
    switch (kpi.trend) {
      case KPITrend.up:
        return const Color(0xFF10B981); // success green
      case KPITrend.down:
        return const Color(0xFFEF4444); // error red
      case KPITrend.neutral:
        return FinTrackColors.textSecondary;
    }
  }

  TextStyle _getTrendTextStyle() {
    switch (kpi.trend) {
      case KPITrend.up:
        return FinTrackTextStyles.percentagePositive;
      case KPITrend.down:
        return FinTrackTextStyles.percentageNegative;
      case KPITrend.neutral:
        return FinTrackTextStyles.percentageNeutral;
    }
  }
}
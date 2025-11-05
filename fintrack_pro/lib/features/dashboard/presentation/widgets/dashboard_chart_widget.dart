import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../styles/text_styles.dart';
import '../../data/models/chart_data_model.dart';

class DashboardChartWidget extends StatelessWidget {
  final ChartDataModel chartData;
  final String title;

  const DashboardChartWidget({
    super.key,
    required this.chartData,
    this.title = 'Graphiques Financiers',
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
            // Titre
            Text(
              title,
              style: FinTrackTextStyles.headlineSmall.copyWith(
                color: FinTrackColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            // Contenu des graphiques
            SizedBox(
              height: 300,
              child: Row(
                children: [
                  // Graphique en secteurs (à gauche)
                  Expanded(
                    flex: 1,
                    child: _buildPieChart(),
                  ),

                  const SizedBox(width: 20),

                  // Graphique en barres (au centre)
                  Expanded(
                    flex: 2,
                    child: _buildBarChart(),
                  ),

                  const SizedBox(width: 20),

                  // Graphique linéaire (à droite)
                  Expanded(
                    flex: 2,
                    child: _buildLineChart(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    if (chartData.pieChartData.isEmpty) {
      return _buildEmptyChart('Répartition\nRecettes/Dépenses');
    }

    return Column(
      children: [
        Text(
          'Répartition',
          style: FinTrackTextStyles.titleSmall.copyWith(
            color: FinTrackColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Cercle simulé avec des segments
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.1),
                ),
                child: CustomPaint(
                  painter: _PieChartPainter(chartData.pieChartData),
                ),
              ),
              // Valeur au centre
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${chartData.pieChartData.fold<double>(0, (sum, item) => sum + item.value).toStringAsFixed(0)}€',
                    style: FinTrackTextStyles.currencyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Total',
                    style: FinTrackTextStyles.bodySmall.copyWith(
                      color: FinTrackColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Légende
        Column(
          children: chartData.pieChartData.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: item.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.label,
                    style: FinTrackTextStyles.bodySmall,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBarChart() {
    if (chartData.barChartData.isEmpty) {
      return _buildEmptyChart('Évolution Mensuelle');
    }

    return Column(
      children: [
        Text(
          'Évolution Mensuelle',
          style: FinTrackTextStyles.titleSmall.copyWith(
            color: FinTrackColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: CustomPaint(
            painter: _BarChartPainter(chartData.barChartData),
          ),
        ),
      ],
    );
  }

  Widget _buildLineChart() {
    if (chartData.lineChartData.isEmpty) {
      return _buildEmptyChart('Solde Cumulé');
    }

    return Column(
      children: [
        Text(
          'Solde Cumulé',
          style: FinTrackTextStyles.titleSmall.copyWith(
            color: FinTrackColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: CustomPaint(
            painter: _LineChartPainter(chartData.lineChartData),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyChart(String message) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bar_chart,
              size: 48,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: FinTrackTextStyles.bodySmall.copyWith(
                color: FinTrackColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Aucune donnée disponible',
              style: FinTrackTextStyles.bodySmall.copyWith(
                color: Colors.grey.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Peintre pour le graphique en secteurs
class _PieChartPainter extends CustomPainter {
  final List<PieChartDataPoint> data;

  _PieChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final total = data.fold<double>(0, (sum, item) => sum + item.value);
    if (total == 0) return;

    double startAngle = -90 * (3.14159 / 180); // Start from top

    for (final item in data) {
      final sweepAngle = (item.value / total) * 2 * 3.14159;

      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.fill;

      final rect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      );

      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Peintre pour le graphique en barres
class _BarChartPainter extends CustomPainter {
  final List<BarChartDataPoint> data;

  _BarChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxRecettes = data.map((d) => d.recettes).reduce((a, b) => a > b ? a : b);
    final maxDepenses = data.map((d) => d.depenses).reduce((a, b) => a > b ? a : b);
    final maxValue = maxRecettes > maxDepenses ? maxRecettes : maxDepenses;
    if (maxValue == 0) return;

    final barWidth = size.width / data.length * 0.8;
    final spacing = size.width / data.length * 0.2;

    for (int i = 0; i < data.length; i++) {
      final x = i * (barWidth + spacing) + spacing / 2;

      // Barre des recettes (verte)
      final recettesHeight = (data[i].recettes / maxValue) * size.height;
      final recettesPaint = Paint()
        ..color = const Color(0xFF10B981)
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromLTWH(x, size.height - recettesHeight, barWidth / 2, recettesHeight),
        recettesPaint,
      );

      // Barre des dépenses (rouge)
      final depensesHeight = (data[i].depenses / maxValue) * size.height;
      final depensesPaint = Paint()
        ..color = const Color(0xFFEF4444)
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromLTWH(x + barWidth / 2, size.height - depensesHeight, barWidth / 2, depensesHeight),
        depensesPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Peintre pour le graphique linéaire
class _LineChartPainter extends CustomPainter {
  final List<LineChartDataPoint> data;

  _LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final minValue = data.map((d) => d.value).reduce((a, b) => a < b ? a : b);
    final maxValue = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;
    if (range == 0) return;

    final path = Path();
    final paint = Paint()
      ..color = FinTrackColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - ((data[i].value - minValue) / range) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Point
      canvas.drawCircle(
        Offset(x, y),
        3,
        Paint()..color = FinTrackColors.primary,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
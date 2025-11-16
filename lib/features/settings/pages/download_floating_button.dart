import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/repositories/download_history_provider.dart';
import 'package:prophet_kacou/features/settings/pages/download_history_page.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class DownloadFloatingButton extends StatelessWidget {
  const DownloadFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadHistoryProvider>(
      builder: (context, provider, _) {
        if (provider.totalActiveDownloads == 0) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DownloadHistoryPage(),
                ),
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Cercle de progression animé
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CustomPaint(
                    painter: _CircularProgressPainter(
                      progress: _calculateAverageProgress(provider),
                      color: Colors.red,
                    ),
                  ),
                ),
                // Container principal
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.download_rounded,
                        color: pkpIndigo,
                        size: 20,
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${provider.totalActiveDownloads}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        );
      },
    );
  }

  double _calculateAverageProgress(DownloadHistoryProvider provider) {
    final inProgress = provider.inProgressDownloads;
    if (inProgress.isEmpty) return 0.0;

    double totalProgress = 0.0;
    for (var download in inProgress) {
      totalProgress += download.percent;
    }
    return totalProgress / inProgress.length / 100.0;
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Cercle de fond
    final bgPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(center, radius, bgPaint);

    // Arc de progression
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
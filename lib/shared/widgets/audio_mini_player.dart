import 'package:flutter/material.dart';
import 'package:prophet_kacou/core/providers/audio_player_provider.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AudioPlayerProvider>(context);

    if (provider.currentAudio == null || !provider.isMinimized) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: provider.expandPlayer,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Colors.orange.withOpacity(0.9),
              Colors.deepOrange.withOpacity(0.95),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (provider.isPlaying)
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(30, 30),
                    painter: _AudioWavePainter(
                      animationValue: _animationController.value,
                    ),
                  );
                },
              )
            else
              const Icon(
                Icons.music_note_rounded,
                color: Colors.white,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}

class _AudioWavePainter extends CustomPainter {
  final double animationValue;

  _AudioWavePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final bars = 5;
    final spacing = size.width / (bars + 1);
    final centerY = size.height / 2;

    for (int i = 0; i < bars; i++) {
      final x = spacing * (i + 1);
      final offset = (animationValue + (i * 0.2)) % 1.0;
      final height = (12 + (8 * (0.5 + 0.5 * (offset > 0.5 ? 1 - offset : offset) * 2)));
      
      canvas.drawLine(
        Offset(x, centerY - height / 2),
        Offset(x, centerY + height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_AudioWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
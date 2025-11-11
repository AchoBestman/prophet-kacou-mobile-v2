import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/play_mode.dart';
import 'package:prophet_kacou/core/providers/audio_player_provider.dart';
import 'package:provider/provider.dart';

class AudioPlayerWidget extends StatelessWidget {
  const AudioPlayerWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AudioPlayerProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (provider.currentAudio == null) {
      return const SizedBox.shrink();
    }
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? pkpDark : pkpSand,
        border: Border(top: BorderSide(color: pkpOcean, width: 2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Titre et contrôles
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    provider.currentAudio!.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(_getRepeatIcon(provider.repeatMode)),
                  onPressed: provider.toggleRepeatMode,
                  iconSize: 20,
                  color: pkpOcean,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => _showStopConfirmation(context, provider),
                  iconSize: 20,
                  color: pkpOcean,
                ),
              ],
            ),
          ),
          
          // Barre de progression
          Slider(
            value: provider.position.inSeconds.toDouble(),
            max: provider.duration.inSeconds.toDouble().clamp(1.0, double.infinity),
            onChanged: (value) {
              provider.seek(Duration(seconds: value.toInt()));
            },
            activeColor: pkpOcean,
          ),
          
          // Temps
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(provider.position),
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  _formatDuration(provider.duration),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          
          // Contrôles de lecture
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: provider.playPrevious,
                  iconSize: 32,
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: Icon(
                    provider.isPlaying ? Icons.pause_circle : Icons.play_circle,
                  ),
                  onPressed: provider.togglePlayPause,
                  iconSize: 48,
                  color: Colors.orange,
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: () => provider.playNext(),
                  iconSize: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  IconData _getRepeatIcon(PlayMode mode) {
    switch (mode) {
      case PlayMode.none:
        return Icons.repeat;
      case PlayMode.one:
        return Icons.repeat_one;
      case PlayMode.all:
        return Icons.repeat_on;
    }
  }
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
  
  void _showStopConfirmation(BuildContext context, AudioPlayerProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Arrêter la lecture'),
        content: const Text('Voulez-vous arrêter la lecture en cours ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              provider.stop();
              Navigator.pop(context);
            },
            child: const Text('Arrêter'),
          ),
        ],
      ),
    );
  }
}
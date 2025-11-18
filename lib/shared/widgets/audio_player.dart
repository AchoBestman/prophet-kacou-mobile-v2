import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/play_mode.dart';
import 'package:prophet_kacou/core/providers/audio_player_provider.dart';
import 'package:prophet_kacou/features/hymns/pages/audio_detail_page.dart';
import 'package:prophet_kacou/features/sermons/pages/sermon_detail_page.dart';
import 'package:provider/provider.dart';

class AudioPlayerWidget extends StatelessWidget {
  const AudioPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AudioPlayerProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (provider.currentAudio == null || provider.isMinimized) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? pkpDark : pkpLime,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    provider.currentAudio!.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildInfoButton(context, provider),

                if (provider.currentAudio!.localFullPath?.existsSync() == true)
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      provider.shareAudio(provider.currentAudio!);
                    },
                    iconSize: 20,
                    color: pkpOcean,
                    constraints:
                        const BoxConstraints(), // enlève les marges internes
                    padding: EdgeInsets.zero,
                  ),

                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onPressed: provider.minimizePlayer,
                  iconSize: 40,
                  constraints:
                      const BoxConstraints(), // enlève les marges internes
                  padding: EdgeInsets.zero,
                  color: pkpOcean,
                ),
              ],
            ),
          ),
          Slider(
            value: provider.position.inSeconds.toDouble(),
            max: provider.duration.inSeconds.toDouble().clamp(
              1.0,
              double.infinity,
            ),
            onChanged: (value) {
              provider.seek(Duration(seconds: value.toInt()));
            },
            activeColor: pkpOcean,
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(provider.position),
                  style: const TextStyle(fontSize: 13),
                ),
                Text(
                  _formatDuration(provider.duration),
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 2, top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  constraints:
                      const BoxConstraints(), // enlève les marges internes
                  padding: EdgeInsets.zero,
                  icon: Icon(_getRepeatIcon(provider.repeatMode)),
                  onPressed: provider.toggleRepeatMode,
                  iconSize: 25,
                  color: pkpOcean,
                ),
                IconButton(
                  constraints:
                      const BoxConstraints(), // enlève les marges internes
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.skip_previous),
                  onPressed: provider.playPrevious,
                  iconSize: 32,
                  color: pkpOcean,
                ),
                //const SizedBox(width: 16),
                IconButton(
                  constraints:
                      const BoxConstraints(), // enlève les marges internes
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    provider.isPlaying ? Icons.pause_circle : Icons.play_circle,
                  ),
                  onPressed: provider.togglePlayPause,
                  iconSize: 48,

                  color: pkpOcean,
                ),
                //const SizedBox(width: 16),
                IconButton(
                  constraints:
                      const BoxConstraints(), // enlève les marges internes
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.skip_next),
                  onPressed: () => provider.playNext(),
                  iconSize: 32,
                  color: pkpOcean,
                ),

                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => _showStopConfirmation(context, provider),
                  iconSize: 25,
                  color: pkpOcean,
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

  void _showStopConfirmation(
    BuildContext context,
    AudioPlayerProvider provider,
  ) {
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

  Widget _buildInfoButton(BuildContext context, AudioPlayerProvider provider) {
    final audio = provider.currentAudio;
    if (audio == null) return const SizedBox.shrink();

    final currentRoute = ModalRoute.of(context)?.settings.name;

    if (audio.albumId != null && audio.content != null) {
      if (currentRoute == AudioDetailPage.routeName) {
        return const SizedBox.shrink();
      }

      return IconButton(
        icon: const Icon(Icons.info_outline),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AudioDetailPage(audio: audio)),
          );
        },
        iconSize: 25,
        color: pkpOcean,
      );
    }

    if (audio.albumId == null && !audio.title.toUpperCase().contains("Kacou")) {
      if (currentRoute == SermonDetailPage.routeName) {
        return const SizedBox.shrink();
      }

      return IconButton(
        icon: const Icon(Icons.info_outline),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SermonDetailPage(sermonNumber: audio.id),
            ),
          );
        },
        iconSize: 25,
        color: pkpOcean,
      );
    }

    return const SizedBox.shrink();
  }
}

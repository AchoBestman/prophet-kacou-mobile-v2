import 'package:flutter/material.dart';
import 'package:prophet_kacou/core/providers/audio_player_provider.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AudioPlayerProvider>(context);

    if (provider.currentAudio == null || !provider.isMinimized) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: provider.expandPlayer,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.black.withOpacity(0.8),
        child: Row(
          children: [
            Icon(
              provider.isPlaying ? Icons.graphic_eq : Icons.music_note,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                provider.currentAudio!.title,
                style: const TextStyle(color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(
                provider.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: provider.togglePlayPause,
            ),
          ],
        ),
      ),
    );
  }
}

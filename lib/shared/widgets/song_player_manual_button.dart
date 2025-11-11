import 'package:flutter/material.dart';
import 'package:prophet_kacou/core/models/audio_item.dart';
import 'package:prophet_kacou/core/providers/audio_player_provider.dart';
import 'package:provider/provider.dart';

class SongPlayerManualButton extends StatelessWidget {
  final AudioItem audioItem;
  
  const SongPlayerManualButton({
    super.key,
    required this.audioItem,
  });
  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AudioPlayerProvider>(context);
    final isCurrentAudio = provider.currentAudioId == audioItem.id;
    final isPlaying = isCurrentAudio && provider.isPlaying;
    
    return IconButton(
      icon: Icon(
        isCurrentAudio && isPlaying
            ? Icons.pause_circle
            : Icons.play_circle,
        color: isCurrentAudio ? Colors.orange : Colors.blue,
      ),
      onPressed: () {
        if (isCurrentAudio) {
          provider.togglePlayPause();
        } else {
          provider.setAudio(audioItem, autoPlay: true);
        }
      },
    );
  }
}
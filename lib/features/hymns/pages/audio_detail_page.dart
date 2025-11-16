import 'package:flutter/material.dart';
import 'package:prophet_kacou/core/models/audio_item.dart';

class AudioDetailPage extends StatelessWidget {
  final AudioItem audio;

  const AudioDetailPage({super.key, required this.audio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(audio.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Titre : ${audio.title}"),
            const SizedBox(height: 10),
            Text("Album ID : ${audio.albumId}"),
            const SizedBox(height: 10),
            Text("URL : ${audio.audioUrl}"),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:prophet_kacou/core/models/audio_item.dart';
import 'package:prophet_kacou/core/models/play_mode.dart';

class AudioPlayerProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  AudioItem? _currentAudio;
  PlayMode _repeatMode = PlayMode.none;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  int? _firstAudioId;
  
  // Getters
  AudioPlayer get audioPlayer => _audioPlayer;
  AudioItem? get currentAudio => _currentAudio;
  PlayMode get repeatMode => _repeatMode;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get position => _position;
  String? get currentAudioUrl => _currentAudio?.audioUrl;
  int? get currentAudioId => _currentAudio?.id;
  int? get currentAlbumId => _currentAudio?.albumId;
  
  AudioPlayerProvider() {
    _initAudioPlayer();
  }
  
  void _initAudioPlayer() {
    // Écouter les changements de position
    _audioPlayer.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });
    
    // Écouter les changements de durée
    _audioPlayer.durationStream.listen((duration) {
      _duration = duration ?? Duration.zero;
      notifyListeners();
    });
    
    // Écouter l'état de lecture
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
      
      // Gérer la fin de la lecture
      if (state.processingState == ProcessingState.completed) {
        _handleAudioEnd();
      }
    });
  }
  
  Future<void> setAudio(AudioItem audio, {bool autoPlay = false}) async {
    try {
      _currentAudio = audio;
      
      if (_firstAudioId == null) {
        _firstAudioId = audio.id;
      }
      
      // Charger l'audio (local ou distant)
      await _audioPlayer.setUrl(audio.audioUrl);
      
      if (autoPlay) {
        await play();
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors du chargement audio: $e');
    }
  }
  
  Future<void> play() async {
    await _audioPlayer.play();
  }
  
  Future<void> pause() async {
    await _audioPlayer.pause();
  }
  
  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      await play();
    }
  }
  
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }
  
  void setRepeatMode(PlayMode mode) {
    _repeatMode = mode;
    notifyListeners();
  }
  
  void toggleRepeatMode() {
    switch (_repeatMode) {
      case PlayMode.none:
        _repeatMode = PlayMode.one;
        break;
      case PlayMode.one:
        _repeatMode = PlayMode.all;
        break;
      case PlayMode.all:
        _repeatMode = PlayMode.none;
        break;
    }
    notifyListeners();
  }
  
  Future<void> _handleAudioEnd() async {
    if (_repeatMode == PlayMode.one) {
      // Rejouer la même chanson
      await _audioPlayer.seek(Duration.zero);
      await play();
    } else if (_repeatMode == PlayMode.all) {
      // Passer au suivant (avec boucle)
      await playNext(shouldLoop: true);
    } else {
      // Passer au suivant (sans boucle)
      await playNext(shouldLoop: false);
    }
  }
  
  Future<void> playNext({bool shouldLoop = false}) async {
    if (_currentAudio == null) return;
    
    try {
      // TODO: Appeler votre API/repository pour obtenir la chanson suivante
      // final nextAudio = await _repository.findNext(
      //   currentId: _currentAudio!.id,
      //   albumId: _currentAudio!.albumId,
      //   firstAudioId: shouldLoop ? _firstAudioId : null,
      // );
      
      // Pour l'instant, simulation
      debugPrint('Lecture suivante...');
      
      // Exemple:
      // if (nextAudio != null) {
      //   await setAudio(nextAudio, autoPlay: true);
      // }
    } catch (e) {
      debugPrint('Erreur playNext: $e');
    }
  }
  
  Future<void> playPrevious() async {
    if (_currentAudio == null) return;
    
    try {
      // TODO: Appeler votre API/repository pour obtenir la chanson précédente
      // final prevAudio = await _repository.findPrevious(
      //   currentId: _currentAudio!.id,
      //   albumId: _currentAudio!.albumId,
      // );
      
      debugPrint('Lecture précédente...');
      
      // Exemple:
      // if (prevAudio != null) {
      //   await setAudio(prevAudio, autoPlay: true);
      // }
    } catch (e) {
      debugPrint('Erreur playPrevious: $e');
    }
  }
  
  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentAudio = null;
    _firstAudioId = null;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
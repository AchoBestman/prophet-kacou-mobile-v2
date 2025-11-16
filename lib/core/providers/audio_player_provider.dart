import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:prophet_kacou/core/models/audio_item.dart';
import 'package:prophet_kacou/core/models/play_mode.dart';
import 'package:prophet_kacou/core/utils/connection.dart';
import 'package:prophet_kacou/core/utils/notificaction.dart';
import 'package:share_plus/share_plus.dart';

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

  bool _isMinimized = false;
  bool get isMinimized => _isMinimized;

  AudioPlayerProvider() {
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _audioPlayer.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((duration) {
      _duration = duration ?? Duration.zero;
      notifyListeners();
    });

    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();

      if (state.processingState == ProcessingState.completed) {
        _handleAudioEnd();
      }
    });
  }

  Future<void> setAudio(
    BuildContext context,
    AudioItem audio, {
    bool autoPlay = false,
  }) async {
    try {
      if (!await ConnectionUtils.hasConnection() &&
          !await localFileExit(audio)) {
        if (context.mounted) ConnectionUtils.showNoConnectionMessage(context);
        return;
      }

      _currentAudio = audio;
      _firstAudioId ??= audio.id;

      if (await localFileExit(audio)) {
        await _audioPlayer.setFilePath(audio.localFullPath!.path);
      } else {
        await _audioPlayer.setUrl(audio.audioUrl);
      }

      if (autoPlay) {
        await play();
      }

      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        NotificactionService.showErrorMessage(
          context,
          'Erreur lors du chargement audio: $e',
        );
        stop();
      }
    }
  }

  Future<bool> localFileExit(AudioItem audio) async {
    if (audio.localFullPath == null) {
      return false;
    }
    return audio.localFullPath!.exists();
  }

  Future<void> shareAudio(AudioItem audio) async {
    if (await localFileExit(audio)) {
      await Share.shareXFiles(
        [XFile(audio.localFullPath!.path)],
        text: audio.title,
      );
    }
  }

  void minimizePlayer() {
    _isMinimized = true;
    notifyListeners();
  }

  void expandPlayer() {
    _isMinimized = false;
    notifyListeners();
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
      await _audioPlayer.seek(Duration.zero);
      await play();
    } else if (_repeatMode == PlayMode.all) {
      await playNext(shouldLoop: true);
    } else {
      await playNext(shouldLoop: false);
    }
  }

  Future<void> playNext({bool shouldLoop = false}) async {
    if (_currentAudio == null) return;

    try {
      debugPrint('Lecture suivante...');
    } catch (e) {
      debugPrint('Erreur playNext: $e');
    }
  }

  Future<void> playPrevious() async {
    if (_currentAudio == null) return;

    try {
      debugPrint('Lecture précédente...');
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
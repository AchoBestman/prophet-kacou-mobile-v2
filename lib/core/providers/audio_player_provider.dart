import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:prophet_kacou/core/models/audio_item.dart';
import 'package:prophet_kacou/core/models/play_mode.dart';
import 'package:prophet_kacou/core/models/sermon.dart';
import 'package:prophet_kacou/core/models/song.dart';
import 'package:prophet_kacou/core/repositories/download_history_provider.dart';
import 'package:prophet_kacou/core/repositories/song.dart';
import 'package:prophet_kacou/core/utils/connection.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/core/utils/notificaction.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:share_plus/share_plus.dart';

class AudioPlayerProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  BuildContext? _context;
  final DownloadHistoryProvider _historyProvider = DownloadHistoryProvider();
  final SongRepository _songRepository = SongRepository();

  AudioItem? _currentAudio;
  PlayMode _repeatMode = PlayMode.none;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  int? _firstAudioId;
  Sermon? _sermon;
  Song? _song;

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
    String? language,
  }) async {
    try {
      _context = context;

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
      await Share.shareXFiles([
        XFile(audio.localFullPath!.path),
      ], text: audio.title);
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
    if (_currentAudio == null || _context == null) return;

    try {
      final audioId = _currentAudio!.id;

      // Initialiser firstAudioId si nécessaire
      _firstAudioId ??= audioId;

      // Vérifier d'abord dans l'historique des téléchargements
      if (_currentAudio!.fileOriginalName != null) {
        final download = _historyProvider.getHistory(
          audioId,
          LookupHistooryMode.next,
          _repeatMode == PlayMode.all ? _firstAudioId : null,
        );

        if (download != null) {
          final audioItem = AudioItem(
            id: extractNumberValueFromAudioFormattedId(download.id),
            title: download.title,
            audioUrl: download.audioUrl,
            albumId: download.albumId,
            fileOriginalName: null,
            localFullPath: download.filePath,
            content: download.title,
          );
          await setAudio(_context!, audioItem, autoPlay: true);
          return;
        }
      }

      // Sinon, chercher dans la base de données

      final songMap = await _songRepository.findNextSong(
        lang: i18n.lang,
        id: audioId,
        albumId: _currentAudio!.albumId,
        firstAudioId: _repeatMode == PlayMode.all ? _firstAudioId : null,
      );

      if (songMap != null) {
        _song = songMap['album_id'] != null ? Song.fromMap(songMap) : null;
        _sermon = songMap['album_id'] == null ? Sermon.fromMap(songMap) : null;

        final String title = _sermon != null
            ? sermonTitleFormatter(_sermon!)
            : _song!.title;
        final File filePath = _sermon != null
            ? await localSermonPath(_sermon!, i18n.lang)
            : await localSongPath(_song!, i18n.lang);
        final int id = _sermon != null ? _sermon!.id : _song!.id;
        final int? albumId = _sermon != null ? null : _song!.albumId;
        final String? audioUrl = _sermon != null ? _sermon!.audio : _song!.audio;
        final String? content = _sermon != null ? _sermon!.title : _song!.content;

        final audioItem = AudioItem(
          id: id,
          title: title,
          audioUrl: audioUrl ?? "",
          albumId: albumId,
          fileOriginalName: null,
          localFullPath: filePath,
          content: content,
        );

        await setAudio(_context!, audioItem, autoPlay: true);
      }
      debugPrint('Lecture suivante...');
    } catch (e) {
      debugPrint('Erreur playNext: $e');
      if (_context != null && _context!.mounted) {
        NotificactionService.showErrorMessage(
          _context!,
          'Erreur lors de la lecture suivante: $e',
        );
      }
    }
  }

  Future<void> playPrevious() async {
    if (_currentAudio == null || _context == null) return;

    try {
      final audioId = _currentAudio!.id;

      // Vérifier d'abord dans l'historique des téléchargements
      if (_currentAudio!.fileOriginalName != null) {
        final download = _historyProvider.getHistory(
          audioId,
          LookupHistooryMode.previous,
          null,
        );

        if (download != null) {
          final audioItem = AudioItem(
            id: extractNumberValueFromAudioFormattedId(download.id),
            title: download.title,
            audioUrl: download.audioUrl,
            albumId: download.albumId,
            fileOriginalName: null,
            localFullPath: download.filePath,
            content: download.title,
          );
          await setAudio(_context!, audioItem, autoPlay: true);
          return;
        }
      }

      // Sinon, chercher dans la base de données

      final songMap = await _songRepository.findPreviousSong(
        lang: i18n.lang,
        id: audioId,
        albumId: _currentAudio!.albumId,
      );

      if (songMap != null) {
        _song = songMap['album_id'] != null ? Song.fromMap(songMap) : null;
        _sermon = songMap['album_id'] == null ? Sermon.fromMap(songMap) : null;

         final String title = _sermon != null
            ? sermonTitleFormatter(_sermon!)
            : _song!.title;
        final File filePath = _sermon != null
            ? await localSermonPath(_sermon!, i18n.lang)
            : await localSongPath(_song!, i18n.lang);
        final int id = _sermon != null ? _sermon!.id : _song!.id;
        final int? albumId = _sermon != null ? null : _song!.albumId;
        final String? audioUrl = _sermon != null ? _sermon!.audio : _song!.audio;
        final String? content = _sermon != null ? _sermon!.title : _song!.content;

        final audioItem = AudioItem(
          id: id,
          title: title,
          audioUrl: audioUrl ?? "",
          albumId: albumId,
          fileOriginalName: null,
          localFullPath: filePath,
          content: content,
        );

        await setAudio(_context!, audioItem, autoPlay: true);
      }

      debugPrint('Lecture précédente...');
    } catch (e) {
      debugPrint('Erreur playPrevious: $e');
      if (_context != null && _context!.mounted) {
        NotificactionService.showErrorMessage(
          _context!,
          'Erreur lors de la lecture précédente: $e',
        );
      }
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

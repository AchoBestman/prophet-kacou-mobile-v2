import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:prophet_kacou/core/models/download_progress.dart';

class DownloadManager {
  static final DownloadManager _instance = DownloadManager._internal();
  factory DownloadManager() => _instance;

  final Dio _dio = Dio();
  final Map<String, CancelToken> _tasks = {};
  final Map<String, StreamController<DownloadProgress>> _controllers = {};

  DownloadManager._internal();

  /// Retourne un flux spécifique pour un téléchargement donné
  Stream<DownloadProgress> progressStream(String id) {
    if (!_controllers.containsKey(id)) {
      _controllers[id] = StreamController<DownloadProgress>.broadcast();
    }
    return _controllers[id]!.stream;
  }

  Future<DownloadProgress> download({
    required String id,
    required String url,
    required File fileFullPath,
  }) async {
    // Éviter les doublons
    if (_tasks.containsKey(id)) {
      throw Exception('Download already in progress for id: $id');
    }

    final cancelToken = CancelToken();
    _tasks[id] = cancelToken;

    final tempPath = "${fileFullPath.path}.tmp";

    try {
      await fileFullPath.parent.create(recursive: true);
      int received = 0;
      int total = 0;

      await _dio.download(
        url,
        tempPath,
        cancelToken: cancelToken,
        onReceiveProgress: (count, totalBytes) {
          received = count;
          total = totalBytes;
          final percent = totalBytes > 0 ? (count / totalBytes) * 100.0 : 0.0;

          _controllers[id]?.add(
            DownloadProgress(
              id: id,
              filePath: fileFullPath.path,
              percent: percent,
              downloadedMb: count / (1024 * 1024),
              totalMb: totalBytes / (1024 * 1024),
              status: DownloadStatus.downloading,
            ),
          );
        },
      );

      if (cancelToken.isCancelled) {
        await File(tempPath).delete().catchError((_) {});
        final cancelled = DownloadProgress(
          id: id,
          filePath: fileFullPath.path,
          percent: (received / (total == 0 ? 1 : total)) * 100.0,
          downloadedMb: received / (1024 * 1024),
          totalMb: total / (1024 * 1024),
          status: DownloadStatus.cancelled,
        );
        _controllers[id]?.add(cancelled);
        // NE PAS fermer le controller ici
        throw Exception('Cancelled');
      }

      await File(tempPath).rename(fileFullPath.path);

      final completed = DownloadProgress(
        id: id,
        filePath: fileFullPath.path,
        percent: 100.0,
        downloadedMb: total / (1024 * 1024),
        totalMb: total / (1024 * 1024),
        status: DownloadStatus.completed,
      );
      _controllers[id]?.add(completed);

      // Fermer et nettoyer seulement après succès
      await Future.delayed(const Duration(milliseconds: 100));
      await _controllers[id]?.close();
      _controllers.remove(id);
      _tasks.remove(id);

      return completed;
    } catch (e) {
      final failed = DownloadProgress(
        id: id,
        filePath: fileFullPath.path,
        percent: 0.0,
        downloadedMb: 0.0,
        totalMb: 0.0,
        status: DownloadStatus.failed,
        error: e.toString(),
      );
      _controllers[id]?.add(failed);

      // Fermer et nettoyer seulement après échec
      await Future.delayed(const Duration(milliseconds: 100));
      await _controllers[id]?.close();
      _controllers.remove(id);
      _tasks.remove(id);

      rethrow;
    }
    // Le bloc finally a été supprimé pour éviter la fermeture prématurée
  }

  bool cancel(String id) {
    final token = _tasks[id];
    if (token != null && !token.isCancelled) {
      token.cancel();
      return true;
    }
    return false;
  }

  void dispose() {
    // Annuler tous les téléchargements en cours
    for (var token in _tasks.values) {
      if (!token.isCancelled) {
        token.cancel();
      }
    }
    _tasks.clear();

    // Fermer tous les controllers
    for (var c in _controllers.values) {
      c.close();
    }
    _controllers.clear();
  }
}

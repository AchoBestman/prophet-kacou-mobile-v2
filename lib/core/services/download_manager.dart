import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

enum DownloadStatus { downloading, completed, failed, cancelled }

class DownloadProgress {
  final String id;
  final String filePath;
  final double percent;
  final double downloadedMb;
  final double totalMb;
  final DownloadStatus status;
  final String? error;

  DownloadProgress({
    required this.id,
    required this.filePath,
    required this.percent,
    required this.downloadedMb,
    required this.totalMb,
    required this.status,
    this.error,
  });
}

/// Service global pour gérer les téléchargements (avec annulation)
class DownloadManager {
  static final DownloadManager _instance = DownloadManager._internal();
  factory DownloadManager() => _instance;

  final Dio _dio = Dio();
  final Map<String, CancelToken> _tasks = {};
  final StreamController<DownloadProgress> _progressController =
      StreamController.broadcast();

  DownloadManager._internal();

  Stream<DownloadProgress> get progressStream => _progressController.stream;

  /// Télécharge un fichier audio
  Future<DownloadProgress> download({
    required String id,
    required String url,
    required String fileFullPath,
  }) async {
    final cancelToken = CancelToken();
    _tasks[id] = cancelToken;

    final file = File(fileFullPath);
    final tempPath = "${file.path}.tmp";

    try {
      // Créer le répertoire si nécessaire
      await file.parent.create(recursive: true);

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
          _progressController.add(
            DownloadProgress(
              id: id,
              filePath: file.path,
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
        _progressController.add(
          DownloadProgress(
            id: id,
            filePath: file.path,
            percent: (received / (total == 0 ? 1 : total)) * 100.0,
            downloadedMb: received / (1024 * 1024),
            totalMb: total / (1024 * 1024),
            status: DownloadStatus.cancelled,
          ),
        );
        throw Exception('Cancelled');
      }

      // Remplacer le fichier final
      final tempFile = File(tempPath);
      await tempFile.rename(file.path);

      final completedProgress = DownloadProgress(
        id: id,
        filePath: file.path,
        percent: 100.0,
        downloadedMb: total / (1024 * 1024),
        totalMb: total / (1024 * 1024),
        status: DownloadStatus.completed,
      );
      _progressController.add(completedProgress);
      _tasks.remove(id);
      return completedProgress;
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        // Déjà traité
      } else {
        _progressController.add(
          DownloadProgress(
            id: id,
            filePath: file.path,
            percent: 0.0,
            downloadedMb: 0.0,
            totalMb: 0.0,
            status: DownloadStatus.failed,
            error: e.toString(),
          ),
        );
      }
      rethrow;
    } finally {
      _tasks.remove(id);
    }
  }

  /// Annule un téléchargement
  bool cancel(String id) {
    final token = _tasks[id];
    if (token != null && !token.isCancelled) {
      token.cancel();
      _tasks.remove(id);
      return true;
    }
    return false;
  }

  /// Nettoie les ressources
  void dispose() {
    _progressController.close();
    _tasks.clear();
  }
}

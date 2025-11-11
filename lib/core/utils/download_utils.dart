import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prophet_kacou/core/models/download_progress.dart';
import 'package:prophet_kacou/core/models/play_mode.dart';
import 'package:prophet_kacou/core/services/download_manager.dart' hide DownloadProgress;

class DownloadUtils {
  /// 🔹 Crée le chemin complet du fichier avant téléchargement
static Future<String> createPaths(
  String initial,
  AudioFolder subFolder,
  String fileName,
  FileExtension extension,
) async {
  if (!RegExp(r'^[A-Za-z]{2}-[A-Za-z]{2,4}$').hasMatch(initial)) {
    throw Exception('Invalid format: $initial must be in format AA-AA{BC}');
  }

  final cleanFileName = fileName.replaceAll(
    RegExp('\\.${extension.label}\$', caseSensitive: false),
    '',
  );

  final parts = initial.toLowerCase().split('-');
  final country = parts[0];
  final langue = parts[1];

  final downloadsDir = await getDownloadsDirectory();
  const basePath = 'Philippekacou';

  final subFolderName = subFolder.label;
  final fileExt = extension.label;

  String filePath;
  if (subFolder == AudioFolder.hymns) {
    filePath = '$basePath/$subFolderName/$cleanFileName.$fileExt';
  } else {
    filePath = '$basePath/$subFolderName/$country/$langue/$cleanFileName.$fileExt';
  }

  // Créer les répertoires manquants
  final fullPath = '${downloadsDir?.path}/$filePath';
  final directory = Directory(fullPath).parent;
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  return fullPath; // retourne le chemin complet absolu
}

  /// 🔹 Télécharge un fichier et notifie la progression
  static Future<void> startDownload(
    int modelId,
    String url,
    String fileFullPath,
    Function(DownloadProgress) onProgress,
  ) async {
    final id = modelId.toString();
    final manager = DownloadManager();

    // S'abonner au flux global de progression
    final subscription = manager.progressStream.listen((progress) {
      if (progress.id == id) {
        onProgress(
          DownloadProgress(
            percent: progress.percent,
            downloadSize: progress.downloadedMb,
            totalSize: progress.totalMb,
          ),
        );
      }
    });

    try {
      await manager.download(
        id: id,
        url: url,
        fileFullPath: fileFullPath,
      );
    } catch (e) {
      debugPrint('Download error: $e');
    } finally {
      await subscription.cancel();
    }
  }

  /// 🔹 Annule un téléchargement en cours
  static Future<bool> cancelDownload(int modelId) async {
    final id = modelId.toString();
    final manager = DownloadManager();
    final result = manager.cancel(id);
    if (!result) {
      debugPrint('❌ Aucun téléchargement trouvé pour ID: $id');
    }
    return result;
  }

  
}

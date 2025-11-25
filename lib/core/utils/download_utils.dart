import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:prophet_kacou/core/constants/app_strings.dart';
import 'package:prophet_kacou/core/models/download_progress.dart';
import 'package:prophet_kacou/core/models/play_mode.dart';
import 'package:prophet_kacou/core/services/download_manager.dart';
import 'package:prophet_kacou/core/utils/connection.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/core/utils/langues.dart';
import 'package:prophet_kacou/core/utils/notificaction.dart';
import 'package:prophet_kacou/core/utils/path_utils.dart';

class DownloadUtils {
  static final DownloadManager _downloadManager = DownloadManager();
  static final Map<String, StreamSubscription> _subscriptions = {};

  /// Crée le chemin complet du fichier
  static Future<String> createPaths(
    String initial,
    AudioFolder subFolder,
    String fileName,
    FileExtension extension,
  ) async {
    final downloadsDir = await PathUtils.getDownloadDir();

    final cleanFileName = cleanAndSlugifyFileName(fileName, extension.label);

    final fullPath = subFolder == AudioFolder.hymns
        ? '${downloadsDir.path}/${subFolder.label}/$cleanFileName.${extension.label}'
        : '${downloadsDir.path}/${subFolder.label}/${extractLangueCode(initial)}/${extractLangueCode(initial)}/$cleanFileName.${extension.label}';

    final directory = Directory(fullPath).parent;
    if (!await directory.exists()) await directory.create(recursive: true);

    return fullPath;
  }

  /// Obtenir le lien de téléchargement
  static Future<String?> getDownloadUrl(
    BuildContext? context,
    String initial,
  ) async {
    try {
      final response = await Dio().get(
        '${AppStrings.apiUrl}/$initial/download-url',
      );
      if (response.statusCode == 200 && response.data != null) {
        return response.data['download_url'];
      }
    } catch (e) {
      if (context != null && context.mounted) {
        NotificactionService.showErrorMessage(context, 'Erreur: $e');
      }
    }
    return null;
  }

  /// Démarrer un téléchargement
  static Future<void> startDownload(
    BuildContext context,
    String initial,
    File filePath,
    String? url, {
    required void Function(DownloadProgress) onProgress,
    required void Function() onCompleted,
    required void Function(String error) onError,
  }) async {
    if (!await ConnectionUtils.hasConnection()) {
      if (context.mounted) ConnectionUtils.showNoConnectionMessage(context);
      return;
    }
    if(!context.mounted) return;
    
    dynamic downloadUrl = await getDownloadUrl(context, initial);
    dynamic appDir = await PathUtils.getDatabaseRootDir();

    if (url != null) {
      downloadUrl = url;
      appDir = await PathUtils.getDownloadDir();
    }
    if (downloadUrl == null) return;

    final fullPath = File('${appDir.path}/${filePath.path}');

    final subscription = _downloadManager.progressStream(initial).listen((
      progress,
    ) {
      switch (progress.status) {
        case DownloadStatus.completed:
          onCompleted();
          _subscriptions[initial]?.cancel();
          _subscriptions.remove(initial);
          break;
        case DownloadStatus.failed:
        case DownloadStatus.cancelled:
          onError(progress.error ?? 'Erreur inconnue');
          _subscriptions[initial]?.cancel();
          _subscriptions.remove(initial);
          break;
        default:
          onProgress(progress);
      }
    });

    _subscriptions[initial] = subscription;

    try {
      await _downloadManager.download(
        id: initial,
        url: downloadUrl,
        fileFullPath: fullPath,
      );
    } catch (e) {
      subscription.cancel();
      _subscriptions.remove(initial);
      if (!e.toString().contains("Cancelled")) onError('Erreur: $e');
    }
  }

  /// Démarrer un téléchargement de la langue common
  static Future<void> startDownloadCommonDB() async {
    if (!await ConnectionUtils.hasConnection()) {
      return;
    }

    try {
      String filePath = commonPath();
      dynamic downloadUrl = await getDownloadUrl(null, AppStrings.commonDbName);
      dynamic appDir = await PathUtils.getDatabaseRootDir();

      if (downloadUrl == null) return;

      final fullPath = File('${appDir.path}/${File(filePath).path}');
      await _downloadManager.download(
        id: AppStrings.commonDbName,
        url: downloadUrl,
        fileFullPath: fullPath,
      );
    } catch (e) {
      log('Erreur: $e');
    }
  }

  /// Annuler un téléchargement
  static Future<bool> cancelDownload(String id) async {
    final result = _downloadManager.cancel(id);
    if (_subscriptions.containsKey(id)) {
      await _subscriptions[id]?.cancel();
      _subscriptions.remove(id);
    }
    return result;
  }

  /// Annuler tous les téléchargements
  static Future<void> cancelAll() async {
    for (final id in _subscriptions.keys.toList()) {
      await cancelDownload(id);
    }
  }
}

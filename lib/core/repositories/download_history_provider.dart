import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:prophet_kacou/core/constants/app_strings.dart';
import 'package:prophet_kacou/core/models/download_progress.dart';
import 'package:prophet_kacou/core/models/download_history.dart';
import 'package:prophet_kacou/core/services/download_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadHistoryProvider extends ChangeNotifier {

  final DownloadManager _downloadManager = DownloadManager();
  final Map<String, StreamSubscription> _subscriptions = {};

  List<DownloadHistory> _history = [];
  List<DownloadHistory> get history => _history;

  List<DownloadHistory> get inProgressDownloads =>
      _history.where((h) => h.isInProgress).toList();

  List<DownloadHistory> get completedDownloads =>
      _history.where((h) => h.isCompleted).toList();

  int get inProgressCount => inProgressDownloads.length;
  int get completedCount => completedDownloads.length;
  int get totalActiveDownloads => inProgressCount;

  DownloadHistoryProvider() {
    _loadHistory();
  }

  // Charger l'historique depuis le stockage local
  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(AppStrings.downloadHistory);
      if (data != null) {
        final List<dynamic> jsonList = jsonDecode(data);
        _history = jsonList.map((json) => DownloadHistory.fromJson(json)).toList();
        
        // Reprendre les téléchargements en cours après redémarrage
        for (var download in inProgressDownloads) {
          _resumeDownload(download);
        }
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur lors du chargement de l\'historique: $e');
    }
  }

  // Sauvegarder l'historique dans le stockage local
  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonEncode(_history.map((h) => h.toJson()).toList());
      await prefs.setString(AppStrings.downloadHistory, data);
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde de l\'historique: $e');
    }
  }

  // Démarrer un nouveau téléchargement
  Future<void> startDownload({
    required String id,
    required String title,
    required String audioUrl,
    required String filePath,
    String? albumTitle,
    int? albumId,
  }) async {
    // Vérifier si le téléchargement existe déjà
    final existingIndex = _history.indexWhere((h) => h.id == id);
    if (existingIndex != -1 && _history[existingIndex].isInProgress) {
      return; // Téléchargement déjà en cours
    }

    // Créer un nouvel historique
    final download = DownloadHistory(
      id: id,
      title: title,
      audioUrl: audioUrl,
      filePath: filePath,
      percent: 0.0,
      downloadedMb: 0.0,
      totalMb: 0.0,
      status: DownloadStatus.downloading,
      startedAt: DateTime.now(),
      albumTitle: albumTitle,
      albumId: albumId,
    );

    if (existingIndex != -1) {
      _history[existingIndex] = download;
    } else {
      _history.insert(0, download);
    }

    notifyListeners();
    await _saveHistory();

    // Démarrer le téléchargement
    _startDownloadWithTracking(download);
  }

  // Reprendre un téléchargement
  void _resumeDownload(DownloadHistory download) {
    if (_subscriptions.containsKey(download.id)) return;
    _startDownloadWithTracking(download);
  }

  // Télécharger avec suivi
  void _startDownloadWithTracking(DownloadHistory download) {
    final subscription = _downloadManager.progressStream(download.id).listen(
      (progress) {
        _updateDownload(
          download.id,
          percent: progress.percent,
          downloadedMb: progress.downloadedMb,
          totalMb: progress.totalMb,
          status: progress.status,
          error: progress.error,
          completedAt: progress.status == DownloadStatus.completed
              ? DateTime.now()
              : null,
        );
      },
      onError: (error) {
        _updateDownload(
          download.id,
          status: DownloadStatus.failed,
          error: error.toString(),
        );
      },
    );

    _subscriptions[download.id] = subscription;

    // Lancer le téléchargement
    _downloadManager.download(
      id: download.id,
      url: download.audioUrl,
      fileFullPath: download.filePath,
    ).catchError((error) {
      _updateDownload(
        download.id,
        status: DownloadStatus.failed,
        error: error.toString(),
      );
    });
  }

  // Mettre à jour un téléchargement
  void _updateDownload(
    String id, {
    double? percent,
    double? downloadedMb,
    double? totalMb,
    DownloadStatus? status,
    String? error,
    DateTime? completedAt,
  }) {
    final index = _history.indexWhere((h) => h.id == id);
    if (index == -1) return;

    _history[index] = _history[index].copyWith(
      percent: percent,
      downloadedMb: downloadedMb,
      totalMb: totalMb,
      status: status,
      error: error,
      completedAt: completedAt,
    );

    notifyListeners();
    _saveHistory();

    // Nettoyer l'abonnement si terminé
    if (status == DownloadStatus.completed ||
        status == DownloadStatus.failed ||
        status == DownloadStatus.cancelled) {
      _subscriptions[id]?.cancel();
      _subscriptions.remove(id);
    }
  }

  // Annuler un téléchargement
  Future<void> cancelDownload(String id) async {
    final cancelled = _downloadManager.cancel(id);
    if (cancelled) {
      _updateDownload(
        id,
        status: DownloadStatus.cancelled,
      );
      _subscriptions[id]?.cancel();
      _subscriptions.remove(id);
    }
  }

  // Supprimer un élément de l'historique
  Future<void> deleteFromHistory(String id) async {
    _history.removeWhere((h) => h.id == id);
    notifyListeners();
    await _saveHistory();
  }

  // Effacer tout l'historique terminé
  Future<void> clearCompletedHistory() async {
    _history.removeWhere((h) => h.isCompleted);
    notifyListeners();
    await _saveHistory();
  }

  @override
  void dispose() {
    for (var subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
    super.dispose();
  }
}
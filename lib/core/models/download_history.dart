import 'package:prophet_kacou/core/models/download_progress.dart';

class DownloadHistory {
  final String id;
  final String title;
  final String audioUrl;
  final String filePath;
  final double percent;
  final double downloadedMb;
  final double totalMb;
  final DownloadStatus status;
  final String? error;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String? albumTitle;
  final int? albumId;

  DownloadHistory({
    required this.id,
    required this.title,
    required this.audioUrl,
    required this.filePath,
    required this.percent,
    required this.downloadedMb,
    required this.totalMb,
    required this.status,
    this.error,
    required this.startedAt,
    this.completedAt,
    this.albumTitle,
    this.albumId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'audioUrl': audioUrl,
        'filePath': filePath,
        'percent': percent,
        'downloadedMb': downloadedMb,
        'totalMb': totalMb,
        'status': status.toString(),
        'error': error,
        'startedAt': startedAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'albumTitle': albumTitle,
        'albumId': albumId,
      };

  factory DownloadHistory.fromJson(Map<String, dynamic> json) {
    return DownloadHistory(
      id: json['id'],
      title: json['title'],
      audioUrl: json['audioUrl'],
      filePath: json['filePath'],
      percent: (json['percent'] as num).toDouble(),
      downloadedMb: (json['downloadedMb'] as num).toDouble(),
      totalMb: (json['totalMb'] as num).toDouble(),
      status: DownloadStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => DownloadStatus.failed,
      ),
      error: json['error'],
      startedAt: DateTime.parse(json['startedAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      albumTitle: json['albumTitle'],
      albumId: json['albumId'],
    );
  }

  DownloadHistory copyWith({
    String? id,
    String? title,
    String? audioUrl,
    String? filePath,
    double? percent,
    double? downloadedMb,
    double? totalMb,
    DownloadStatus? status,
    String? error,
    DateTime? startedAt,
    DateTime? completedAt,
    String? albumTitle,
    int? albumId,
  }) {
    return DownloadHistory(
      id: id ?? this.id,
      title: title ?? this.title,
      audioUrl: audioUrl ?? this.audioUrl,
      filePath: filePath ?? this.filePath,
      percent: percent ?? this.percent,
      downloadedMb: downloadedMb ?? this.downloadedMb,
      totalMb: totalMb ?? this.totalMb,
      status: status ?? this.status,
      error: error ?? this.error,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      albumTitle: albumTitle ?? this.albumTitle,
      albumId: albumId ?? this.albumId,
    );
  }

  bool get isCompleted => status == DownloadStatus.completed;
  bool get isInProgress => status == DownloadStatus.downloading;
  bool get isFailed => status == DownloadStatus.failed;
  bool get isCancelled => status == DownloadStatus.cancelled;
}

import 'dart:io';

import 'package:prophet_kacou/core/models/download_progress.dart';
import 'package:prophet_kacou/core/models/play_mode.dart';

class DownloadHistory {
  final String id;
  final String title;
  final String audioUrl;
  final File filePath;
  final double percent;
  final double downloadedMb;
  final double totalMb;
  final DownloadStatus status;
  final String? error;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String? albumTitle;
  final int? albumId;
  final AudioFolder type;
  final String? videoLink;
  final String? fileOriginalName;
  final String? content;

  DownloadHistory({
    required this.id,
    required this.title,
    required this.audioUrl,
    required this.filePath,
    required this.percent,
    required this.downloadedMb,
    required this.totalMb,
    required this.status,
    required this.type,
    this.error,
    required this.startedAt,
    this.completedAt,
    this.albumTitle,
    this.albumId,
    this.videoLink,
    this.fileOriginalName,
    this.content
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'videoLink': videoLink,
        'fileOriginalName': fileOriginalName,
        'content': content,
        'title': title,
        'audioUrl': audioUrl,
        'filePath': filePath.path,
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
      type: json['type'],
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
      videoLink: json['videoLink'],
      fileOriginalName: json['fileOriginalName'],
      content: json['content'],
    );
  }

  DownloadHistory copyWith({
    String? id,
    String? title,
    String? audioUrl,
    File? filePath,
    double? percent,
    double? downloadedMb,
    double? totalMb,
    DownloadStatus? status,
    String? error,
    DateTime? startedAt,
    DateTime? completedAt,
    String? albumTitle,
    int? albumId,
    AudioFolder? type,
    String? videoLink,
    String? fileOriginalName,
    String? content,
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
      type: type ?? this.type,
      videoLink: videoLink ?? this.videoLink,
      fileOriginalName: fileOriginalName ?? this.fileOriginalName,
      content: content ?? this.content
    );
  }

  bool get isCompleted => status == DownloadStatus.completed;
  bool get isInProgress => status == DownloadStatus.downloading;
  bool get isFailed => status == DownloadStatus.failed;
  bool get isCancelled => status == DownloadStatus.cancelled;
}

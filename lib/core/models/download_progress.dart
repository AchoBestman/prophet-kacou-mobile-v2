class DownloadProgress {
  final String id;
  final String filePath;
  final double percent;
  final double downloadedMb;
  final double totalMb;
  final DownloadStatus status;
  final String? error;

  const DownloadProgress({
    required this.id,
    required this.filePath,
    required this.percent,
    required this.downloadedMb,
    required this.totalMb,
    required this.status,
    this.error,
  });
}

enum DownloadStatus { downloading, completed, failed, cancelled }

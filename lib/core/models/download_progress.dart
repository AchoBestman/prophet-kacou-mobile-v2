class DownloadProgress {
  final double percent;
  final double downloadSize;
  final double totalSize;

  const DownloadProgress({
    required this.percent,
    required this.downloadSize,
    required this.totalSize,
  });

  DownloadProgress copyWith({
    double? percent,
    double? downloadSize,
    double? totalSize,
  }) {
    return DownloadProgress(
      percent: percent ?? this.percent,
      downloadSize: downloadSize ?? this.downloadSize,
      totalSize: totalSize ?? this.totalSize,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:prophet_kacou/core/models/download_progress.dart';

class DownloadProgressModal extends StatelessWidget {
  final bool open;
  final VoidCallback onClose;
  final VoidCallback? stopDownloading;
  final String title;
  final DownloadProgress progress;
  final bool cancel;
  final String? type;

  const DownloadProgressModal({
    Key? key,
    required this.open,
    required this.onClose,
    this.stopDownloading,
    required this.title,
    required this.progress,
    this.cancel = false,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!open) return const SizedBox.shrink();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : const Color(0xFFF5E6D3), // pkp-sand
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : const Color(0xFF0066CC), // pkp-ocean
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              progress.percent == 100
                  ? "Langue téléchargée" // tr("download.langue_is_downloaded")
                  : title,
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Progress Section
            Column(
              children: [
                Row(
                  children: [
                    // Progress Bar
                    Expanded(
                      child: Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress.percent / 100,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Delete Icon
                    if (type != "appLoad")
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          if (progress.percent != 100) {
                            stopDownloading?.call();
                            onClose();
                          }
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // Progress Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${progress.percent}%',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                    if (progress.totalSize > 0)
                      Text(
                        '${progress.downloadSize}M / ${progress.totalSize}M',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                  ],
                ),
              ],
            ),

            // Footer
            if ((type != "appLoad" || progress.percent == 100) && cancel)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: onClose,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF0066CC),
                        width: 2,
                      ),
                    ),
                    child: const Text(
                      'Fermer', // tr("button.close")
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
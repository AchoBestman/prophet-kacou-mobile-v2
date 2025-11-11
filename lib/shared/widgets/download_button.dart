import 'package:flutter/material.dart';
import 'package:prophet_kacou/core/models/download_progress.dart';
import 'package:prophet_kacou/shared/widgets/download_progress_modal.dart';

class DownloadButton extends StatefulWidget {
  final String audioUrl;
  final String fileName;
  final String subFolder;
  final Function(bool) setFinishedDownload;
  final Widget? child;
  final String? fileOriginalName;
  final int modelId;
  final int? albumId;

  const DownloadButton({
    Key? key,
    required this.audioUrl,
    required this.fileName,
    required this.subFolder,
    required this.setFinishedDownload,
    this.child,
    this.fileOriginalName,
    required this.modelId,
    this.albumId,
  }) : super(key: key);

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool isDownloading = false;
  DownloadProgress progress = const DownloadProgress(
    percent: 0,
    downloadSize: 0,
    totalSize: 0,
  );
  bool openProgress = false;

  void onOpenChangeProgress() {
    setState(() {
      openProgress = !openProgress;
    });
  }

  Future<void> stopDownloading() async {
    // await cancelDownload(widget.modelId);
    // clearHistory(widget.modelId);
    // Dispatch event equivalent
  }

  Future<void> handleDownload() async {
    // Check network connectivity
    // if (!await isOnline()) {
    //   showAlert("Impossible de télécharger");
    //   return;
    // }

    try {
      onOpenChangeProgress();
      setState(() {
        isDownloading = true;
      });
      widget.setFinishedDownload(false);

      // await downloadAudioWithProgress(
      //   lng: currentLanguage,
      //   url: widget.audioUrl,
      //   subFolder: widget.subFolder,
      //   fileName: widget.fileName,
      //   modelId: widget.modelId,
      //   onProgress: (percent) {
      //     setState(() {
      //       progress = percent;
      //     });
      //   },
      //   fileOriginalName: widget.fileOriginalName,
      //   albumId: widget.albumId,
      // );
    } catch (error) {
      debugPrint("❌ Download failed: $error");
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
  }

  @override
  void didUpdateWidget(DownloadButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (progress.percent == 100) {
      widget.setFinishedDownload(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: handleDownload,
          child: widget.child ??
              ElevatedButton(
                onPressed: isDownloading ? null : handleDownload,
                child: isDownloading
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LinearProgressIndicator(
                            value: progress.percent / 100,
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${progress.percent}%'),
                              if (progress.totalSize > 0)
                                Text(
                                  '${progress.downloadSize}M / ${progress.totalSize}M',
                                ),
                            ],
                          ),
                        ],
                      )
                    : const Text('Audio'), // tr("button.audio")
              ),
        ),
        DownloadProgressModal(
          open: openProgress,
          onClose: onOpenChangeProgress,
          progress: progress,
          title: "En attente du téléchargement audio",
          cancel: true,
          stopDownloading: stopDownloading,
        ),
      ],
    );
  }
}
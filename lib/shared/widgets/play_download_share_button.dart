import 'package:flutter/material.dart';
import 'package:prophet_kacou/core/models/audio_item.dart';
import 'package:prophet_kacou/core/models/play_mode.dart';
import 'package:prophet_kacou/core/providers/audio_player_provider.dart';
import 'package:prophet_kacou/core/repositories/download_history_provider.dart';
import 'package:prophet_kacou/core/utils/notificaction.dart';
import 'package:provider/provider.dart';

enum ButtonType {
  play,
  download,
  share,
}

class ButtonConfig {
  final bool showPlay;
  final bool showDownload;
  final bool showShare;
  final List<ButtonType> order;
  final double iconSize;
  final double spacing;
  final Color defaultDarkColor;
  final Color defaultLigthColor;

  const ButtonConfig({
    this.showPlay = true,
    this.showDownload = true,
    this.showShare = true,
    this.order = const [ButtonType.play, ButtonType.download, ButtonType.share],
    this.iconSize = 24.0,
    this.spacing = 4.0,
    this.defaultDarkColor=Colors.lightBlue,
    this.defaultLigthColor=Colors.blue
  });
}

class PlayDownloadShareButton extends StatefulWidget {
  final AudioItem data;
  final AudioFolder type;
  final FileExtension extension;
  final dynamic sourceData; // Sermon ou autre objet source pour le partage
  final Function(dynamic)? onGeneratePdf;
  final Function(dynamic)? onGenerateEpub;
  final ButtonConfig config;

  const PlayDownloadShareButton({
    super.key,
    required this.data,
    required this.type,
    required this.extension,
    this.sourceData,
    this.onGeneratePdf,
    this.onGenerateEpub,
    this.config = const ButtonConfig(),
  });

  @override
  State<PlayDownloadShareButton> createState() => _PlayDownloadShareButtonState();
}

class _PlayDownloadShareButtonState extends State<PlayDownloadShareButton> {
  bool _isDownloaded = false;
  final int size = 4;
  final int borderRadius = 20;

  @override
  void initState() {
    super.initState();
    _checkIfDownloaded();
  }

  Future<void> _checkIfDownloaded() async {
    if (widget.data.localFullPath != null) {
      final exists = await widget.data.localFullPath!.exists();
      if (mounted) {
        setState(() {
          _isDownloaded = exists;
        });
      }
    }
  }

  void _playAudio() async {
    final audioProvider = Provider.of<AudioPlayerProvider>(
      context,
      listen: false,
    );

    if (audioProvider.currentAudioId == widget.data.id) {
      audioProvider.togglePlayPause();
    } else {
      if (context.mounted) {
        audioProvider.setAudio(context, widget.data, autoPlay: true);
      }
    }
  }

  Future<void> _downloadAudio() async {
    if (widget.data.audioUrl.isEmpty) return;

    try {
      if (!mounted) return;

      final downloadProvider = Provider.of<DownloadHistoryProvider>(
        context,
        listen: false,
      );

      await downloadProvider.startDownload(
        id: widget.data.id.toString(),
        title: widget.data.title,
        audioUrl: widget.data.audioUrl,
        filePath: widget.data.localFullPath!,
        albumTitle: null,
        albumId: widget.data.albumId,
      );

      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      NotificactionService.showErrorMessage(
        context,
        'Erreur de téléchargement: $e',
      );
    }
  }

  void _onDownloadComplete() {
    setState(() {
      _isDownloaded = true;
    });
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('Partager en PDF'),
              onTap: () {
                Navigator.pop(context);
                if (widget.onGeneratePdf != null) {
                  widget.onGeneratePdf!(widget.sourceData);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.book, color: Colors.blue),
              title: const Text('Partager en EPUB'),
              onTap: () {
                Navigator.pop(context);
                if (widget.onGenerateEpub != null) {
                  widget.onGenerateEpub!(widget.sourceData);
                } else {
                  NotificactionService.showSuccessMessage(
                    context,
                    'Génération EPUB en cours de développement',
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton({
    required bool isCurrentAudio,
    required bool isPlaying,
    required bool isDark,
  }) {
    if (!widget.config.showPlay || widget.data.audioUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: _playAudio,
      borderRadius: BorderRadius.circular(double.parse(borderRadius.toString())),
      child: Padding(
        padding: EdgeInsets.all(double.parse(size.toString())),
        child: Icon(
          isPlaying ? Icons.pause_circle_rounded : Icons.play_circle_rounded,
          color: isCurrentAudio ? Colors.orange : (isDark ? widget.config.defaultDarkColor : widget.config.defaultLigthColor),
          size: widget.config.iconSize,
        ),
      ),
    );
  }

  Widget _buildDownloadButton({
    required bool isDownloading,
    required double? downloadProgress,
    required bool isDark,
  }) {
    if (!widget.config.showDownload || widget.data.audioUrl.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return InkWell(
      onTap: isDownloading ? null : _downloadAudio,
      borderRadius: BorderRadius.circular(double.parse(borderRadius.toString())),
      child: Padding(
        padding: EdgeInsets.all(double.parse(size.toString())),
        child: isDownloading
            ? SizedBox(
                width: widget.config.iconSize - size,
                height: widget.config.iconSize - size,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: downloadProgress,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? Colors.lightBlue : Colors.blue,
                  ),
                  backgroundColor: Colors.grey.shade300,
                ),
              )
            : Icon(
                _isDownloaded
                    ? Icons.download_for_offline
                    : Icons.download_rounded,
                color: _isDownloaded
                    ? Colors.orange
                    : (isDark ? widget.config.defaultDarkColor : widget.config.defaultLigthColor),
                size: widget.config.iconSize - size,
              ),
      ),
    );
  }

  Widget _buildShareButton({required bool isDark}) {
    if (!widget.config.showShare ||
        (widget.onGeneratePdf == null && widget.onGenerateEpub == null)) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: _showShareOptions,
      borderRadius: BorderRadius.circular(double.parse(borderRadius.toString())),
      child: Padding(
        padding: EdgeInsets.all(double.parse(size.toString())),
        child: Icon(
          Icons.share,
          color: isDark ? widget.config.defaultDarkColor : widget.config.defaultLigthColor,
          size: widget.config.iconSize - size,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer2<AudioPlayerProvider, DownloadHistoryProvider>(
      builder: (context, audioProvider, downloadProvider, child) {
        final isCurrentAudio = audioProvider.currentAudioId == widget.data.id;
        final isPlaying = isCurrentAudio && audioProvider.isPlaying;

        final downloadId = widget.data.id.toString();
        final downloadHistory = downloadProvider.history
            .where((d) => d.id == downloadId)
            .firstOrNull;
        final isDownloading = downloadHistory?.isInProgress ?? false;
        final downloadProgress =
            isDownloading ? (downloadHistory?.percent ?? 0) / 100 : null;

        // Listen for download completion
        if (downloadHistory?.isCompleted == true && !_isDownloaded) {
          Future.microtask(() => _onDownloadComplete());
        }

        // Construire les boutons dans l'ordre spécifié
        final buttons = <Widget>[];
        
        for (var buttonType in widget.config.order) {
          switch (buttonType) {
            case ButtonType.play:
              buttons.add(_buildPlayButton(
                isCurrentAudio: isCurrentAudio,
                isPlaying: isPlaying,
                isDark: isDark,
              ));
              break;
            case ButtonType.download:
              buttons.add(_buildDownloadButton(
                isDownloading: isDownloading,
                downloadProgress: downloadProgress,
                isDark: isDark,
              ));
              break;
            case ButtonType.share:
              buttons.add(_buildShareButton(isDark: isDark));
              break;
          }
        }

        // Ajouter l'espacement entre les boutons
        final widgetsWithSpacing = <Widget>[];
        for (int i = 0; i < buttons.length; i++) {
          widgetsWithSpacing.add(buttons[i]);
          if (i < buttons.length - 1) {
            widgetsWithSpacing.add(SizedBox(width: widget.config.spacing));
          }
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: widgetsWithSpacing,
        );
      },
    );
  }
}
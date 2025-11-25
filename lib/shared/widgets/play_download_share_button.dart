import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/audio_item.dart';
import 'package:prophet_kacou/core/models/play_mode.dart';
import 'package:prophet_kacou/core/providers/audio_player_provider.dart';
import 'package:prophet_kacou/core/repositories/download_history_provider.dart';
import 'package:prophet_kacou/core/utils/alert_dialog.dart';
import 'package:prophet_kacou/core/utils/extensions.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/core/utils/notificaction.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:provider/provider.dart';

enum ButtonType { play, download, share, open, delete }

enum DisplayMode { full, menu, mix }

class ButtonConfig {
  final bool showPlay;
  final bool showDownload;
  final bool showShare;
  final bool showOpen;
  final bool showDelete;
  final bool sermonVideoExist;
  final bool isFromHistory;
  final List<ButtonType> order;
  final double iconSize;
  final double spacing;
  final Color defaultDarkColor;
  final Color defaultLigthColor;
  final DisplayMode mode;
  final ButtonType? primaryButton;

  const ButtonConfig({
    this.showPlay = true,
    this.isFromHistory = false,
    this.showDownload = true,
    this.showShare = true,
    this.showDelete = true,
    this.showOpen = false,
    this.sermonVideoExist = false,
    this.order = const [
      ButtonType.play,
      ButtonType.download,
      ButtonType.share,
      ButtonType.delete,
    ],
    this.iconSize = 24.0,
    this.spacing = 4.0,
    this.defaultDarkColor = Colors.lightBlue,
    this.defaultLigthColor = Colors.blue,
    this.mode = DisplayMode.full,
    this.primaryButton,
  });
}

class PlayDownloadShareButton extends StatefulWidget {
  final AudioItem data;
  final AudioFolder type;
  final FileExtension extension;
  final dynamic sourceData;
  final Function(dynamic)? onGeneratePdf;
  final Function(dynamic)? onGenerateEpub;
  final ButtonConfig config;
  final VoidCallback? onClose;

  const PlayDownloadShareButton({
    super.key,
    required this.data,
    required this.type,
    required this.extension,
    this.sourceData,
    this.onGeneratePdf,
    this.onGenerateEpub,
    this.config = const ButtonConfig(),
    this.onClose,
  });

  @override
  State<PlayDownloadShareButton> createState() =>
      _PlayDownloadShareButtonState();
}

class _PlayDownloadShareButtonState extends State<PlayDownloadShareButton> {
  bool _isDownloaded = false;
  final int size = 4;
  final int borderRadius = 20;

  // ✅ Variables pour gérer les états de chargement
  bool _isDeleting = false;
  bool _isOpening = false;
  bool _isSharing = false;
  bool _isDownloadingManual = false;

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

  // ✅ Méthode pour rafraîchir l'état du fichier
  Future<void> _refreshFileStatus() async {
    if (!mounted) return;
    await _checkIfDownloaded();
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

  void _shareAudio() async {
    // ✅ Empêcher les clics multiples
    if (_isSharing) return;

    setState(() {
      _isSharing = true;
    });

    try {
      final audioProvider = Provider.of<AudioPlayerProvider>(
        context,
        listen: false,
      );

      await audioProvider.shareAudio(widget.data);
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  Future<void> _openLocalFile() async {
    // ✅ Empêcher les clics multiples
    if (_isOpening) return;

    if (widget.config.sermonVideoExist &&
        widget.data.videoLink != null &&
        widget.data.videoLink!.isNotEmpty) {
      widget.onClose?.call();
      final url = getYoutubeVideoUrlById(widget.data.videoLink!);
      await openLink(url);
    }

    if (widget.data.localFullPath == null) return;

    final file = widget.data.localFullPath!;
    if (!await file.exists()) {
      await _refreshFileStatus();
      return;
    }

    setState(() {
      _isOpening = true;
    });

    try {
      widget.onClose?.call();
      await OpenFilex.open(file.path);
    } finally {
      if (mounted) {
        setState(() {
          _isOpening = false;
        });
      }
    }
  }

  Future<void> _deleteLocalFile() async {
    // ✅ Empêcher les clics multiples
    if (_isDeleting) return;
    if (widget.data.localFullPath == null) return;

    final file = widget.data.localFullPath!;
    if (!await file.exists() || !mounted) {
      await _refreshFileStatus();
      return;
    }

    final confirmed = await DialogUtils.confirmDialog(
      context,
      i18n.tr('button.confirm_action'),
    );

    if (!confirmed || !mounted) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      widget.onClose?.call();

      final downloadProvider = Provider.of<DownloadHistoryProvider>(
        context,
        listen: false,
      );

      await downloadProvider.deleteFromHistory(widget.data.id.toString());

      if (!widget.config.isFromHistory) {
        await file.delete();
        if (mounted) {
          NotificactionService.showSuccessMessage(
            context,
            "${widget.data.title} ${i18n.tr("home.has_been_deleted")}",
          );
        }
      }

      // ✅ Rafraîchir l'état après suppression
      await _refreshFileStatus();
    } catch (e) {
      if (mounted) {
        log('Une erreur s\'est produite lors de la suppression: $e');
        NotificactionService.showErrorMessage(
          context,
          i18n.tr("home.an_error_occurred")
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  Future<void> _downloadAudio() async {
    // ✅ Empêcher les clics multiples
    if (_isDownloadingManual) return;
    if (widget.data.audioUrl.isEmpty) return;

    setState(() {
      _isDownloadingManual = true;
    });

    try {
      if (!mounted) return;

      final downloadProvider = Provider.of<DownloadHistoryProvider>(
        context,
        listen: false,
      );

      await downloadProvider.startDownload(widget.data);

      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      log('Une erreur s\'est produite lors du téléchargement: $e');
      NotificactionService.showErrorMessage(
        context,
        i18n.tr("home.an_error_occurred")
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDownloadingManual = false;
        });
      }
    }
  }

  void _onDownloadComplete() {
    setState(() {
      _isDownloaded = true;
    });
  }

  void _showShareOptions(bool isDownloaded, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? null : pkpSand,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.data.content != null)
              ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                title: Text(i18n.tr("home.share_the_pdf")),
                enabled: !_isSharing,
                onTap: _isSharing
                    ? null
                    : () {
                        Navigator.pop(context);
                        widget.onClose?.call();
                        if (widget.onGeneratePdf != null) {
                          widget.onGeneratePdf!(widget.sourceData);
                        }
                      },
              ),
            if (isDownloaded)
              ListTile(
                leading: const Icon(
                  Icons.music_note_rounded,
                  color: Colors.red,
                ),
                title: Text(i18n.tr("home.share_the_audio")),
                enabled: !_isSharing,
                onTap: _isSharing
                    ? null
                    : () async {
                        Navigator.pop(context);
                        widget.onClose?.call();
                        _shareAudio();
                      },
              ),
            if (widget.data.content != null && widget.data.albumId == null)
              ListTile(
                leading: const Icon(Icons.book, color: Colors.blue),
                title: Text(i18n.tr("home.share_the_epub")),
                enabled: !_isSharing,
                onTap: _isSharing
                    ? null
                    : () {
                        Navigator.pop(context);
                        widget.onClose?.call();
                        if (widget.onGenerateEpub != null) {
                          widget.onGenerateEpub!(widget.sourceData);
                        } else {
                          NotificactionService.showSuccessMessage(
                            context,
                            i18n.tr("home.epub_not_available"),
                          );
                        }
                      },
              ),
          ],
        ),
      ),
    );
  }

  void _showActionsMenu({
    required bool isCurrentAudio,
    required bool isPlaying,
    required bool isDark,
    required bool isDownloading,
    required double? downloadProgress,
    required bool isDownloaded,
    List<ButtonType>? excludeButtons,
  }) {
    final buttonsToShow = widget.config.order
        .where((btn) => excludeButtons == null || !excludeButtons.contains(btn))
        .toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? null : pkpSand,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: buttonsToShow.map((buttonType) {
            switch (buttonType) {
              case ButtonType.open:
                if (!widget.config.showOpen) {
                  return const SizedBox.shrink();
                }
                if (widget.config.sermonVideoExist &&
                   ( widget.data.videoLink == null ||
                    widget.data.videoLink!.isEmpty)) {
                  return const SizedBox.shrink();
                }

                return ListTile(
                  leading: _isOpening
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          widget.config.sermonVideoExist
                              ? Icons.videocam
                              : Icons.open_in_new_rounded,
                        ),
                  title: Text(
                    widget.config.sermonVideoExist
                        ? i18n.tr("home.see_the_video")
                        : i18n.tr("home.open_the_file"),
                  ),
                  enabled: !_isOpening,
                  onTap: _isOpening
                      ? null
                      : () {
                          Navigator.pop(context);
                          _openLocalFile();
                        },
                );

              case ButtonType.delete:
                if (!widget.config.showDelete || !_isDownloaded) {
                  return const SizedBox.shrink();
                }
                return ListTile(
                  leading: _isDeleting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.delete, color: Colors.red),
                  title: Text(i18n.tr("home.delete_the_audio")),
                  enabled: !_isDeleting,
                  onTap: _isDeleting
                      ? null
                      : () {
                          Navigator.pop(context);
                          _deleteLocalFile();
                        },
                );

              case ButtonType.play:
                if (!widget.config.showPlay || widget.data.audioUrl.isEmpty) {
                  return const SizedBox.shrink();
                }
                return ListTile(
                  leading: Icon(
                    isPlaying
                        ? Icons.pause_circle_rounded
                        : Icons.play_circle_rounded,
                    color: isCurrentAudio
                        ? Colors.orange
                        : isDownloaded
                        ? Colors.orange
                        : null,
                  ),
                  title: Text(isPlaying ? i18n.tr("home.pause") : i18n.tr("home.play")),
                  onTap: () {
                    Navigator.pop(context);
                    _playAudio();
                    widget.onClose?.call();
                  },
                );

              case ButtonType.download:
                if (!widget.config.showDownload ||
                    widget.data.audioUrl.isEmpty) {
                  return const SizedBox.shrink();
                }
                return ListTile(
                  leading: Icon(
                    _isDownloaded
                        ? Icons.download_for_offline
                        : Icons.download_rounded,
                    color: _isDownloaded ? Colors.orange : null,
                  ),
                  title: Text(_isDownloaded ? i18n.tr("home.downloaded") : i18n.tr("home.download")),
                  enabled: !isDownloading && !_isDownloadingManual,
                  onTap: (isDownloading || _isDownloadingManual)
                      ? null
                      : () {
                          Navigator.pop(context);
                          _downloadAudio();
                          widget.onClose?.call();
                        },
                  trailing: (isDownloading || _isDownloadingManual)
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: downloadProgress,
                          ),
                        )
                      : null,
                );

              case ButtonType.share:
                if (!widget.config.showShare ||
                    (widget.onGeneratePdf == null &&
                        widget.onGenerateEpub == null)) {
                  return const SizedBox.shrink();
                }
                if (widget.data.content == null && !isDownloaded) {
                  return const SizedBox.shrink();
                }
                return ListTile(
                  leading: _isSharing
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.share, color: Colors.orange),
                  title: Text(i18n.tr("home.share")),
                  enabled: !_isSharing,
                  onTap: _isSharing
                      ? null
                      : () {
                          Navigator.pop(context);
                          _showShareOptions(isDownloaded, isDark);
                        },
                );
            }
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildOpenButton({required bool isDark}) {
    if (!widget.config.showOpen) return const SizedBox.shrink();
    if (!_isDownloaded) return const SizedBox.shrink();

    return InkWell(
      onTap: _isOpening ? null : () => _openLocalFile(),
      borderRadius: BorderRadius.circular(borderRadius.toDouble()),
      child: Padding(
        padding: EdgeInsets.all(size.toDouble()),
        child: _isOpening
            ? SizedBox(
                width: widget.config.iconSize - size,
                height: widget.config.iconSize - size,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? Colors.lightBlue : Colors.blue,
                  ),
                ),
              )
            : Icon(
                Icons.open_in_new_rounded,
                color: isDark
                    ? widget.config.defaultDarkColor
                    : widget.config.defaultLigthColor,
                size: widget.config.iconSize - size,
              ),
      ),
    );
  }

  Widget _buildDeleteButton({required bool isDark}) {
    if (!widget.config.showDelete) return const SizedBox.shrink();
    if (!_isDownloaded) return const SizedBox.shrink();

    return InkWell(
      onTap: _isDeleting ? null : () => _deleteLocalFile(),
      borderRadius: BorderRadius.circular(borderRadius.toDouble()),
      child: Padding(
        padding: EdgeInsets.all(size.toDouble()),
        child: _isDeleting
            ? SizedBox(
                width: widget.config.iconSize - size,
                height: widget.config.iconSize - size,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              )
            : Icon(
                Icons.delete,
                color: isDark
                    ? widget.config.defaultDarkColor
                    : widget.config.defaultLigthColor,
                size: widget.config.iconSize - size,
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
      onTap: () {
        _playAudio();
        widget.onClose?.call();
      },
      borderRadius: BorderRadius.circular(
        double.parse(borderRadius.toString()),
      ),
      child: Padding(
        padding: EdgeInsets.all(double.parse(size.toString())),
        child: Icon(
          isPlaying ? Icons.pause_circle_rounded : Icons.play_circle_rounded,
          color: isCurrentAudio
              ? Colors.orange
              : _isDownloaded
              ? Colors.orange
              : (isDark
                    ? widget.config.defaultDarkColor
                    : widget.config.defaultLigthColor),
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

    final isLoading = isDownloading || _isDownloadingManual;

    return InkWell(
      onTap: isLoading
          ? null
          : () {
              _downloadAudio();
              widget.onClose?.call();
            },
      borderRadius: BorderRadius.circular(
        double.parse(borderRadius.toString()),
      ),
      child: Padding(
        padding: EdgeInsets.all(double.parse(size.toString())),
        child: isLoading
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
                    : (isDark
                          ? widget.config.defaultDarkColor
                          : widget.config.defaultLigthColor),
                size: widget.config.iconSize - size,
              ),
      ),
    );
  }

  Widget _buildShareButton({required bool isDark, required bool isDownloaded}) {
    if (!widget.config.showShare ||
        (widget.onGeneratePdf == null && widget.onGenerateEpub == null)) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: _isSharing ? null : () => _showShareOptions(isDownloaded, isDark),
      borderRadius: BorderRadius.circular(
        double.parse(borderRadius.toString()),
      ),
      child: Padding(
        padding: EdgeInsets.all(double.parse(size.toString())),
        child: _isSharing
            ? SizedBox(
                width: widget.config.iconSize - size,
                height: widget.config.iconSize - size,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? Colors.lightBlue : Colors.blue,
                  ),
                ),
              )
            : Icon(
                Icons.share,
                color: isDark
                    ? widget.config.defaultDarkColor
                    : widget.config.defaultLigthColor,
                size: widget.config.iconSize - size,
              ),
      ),
    );
  }

  Widget _buildMenuButton({
    required bool isCurrentAudio,
    required bool isPlaying,
    required bool isDark,
    required bool isDownloading,
    required double? downloadProgress,
    required bool isDownloaded,
    List<ButtonType>? excludeButtons,
  }) {
    return InkWell(
      onTap: () => _showActionsMenu(
        isCurrentAudio: isCurrentAudio,
        isPlaying: isPlaying,
        isDark: isDark,
        isDownloading: isDownloading,
        downloadProgress: downloadProgress,
        isDownloaded: isDownloaded,
        excludeButtons: excludeButtons,
      ),
      borderRadius: BorderRadius.circular(borderRadius.toDouble()),
      child: Padding(
        padding: EdgeInsets.all(size.toDouble()),
        child: Icon(
          Icons.more_vert,
          color: isDark
              ? widget.config.defaultDarkColor
              : widget.config.defaultLigthColor,
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
        final downloadProgress = isDownloading
            ? (downloadHistory?.percent ?? 0) / 100
            : null;

        if (downloadHistory?.isCompleted == true && !_isDownloaded) {
          Future.microtask(() => _onDownloadComplete());
        }

        // Mode menu
        if (widget.config.mode == DisplayMode.menu) {
          return _buildMenuButton(
            isCurrentAudio: isCurrentAudio,
            isPlaying: isPlaying,
            isDark: isDark,
            isDownloading: isDownloading,
            downloadProgress: downloadProgress,
            isDownloaded: _isDownloaded,
          );
        }

        // Mode mix
        if (widget.config.mode == DisplayMode.mix) {
          final primaryButton = widget.config.primaryButton ?? ButtonType.play;
          Widget? primaryWidget;

          switch (primaryButton) {
            case ButtonType.open:
              primaryWidget = _buildOpenButton(isDark: isDark);
              break;
            case ButtonType.delete:
              primaryWidget = _buildDeleteButton(isDark: isDark);
              break;
            case ButtonType.play:
              primaryWidget = _buildPlayButton(
                isCurrentAudio: isCurrentAudio,
                isPlaying: isPlaying,
                isDark: isDark,
              );
              break;
            case ButtonType.download:
              primaryWidget = _buildDownloadButton(
                isDownloading: isDownloading,
                downloadProgress: downloadProgress,
                isDark: isDark,
              );
              break;
            case ButtonType.share:
              if (widget.data.content != null ||
                  downloadHistory?.isCompleted == true) {
                primaryWidget = _buildShareButton(
                  isDark: isDark,
                  isDownloaded: _isDownloaded,
                );
              }
              break;
          }

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (primaryWidget != null) primaryWidget,
              if (primaryWidget != null) SizedBox(width: widget.config.spacing),
              _buildMenuButton(
                isCurrentAudio: isCurrentAudio,
                isPlaying: isPlaying,
                isDark: isDark,
                isDownloading: isDownloading,
                downloadProgress: downloadProgress,
                isDownloaded: _isDownloaded,
                excludeButtons: [primaryButton],
              ),
            ],
          );
        }

        // Mode full
        final buttons = <Widget>[];

        for (var buttonType in widget.config.order) {
          switch (buttonType) {
            case ButtonType.open:
              buttons.add(_buildOpenButton(isDark: isDark));
              break;
            case ButtonType.delete:
              buttons.add(_buildDeleteButton(isDark: isDark));
              break;
            case ButtonType.play:
              buttons.add(
                _buildPlayButton(
                  isCurrentAudio: isCurrentAudio,
                  isPlaying: isPlaying,
                  isDark: isDark,
                ),
              );
              break;
            case ButtonType.download:
              buttons.add(
                _buildDownloadButton(
                  isDownloading: isDownloading,
                  downloadProgress: downloadProgress,
                  isDark: isDark,
                ),
              );
              break;
            case ButtonType.share:
              if (widget.data.content != null ||
                  downloadHistory?.isCompleted == true) {
                buttons.add(
                  _buildShareButton(
                    isDark: isDark,
                    isDownloaded: _isDownloaded,
                  ),
                );
              }
              break;
          }
        }

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

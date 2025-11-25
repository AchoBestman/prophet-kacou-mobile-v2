import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prophet_kacou/app/themes/app_theme.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/audio_item.dart';
import 'package:prophet_kacou/core/models/play_mode.dart';
import 'package:prophet_kacou/core/models/sermon.dart';
import 'package:prophet_kacou/core/models/verse.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/widgets/play_download_share_button.dart';
import 'package:provider/provider.dart';

class VerseLinksWidget extends StatefulWidget {
  final List<dynamic>? verseLinks;
  final Sermon sermon;

  const VerseLinksWidget({
    super.key,
    required this.verseLinks,
    required this.sermon,
  });

  @override
  State<VerseLinksWidget> createState() => _VerseLinksWidgetState();
}

class _VerseLinksWidgetState extends State<VerseLinksWidget> {
  
  void _showModalBottom(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? null : pkpSand,
      builder: (context) => SafeArea(
        child: ListView(
          
          shrinkWrap: true,
          children: widget.verseLinks!.asMap().entries.map((entry) {
            final link = VerseLink.fromMap(entry.value);

            String type = link.type;
            String title = link.fileName ?? link.content ?? 'file';
            String url = link.url;

            FileExtension extension = type == 'audio'
                ? FileExtension.mp3
                : type == 'video'
                ? FileExtension.mp4
                : FileExtension.pdf;

            final index = entry.key;
            final suffix = widget.verseLinks!.length > 1
                ? '(${index + 1})'
                : '';

            final icon =
                (extension == FileExtension.pdf ||
                    extension == FileExtension.doc)
                ? Icons.picture_as_pdf
                : type == 'audio'
                ? Icons.music_note_rounded
                : Icons.video_camera_back;

            final text =
                (extension == FileExtension.pdf ||
                    extension == FileExtension.doc)
                ? i18n.tr("home.the_document")
                : type == 'audio'
                ? i18n.tr("home.the_audio")
                : i18n.tr("home.the_video");

            final bool openLink =
                (extension == FileExtension.pdf ||
                    extension == FileExtension.doc ||
                    type == "video")
                ? true
                : false;
            final playAudio = extension == FileExtension.mp3;

            final displayTitle = '$title $suffix';

            return FutureBuilder<File>(
              future: localOtherPath(displayTitle, i18n.lang, extension),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }

                final audioItem = AudioItem(
                  type: AudioFolder.others,
                  id: index + 1,
                  title: title,
                  audioUrl: url,
                  albumId: null,
                  fileOriginalName: displayTitle,
                  localFullPath: snapshot.data!,
                );

                return ListTile(
                  leading: Icon(icon, color: Colors.red),
                  title: Text(text),
                  trailing: PlayDownloadShareButton(
                    data: audioItem,
                    type: AudioFolder.others,
                    extension: extension,
                    onClose: () => Navigator.pop(context),
                    config: ButtonConfig(
                      showPlay: playAudio,
                      showDownload: true,
                      showShare: false,
                      showOpen: openLink,
                      iconSize: 24.0,
                      spacing: 4.0,
                      order: openLink
                          ? [ButtonType.open, ButtonType.download]
                          : [ButtonType.play, ButtonType.download],
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.verseLinks == null || widget.verseLinks!.isEmpty) {
      return const SizedBox.shrink();
    }

    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: ListTile(
            visualDensity: VisualDensity(vertical: -4),
            contentPadding: EdgeInsets.zero,
            textColor: Colors.blue,
            titleTextStyle: TextStyle(
              fontSize: themeProvider.customFont.fontSize + 2,
              fontWeight: FontWeight.bold,
              fontFamily: themeProvider.customFont.fontFamily,
              fontStyle: FontStyle.italic,
            ),
            title: Text(i18n.tr("home.see_file_associated")), 
            onTap: ()=> _showModalBottom(isDark),
          ),
        ),
      ],
    );
  }
}

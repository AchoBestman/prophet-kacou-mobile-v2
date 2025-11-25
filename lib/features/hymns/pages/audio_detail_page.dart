import 'dart:io';
import 'dart:ui' as flutter_html;

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:prophet_kacou/app/themes/app_theme.dart';
import 'package:prophet_kacou/core/models/audio_item.dart';
import 'package:prophet_kacou/core/models/play_mode.dart';
import 'package:prophet_kacou/core/models/song.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';
import 'package:prophet_kacou/shared/widgets/play_download_share_button.dart';
import 'package:prophet_kacou/shared/widgets/song_pdf_widget.dart';
import 'package:provider/provider.dart';

class AudioDetailPage extends StatelessWidget {
  final AudioItem audio;
  const AudioDetailPage({super.key, required this.audio});
  static const routeName = '/album-details';
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Méthode pour générer le PDF
    Future<void> generatePdf(dynamic song) async {
      if (context.mounted) {
        generateSongPdf(context, song as Song);
      }
    }

    // Méthode pour générer l'EPUB (à implémenter)
    Future<void> generateEpub(dynamic song) async {}

    final lines = audio.content!.split('\n');

    return MainLayout(
      title: audio.title,
      isHomePage: false,
      actions: [
        FutureBuilder<File>(
          future: localSongPath(
            Song(
              id: audio.id,
              title: audio.title,
              audio: audio.audioUrl,
              albumId: audio.albumId ?? 0,
            ),
            i18n.lang,
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }
            final audioItem = AudioItem(
              type: AudioFolder.hymns,
              id: audio.id,
              title: audio.title,
              audioUrl: audio.audioUrl,
              videoLink: null,
              albumId: null,
              fileOriginalName: null,
              localFullPath: snapshot.data!,
              content: audio.content,
            );

            return PlayDownloadShareButton(
              data: audioItem,
              type: AudioFolder.hymns,
              extension: FileExtension.mp3,
              sourceData: audio,
              onGeneratePdf: generatePdf,
              onGenerateEpub: generateEpub,
              config: const ButtonConfig(
                showPlay: true,
                showDownload: true,
                showShare: true,
                showOpen: true,
                sermonVideoExist: true,
                iconSize: 24.0,
                spacing: 6.0,
                defaultDarkColor: Colors.white,
                defaultLigthColor: Colors.white,
                mode: DisplayMode.mix,
                order: [
                  ButtonType.play,
                  ButtonType.open,
                  ButtonType.download,
                  ButtonType.share,
                  ButtonType.delete,
                ],
              ),
            );
          },
        ),

        IconButton(
          icon: const Icon(Icons.home),
          tooltip: i18n.tr('title.albums'),
          onPressed: () => Navigator.pop(context),
        ),
      ],

      body: Column(
        children: [
          // Text(
          //   audio.title,
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     fontSize: themeProvider.customFont.fontSize,
          //     fontWeight: FontWeight.bold,
          //     fontFamily: themeProvider.customFont.fontFamily,
          //     fontStyle: themeProvider.customFont.fontStyle,
          //   ),
          // ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...?lines.map((line) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Html(
                        data: audio.content != null
                            ? normalizeLineBreaks(line)
                            : null,
                        style: {
                          "body": Style(
                            fontSize: FontSize(
                              themeProvider.customFont.fontSize,
                            ),
                            fontFamily: themeProvider.customFont.fontFamily,
                            fontStyle:
                                themeProvider.customFont.fontStyle ==
                                    FontStyle.italic
                                ? flutter_html.FontStyle.italic
                                : flutter_html.FontStyle.normal,
                            margin: Margins.zero,
                            fontWeight: FontWeight.w400,
                            padding: HtmlPaddings.zero,
                            textAlign: TextAlign.justify,
                          ),
                          "b": Style(fontWeight: FontWeight.bold),
                          "p": Style(margin: Margins.only(bottom: 2)),
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

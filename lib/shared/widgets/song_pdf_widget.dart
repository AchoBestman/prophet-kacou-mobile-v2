import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:prophet_kacou/core/models/song.dart'; // Ajustez selon votre modèle
import 'package:prophet_kacou/core/utils/notificaction.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slugify/slugify.dart';

/// Fonction pour convertir HTML en texte brut
String renderHtmlToText(String htmlString) {
  if (htmlString.isEmpty) return '';

  return htmlString;
  //final document = parse(htmlString);
  //return document.body?.text ?? htmlString;
}

/// Génère un PDF pour un cantique
Future<void> generateSongPdf(
  BuildContext context,
  Song? song, {
  String? albumTitle,
}) async {
  if (song == null) return;

  // Charger les polices NotoSans pour Unicode
  final fontRegular = pw.Font.ttf(
    await rootBundle.load("assets/fonts/NotoSans-Regular.ttf"),
  );
  final fontBold = pw.Font.ttf(
    await rootBundle.load("assets/fonts/NotoSans-Bold.ttf"),
  );

  try {
    final pdf = pw.Document(
      theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(font: fontRegular)),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          final List<pw.Widget> content = [];

          // HEADER: Titre + Album
          content.add(
            pw.Center(
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  if (albumTitle != null && albumTitle.isNotEmpty) ...[
                    pw.Text(
                      albumTitle,
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(width: 6),
                  ],
                  pw.Text(
                    song.title,
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );

          content.add(pw.SizedBox(height: 16));

          // CONTENU DU CANTIQUE
          if (song.content != null && song.content!.isNotEmpty) {
            // Diviser le contenu par lignes
            final lines = song.content!.split('\n');

            for (var line in lines) {
              final cleanedLine = renderHtmlToText(line);

              content.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Text(
                    cleanedLine,
                    textAlign: pw.TextAlign.justify,
                    style: pw.TextStyle(
                      font: fontRegular,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ),
              );
            }
          }

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: content,
          );
        },
      ),
    );

    // Sauvegarder et partager le PDF
    final output = await getTemporaryDirectory();
    final slug = slugify(song.title);
    final file = File('${output.path}/$slug.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(file.path)],
      text: song.title,
      subject: albumTitle,
    );
  } catch (e) {
    if (context.mounted) {
      log('Erreur lors de la génération du PDF: $e');
      NotificactionService.showErrorMessage(
        context,
        i18n.tr("home.an_error_occurred"),
      );
    }
  }
}

/// Génère un PDF pour plusieurs cantiques (album complet)
Future<void> generateAlbumPdf(
  BuildContext context,
  List<Song> songs,
  String albumTitle,
) async {
  if (songs.isEmpty) return;

  // Charger les polices
  final fontRegular = pw.Font.ttf(
    await rootBundle.load("assets/fonts/NotoSans-Regular.ttf"),
  );
  final fontBold = pw.Font.ttf(
    await rootBundle.load("assets/fonts/NotoSans-Bold.ttf"),
  );

  try {
    final pdf = pw.Document(
      theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(font: fontRegular)),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          final List<pw.Widget> content = [];

          // TITRE DE L'ALBUM
          content.add(
            pw.Header(
              level: 0,
              child: pw.Text(
                albumTitle,
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          );

          content.add(pw.SizedBox(height: 20));

          // CHAQUE CANTIQUE
          for (var i = 0; i < songs.length; i++) {
            final song = songs[i];

            // Titre du cantique
            content.add(
              pw.Text(
                song.title,
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            );

            content.add(pw.SizedBox(height: 8));

            // Contenu du cantique
            if (song.content != null && song.content!.isNotEmpty) {
              final lines = song.content!.split('\n');

              for (var line in lines) {
                final cleanedLine = renderHtmlToText(line);

                content.add(
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 6),
                    child: pw.Text(
                      cleanedLine,
                      textAlign: pw.TextAlign.justify,
                      style: pw.TextStyle(
                        font: fontRegular,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                );
              }
            }

            // Espacement entre cantiques
            if (i < songs.length - 1) {
              content.add(pw.SizedBox(height: 20));
              content.add(pw.Divider());
              content.add(pw.SizedBox(height: 20));
            }
          }

          return content;
        },
      ),
    );

    // Sauvegarder et partager
    final output = await getTemporaryDirectory();
    final slug = slugify(albumTitle);
    final file = File('${output.path}/$slug.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(file.path)],
      text: albumTitle,
      subject: 'Album de cantiques',
    );
  } catch (e) {
    if (context.mounted) {
      log('Erreur lors de la génération du PDF: $e');
      NotificactionService.showErrorMessage(
        context,
        i18n.tr("home.an_error_occurred"),
      );
    }
  }
}

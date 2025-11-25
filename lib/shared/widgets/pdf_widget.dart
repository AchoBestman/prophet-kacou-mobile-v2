import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:prophet_kacou/core/models/sermon.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/core/utils/notificaction.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slugify/slugify.dart';

Future<void> generateSermonPdf(BuildContext context, Sermon? sermon) async {
  if (sermon == null) return;

  // Récupérer l'image du sermon si disponible
  final Uint8List? imgBytes = sermon.image?.file != null
      ? Uint8List.fromList(sermon.image!.file!)
      : null;
  final bool hasImage = imgBytes != null && imgBytes.isNotEmpty;

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
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          final List<pw.Widget> content = [];

          // TITRE
          content.add(
            pw.Header(
              level: 0,
              child: pw.Text(
                "${sermon.chapter}: ${sermon.title}",
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 26,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          );

          if (sermon.subTitle != null) {
            content.add(
              pw.Center(
                child: pw.Text(
                  "${sermon.subTitle}",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.normal,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
              ),
            );
          }

          content.add(pw.SizedBox(height: 16));

          // IMAGE EN HAUT
          if (hasImage && sermon.number != 9) {
            final pageWidth = PdfPageFormat.a4.width;
            final horizontalMargin = 20.0; // marge gauche et droite
            content.add(
              pw.Center(
                child: pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 20),
                  width: pageWidth - 2 * horizontalMargin,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black),
                  ),
                  child: pw.Image(
                    pw.MemoryImage(imgBytes),
                    fit: pw.BoxFit.contain,
                    height: PdfPageFormat.a4.height * 0.4, // max 40% page
                  ),
                ),
              ),
            );
          }

          // VERSANTS
          if (sermon.verses != null) {
            for (final verse in sermon.verses!) {
              final verseWidgets = <pw.Widget>[];

              // Titre du verset
              if (verse.title != null && verse.title!.isNotEmpty) {
                verseWidgets.add(
                  pw.Text(
                    verse.title!,
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                );
                verseWidgets.add(pw.SizedBox(height: 4));
              }

              verseWidgets.add(
                pw.RichText(
                  textAlign:
                      pw.TextAlign.justify, // <-- Justification ajoutée ici
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: '${verse.number} ',
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.TextSpan(
                        text: verse.content.replaceAll(RegExp(r'<[^>]*>'), ''),
                        style: pw.TextStyle(font: fontRegular, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );

              content.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 12),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: verseWidgets,
                  ),
                ),
              );
            }
          }

          // IMAGE EN BAS si sermon.number == 9
          if (hasImage && sermon.number == 9) {
            final pageWidth = PdfPageFormat.a4.width;
            final horizontalMargin = 20.0; // marge gauche et droite
            content.add(
              pw.Center(
                child: pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 20),
                  width: pageWidth - 2 * horizontalMargin,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black),
                  ),
                  child: pw.Image(
                    pw.MemoryImage(imgBytes),
                    fit: pw.BoxFit.contain,
                    height: PdfPageFormat.a4.height * 0.4, // max 40% page
                  ),
                ),
              ),
            );
          }

          return content;
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final slug = slugify(sermonTitleFormatter(sermon));
    final file = File('${output.path}/$slug.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)], text: "${sermon.chapter}: ${sermon.title}", subject: "${sermon.subTitle}");
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

// Méthode pour générer l'EPUB (à implémenter)
Future<void> generateSermonEpub(BuildContext context, Sermon sermon) async {
  if (context.mounted) {
    NotificactionService.showSuccessMessage(
      context,
      i18n.tr("home.epub_not_available"),
    );
  }
}

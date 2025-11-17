// Méthode pour générer le PDF
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:prophet_kacou/core/models/sermon.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/core/utils/notificaction.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:slugify/slugify.dart';

Future<void> generatePdf(BuildContext context,  Sermon? sermon) async {
    if (sermon == null) return;

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text(
                  sermon.title,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              ...?sermon.verses?.map((verse) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 12),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (verse.title != null)
                        pw.Text(
                          verse.title!,
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: '${verse.number} ',
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.TextSpan(
                              text: verse.content.replaceAll(
                                RegExp(r'<[^>]*>'),
                                '',
                              ),
                              style: const pw.TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ];
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final slug = slugify(sermonTitleFormatter(sermon));
      final file = File('${output.path}/$slug.pdf');
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([XFile(file.path)], text: sermon.title);
    } catch (e) {
      if (context.mounted) {
        NotificactionService.showErrorMessage(
          context,
          'Erreur lors de la génération du PDF: $e',
        );
      }
    }
  }

  // Méthode pour générer l'EPUB (à implémenter)
  Future<void> generateSermonEpub(BuildContext context, Sermon sermon) async {
    // Implémentation future
    if (context.mounted) {
      NotificactionService.showSuccessMessage(
        context,
        'Génération EPUB en cours de développement',
      );
    }
  }
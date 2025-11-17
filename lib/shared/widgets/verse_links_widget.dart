import 'package:flutter/material.dart';
import 'package:prophet_kacou/core/models/sermon.dart';
import 'package:prophet_kacou/core/repositories/download_history_provider.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/core/utils/notificaction.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
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
  Map<String, double> _progress = {};


  Future<void> _downloadSermon(Sermon sermon) async {
    if (sermon.audio == null) return;

    try {
      final localFullPath = await localSermonPath(sermon, i18n.lang);

      if (!mounted) return;

      final downloadProvider = Provider.of<DownloadHistoryProvider>(
        context,
        listen: false,
      );

      await downloadProvider.startDownload(
        id: sermonIdInDownloadProviderFormatter(sermon),
        title: sermonTitleFormatter(sermon),
        audioUrl: sermon.audio!,
        filePath: localFullPath,
        albumTitle: sermon.subTitle,
        albumId: null,
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


  Future<void> _downloadLink(dynamic link) async {
    if (link.url == null || link.url!.isEmpty) return;

    String title = link.fileName ?? link.content ?? 'file';
    var _sermon = widget.sermon;
    //_sermon.title = title;

    final extension = link.type == 'audio'
        ? 'mp3'
        : link.type == 'video'
            ? 'mp4'
            : 'pdf';

    try {
      await _downloadSermon(_sermon);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur téléchargement: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.verseLinks == null || widget.verseLinks!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: widget.verseLinks!.asMap().entries.map((entry) {
        final index = entry.key;
        final link = entry.value;
        final title = link.fileName ?? link.content ?? 'file';
        final progress = _progress[title] ?? 0.0;
        final suffix =
            widget.verseLinks!.length > 1 ? '(${index + 1})' : '';

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[100],
                foregroundColor: Colors.blue[800],
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                textStyle: const TextStyle(fontSize: 12),
              ),
              onPressed: () => _downloadLink(link),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${link.content ?? ''} $suffix'),
                  if (progress > 0 && progress < 100) ...[
                    const SizedBox(width: 6),
                    Text('${progress.toStringAsFixed(0)}%'),
                  ],
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

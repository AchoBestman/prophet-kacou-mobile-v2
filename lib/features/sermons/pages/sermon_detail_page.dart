import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:prophet_kacou/core/models/sermon.dart';
import 'package:prophet_kacou/core/repositories/sermon.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';

class SermonDetailPage extends StatefulWidget {
  final int sermonId;

  const SermonDetailPage({super.key, required this.sermonId});

  @override
  State<SermonDetailPage> createState() => _SermonDetailPageState();
}

class _SermonDetailPageState extends State<SermonDetailPage> {
  final SermonRepository _repository = SermonRepository();
  Sermon? _sermon;
  bool _isLoading = true;
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _loadSermon();
  }

  Future<void> _loadSermon() async {
    try {
      final sermon = await _repository.findById(widget.sermonId, i18n.lang);
      setState(() {
        _sermon = sermon;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement du sermon : $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return MainLayout(
        title: 'Sermon',
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_sermon == null) {
      return MainLayout(
        title: 'Sermon',
        body: const Center(child: Text('Aucun sermon trouvé')),
      );
    }

    return MainLayout(
      title: _sermon!.title,
      actions: [
        IconButton(
          icon: const Icon(Icons.remove, color: Colors.white),
          onPressed: () {
            setState(() {
              if (_fontSize > 12) _fontSize -= 2;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            setState(() {
              if (_fontSize < 24) _fontSize += 2;
            });
          },
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_sermon!.image != null)
              // Center(
              //   child: Image.memory(_sermon!.image!, fit: BoxFit.cover),
              // ),
            const SizedBox(height: 16),
            ...?_sermon!.verses?.map((verse) => Padding(
                  padding: const EdgeInsets.only(bottom: 0, top: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 0,
                    children: [
                      if (verse.title != null)
                        Text(
                          verse.title!,
                          style: TextStyle(
                            fontSize: _fontSize + 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Html(
                              data: '${verse.number} ${verse.content}',
                              style: {
                                "body": Style(
                                  fontSize: FontSize(_fontSize),
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                )
                              },
                            ),
                          ),
                        ],
                      ),
                      // if (verse!.concordances!.isNotEmpty)
                      //   Wrap(
                      //     spacing: 6,
                      //     children: verse.concordances.map((c) {
                      //       return Chip(
                      //         label: Text(c.label),
                      //         backgroundColor: Colors.blue[50],
                      //       );
                      //     }).toList(),
                      //   ),

                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

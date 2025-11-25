import 'package:flutter/material.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/features/sermons/pages/sermon_detail_page.dart';

class ConcordanceWidget extends StatefulWidget {
  final List<ParsedReference>? concordances;
  final int currentSermonNumber;

  const ConcordanceWidget({
    super.key,
    required this.concordances,
    required this.currentSermonNumber,
  });

  @override
  State<ConcordanceWidget> createState() => _ConcordanceWidgetState();
}

class _ConcordanceWidgetState extends State<ConcordanceWidget> {
  String? _selectedConcordance;

  void _navigateToConcordance(ParsedReference c) {
    setState(() {
      _selectedConcordance = '${c.sermonNumber}-${c.verseNumber}';
    });

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SermonDetailPage(sermonNumber: c.sermonNumber, verseNumber: c.verseNumber),
          settings: RouteSettings(name: "/sermon-details")
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.concordances == null || widget.concordances!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: widget.concordances!.map((c) {
          final isSelected =
              _selectedConcordance == '${c.sermonNumber}-${c.verseNumber}';

          return GestureDetector(
            onTap: () => _navigateToConcordance(c),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[300] : Colors.blue[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                c.label ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.blue[800],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

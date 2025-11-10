// lib/features/biographies/pages/biographies_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:prophet_kacou/core/models/biography.dart';
import 'package:prophet_kacou/core/repositories/biography.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';

class BiographiesPage extends StatefulWidget {
  const BiographiesPage({super.key});

  @override
  State<BiographiesPage> createState() => _BiographiesPageState();
}

class _BiographiesPageState extends State<BiographiesPage> {
  final BiographyRepository _repository = BiographyRepository();
  Biography? _biography;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBiography();
  }

  Future<void> _loadBiography() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final currentLang = i18n.lang;
      final biography = await _repository.findBy(currentLang);
      
      setState(() {
        _biography = biography;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final headingColor = isDark ? Colors.orange : const Color(0xFF2d77a8);

    return MainLayout(
      title: i18n.tr('home.biography'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Erreur: $_error',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : _biography == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          i18n.tr('biography.not_available'),
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : _buildBiographyContent(headingColor),
    );
  }

  Widget _buildBiographyContent(Color headingColor) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildImage(),
                    ),
                  ),
                  _buildHtmlContent(headingColor),
                ],
              );
            }
            
            // Desktop: utiliser Wrap pour simuler le text wrapping
            return Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 16.0, top: 8.0),
                  child: _buildImage(),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth - 216, // Largeur totale - (200 + 16)
                  ),
                  child: _buildHtmlContent(headingColor),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Image.asset(
      'assets/images/photo-prophete.jpg',
      width: 200,
      height: 200,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 200,
          height: 200,
          color: Colors.grey[300],
          child: const Icon(
            Icons.person,
            size: 100,
            color: Colors.grey,
          ),
        );
      },
    );
  }

  Widget _buildHtmlContent(Color headingColor) {
    return Html(
      data: _biography!.description,
      style: {
        "body": Style(
          fontSize: FontSize(16),
          textAlign: TextAlign.justify,
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        "h1": Style(
          color: headingColor,
          fontSize: FontSize(22),
          fontWeight: FontWeight.bold,
          margin: Margins.only(bottom: 8, top: 8),
        ),
        "h2": Style(
          color: headingColor,
          fontSize: FontSize(22),
          fontWeight: FontWeight.bold,
          margin: Margins.only(bottom: 8, top: 8),
        ),
        "p": Style(
          textAlign: TextAlign.justify,
          margin: Margins.only(bottom: 12),
        ),
      },
    );
  }
}
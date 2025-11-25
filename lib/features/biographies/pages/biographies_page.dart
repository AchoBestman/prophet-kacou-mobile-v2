// lib/features/biographies/pages/biographies_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:prophet_kacou/app/themes/app_theme.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/biography.dart';
import 'package:prophet_kacou/core/repositories/biography.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as flutter_html;

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
      isHomePage: false,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  i18n.tr("home.an_error_occurred"),
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
          : _buildBiographyContent(headingColor, isDark),
    );
  }

  Widget _buildBiographyContent(Color headingColor, bool isDark) {
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
                  _buildHtmlContent(headingColor, isDark),
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
                    maxWidth:
                        constraints.maxWidth -
                        216, // Largeur totale - (200 + 16)
                  ),
                  child: _buildHtmlContent(headingColor, isDark),
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
          child: const Icon(Icons.person, size: 100, color: Colors.grey),
        );
      },
    );
  }

  Widget _buildHtmlContent(Color headingColor, bool isDark) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Html(
      data: normalizeLineBreaks(_biography!.description),
      
      style: {
        "*": Style.fromTextStyle(TextStyle()), // reset global
        "body": Style(
          fontSize: FontSize(themeProvider.customFont.fontSize),
          fontFamily: themeProvider.customFont.fontFamily,
          fontStyle: themeProvider.customFont.fontStyle == FontStyle.italic
              ? flutter_html.FontStyle.italic
              : flutter_html.FontStyle.normal,
          margin: Margins.zero,
          fontWeight: FontWeight.w400,
          padding: HtmlPaddings.zero,
          textAlign: TextAlign.left,
        ),
        "h1": Style(
          fontSize: FontSize(themeProvider.customFont.fontSize + 8),
          fontFamily: themeProvider.customFont.fontFamily,
          fontStyle: themeProvider.customFont.fontStyle == FontStyle.italic
              ? flutter_html.FontStyle.italic
              : flutter_html.FontStyle.normal,
          fontWeight: FontWeight.bold,
          margin: Margins.only(bottom: 4, top: 4),
          textAlign: TextAlign.left,
          color: isDark? Colors.white : pkpIndigo,
        ),
        "h2": Style(
          fontSize: FontSize(themeProvider.customFont.fontSize + 6),
          fontFamily: themeProvider.customFont.fontFamily,
          fontStyle: themeProvider.customFont.fontStyle == FontStyle.italic
              ? flutter_html.FontStyle.italic
              : flutter_html.FontStyle.normal,
          fontWeight: FontWeight.bold,
          margin: Margins.only(bottom: 4, top: 4),
          textAlign: TextAlign.left,
          color: isDark? Colors.white : pkpIndigo,
        ),
        "h3": Style(
          fontSize: FontSize(themeProvider.customFont.fontSize + 4),
          fontFamily: themeProvider.customFont.fontFamily,
          fontStyle: themeProvider.customFont.fontStyle == FontStyle.italic
              ? flutter_html.FontStyle.italic
              : flutter_html.FontStyle.normal,
          fontWeight: FontWeight.bold,
          margin: Margins.only(bottom: 10, top: 10),
          textAlign: TextAlign.start,
          letterSpacing: 1,
          color: isDark? Colors.white : pkpIndigo,
        ),
        "p": Style(
          textAlign: TextAlign.start,
          margin: Margins.only(bottom: 0, top: 0),
          color: isDark? Colors.white : pkpDark,
        ),
        "span": Style(
          textAlign: TextAlign.start,
          margin: Margins.only(bottom: 0, top: 0),
          color: isDark? Colors.white : pkpDark,
        ),
        "i": Style(
          margin: Margins.only(bottom: 0, top: 0),
          color: isDark? Colors.white : pkpIndigo,
        ),
        "a": Style(
          textAlign: TextAlign.justify,
          margin: Margins.only(bottom: 0, top: 0),
          color: isDark? Colors.white : pkpOcean,
        ),
        "b": Style(
          fontWeight: FontWeight.bold, 
          color: isDark? Colors.white : pkpDark,
          ),
        "strong": Style(
          fontWeight: FontWeight.bold, 
          color: isDark? Colors.white : pkpIndigo
        ),
      },
    );
  }

}

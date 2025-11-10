// lib/features/informations/pages/informations_page.dart
import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/information.dart';
import 'package:prophet_kacou/core/repositories/information.dart';
import 'package:prophet_kacou/features/informations/pages/information_detail_page.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';
import 'package:intl/intl.dart';

class InformationsPage extends StatefulWidget {
  const InformationsPage({super.key});

  @override
  State<InformationsPage> createState() => _InformationsPageState();
}

class _InformationsPageState extends State<InformationsPage> {
  final InformationRepository _repository = InformationRepository();
  final TextEditingController _searchController = TextEditingController();

  List<Information> _informations = [];
  int _currentPage = 1;
  final int _perPage = 20;
  int _totalCount = 0;
  bool _isLoading = false;
  bool _isSearching = false;
  String _searchQuery = '';
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _loadInformations();
  }

  Future<void> _loadInformations({bool refresh = false}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    if (refresh) {
      _currentPage = 1;
      _informations.clear();
    }

    try {
      final result = await _repository.findAll(
        lang: i18n.lang,
        page: _currentPage,
        perPage: _perPage,
        searchQuery: _searchQuery,
        orderBy: _isAscending ? '"date" ASC' : '"date" DESC',
      );

      setState(() {
        _informations.addAll(result.data);
        _totalCount = result.total;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
        _loadInformations(refresh: true);
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
    _loadInformations(refresh: true);
  }

  void _toggleSortOrder() {
    setState(() => _isAscending = !_isAscending);
    _loadInformations(refresh: true);
  }

  void _openInformationDetail(Information info) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InformationDetailPage(information: info),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MainLayout(
      title: i18n.tr('home.informations'),
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: _toggleSearch,
        ),
        IconButton(
          icon: Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward),
          onPressed: _toggleSortOrder,
        ),
      ],
      body: Column(
        children: [
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: i18n.tr('button.search'),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey.shade800 : Colors.white,
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          Expanded(
            child: _isLoading && _informations.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _informations.isEmpty
                ? Center(child: Text(i18n.tr('table.no_result')))
                : RefreshIndicator(
                    onRefresh: () => _loadInformations(refresh: true),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _informations.length,
                      itemBuilder: (context, index) {
                        final info = _informations[index];
                        return GestureDetector(
                          onTap: () => _openInformationDetail(info),
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            elevation: 0,
                            color: isDark ? pkpDark : pkpSand,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isDark ? Colors.white : Colors.blue,
                                width: 1,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    info.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('dd MMM yyyy').format(info.date),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

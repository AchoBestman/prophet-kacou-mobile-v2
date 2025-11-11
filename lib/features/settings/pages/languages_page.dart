// lib/features/langues/pages/languages_page.dart
import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/langue.dart';
import 'package:prophet_kacou/core/repositories/langue.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/features/sermons/pages/sermons_page.dart';
import 'package:prophet_kacou/features/settings/pages/update_button.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/i18n/language_provider.dart';
import 'package:prophet_kacou/i18n/langue_model.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';
import 'package:provider/provider.dart';

class LanguagesPage extends StatefulWidget {
  const LanguagesPage({super.key});

  @override
  State<LanguagesPage> createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage> {
  final LangueRepository _repository = LangueRepository();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final List<Langue> _langues = [];
  bool _isLoading = false;
  bool _isSearching = false;
  bool _isAscending = true;
  String _searchQuery = '';

  int _currentPage = 1;
  int _totalCount = 0;
  final int _perPage = 20;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadLangues();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        !_isLoading &&
        _hasMore) {
      _loadMoreLangues();
    }
  }

  Future<void> _loadLangues({bool refresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (refresh) {
        _currentPage = 1;
        _langues.clear();
      }
    });

    try {
      final result = await _repository.findAll(
        page: _currentPage,
        perPage: _perPage,
        name: _searchQuery.isEmpty ? null : _searchQuery,
        initial: _searchQuery.isEmpty ? null : _searchQuery,
        orderBy: _isAscending ? '"order" ASC' : '"order" DESC',
      );

      setState(() {
        _langues.addAll(result.data);
        _totalCount = result.total;
        _hasMore = _langues.length < _totalCount;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }

  Future<void> _loadMoreLangues() async {
    if (_hasMore && !_isLoading) {
      setState(() {
        _currentPage++;
      });
      await _loadLangues();
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
        _loadLangues(refresh: true);
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
    _loadLangues(refresh: true);
  }

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
    });
    _loadLangues(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final languageProvider = Provider.of<LanguageProvider>(context);

    Future<void> _checkForUpdates() async {
      // TODO: Implémenter la logique de recherche de mises à jour
      // Par exemple : vérifier les nouvelles traductions disponibles sur le serveur
      setState(() => _isLoading = true);

      try {
        // Logique de vérification...
        await Future.delayed(const Duration(seconds: 2)); // Simulation

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vérification terminée')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }

    return MainLayout(
      title: i18n.tr('home.langues'),
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: _toggleSearch,
        ),
        IconButton(
          icon: Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward),
          onPressed: _toggleSortOrder,
          tooltip: _isAscending ? 'A-Z' : 'Z-A',
        ),
        UpdateButton(
          isOnLanguagesPage: true,
          onUpdateCheck: _checkForUpdates, // Créez cette méthode
        ),
      ],
      body: Column(
        children: [
          if (_isSearching)
            Container(
              padding: const EdgeInsets.all(8.0),
              color: isDark ? pkpDark : pkpSand,
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
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey.shade800 : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _loadLangues(refresh: true),
              child: _langues.isEmpty && _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _langues.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          i18n.tr('table.no_result'),
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _langues.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _langues.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final langue = _langues[index];
                        return _buildLangueCard(
                          langue,
                          isDark,
                          languageProvider,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLangueCard(
    Langue langue,
    bool isDark,
    LanguageProvider languageProvider,
  ) {
    final countryCode = extractCountryCode(langue.initial).toLowerCase();
    final flagPath = 'assets/images/drapeau/$countryCode.jpg';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      elevation: 0,
      color: isDark ? pkpDark : pkpSand,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Colors.black12, width: 0.5),
      ),
      child: InkWell(
        onTap: () async {
          await languageProvider.changeLanguage(
            LanguageData(
              id: langue.id,
              name: langue.libelle,
              lang: langue.initial,
              countryFip: countryCode,
              icon: flagPath,
              translation: langue.webTranslation ?? "",
            ),
          );

          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SermonsPage()),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: Row(
            children: [
              // Drapeau
              Container(
                width: 48,
                height: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    flagPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Center(
                          child: Text(
                            langue.initial.toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      langue.libelle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      langue.initial.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // 4 icônes
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      // TODO: lecture audio
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(0),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.orange,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      // TODO: téléchargement
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Icon(
                        Icons.download_rounded,
                        color: isDark ? Colors.lightBlue : Colors.blue,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      // TODO: refresh
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(0),
                      child: Icon(
                        Icons.refresh_rounded,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      // TODO: delete
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(0),
                      child: Icon(
                        Icons.delete_rounded,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

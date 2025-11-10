// lib/features/assemblies/pages/assemblies_page.dart
import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/country.dart';
import 'package:prophet_kacou/core/repositories/country.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';

class AssembliesPage extends StatefulWidget {
  const AssembliesPage({super.key});

  @override
  State<AssembliesPage> createState() => _AssembliesPageState();
}

class _AssembliesPageState extends State<AssembliesPage> {
  final CountryRepository _repository = CountryRepository();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Country> _countries = [];
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
    _loadCountries();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        !_isLoading &&
        _hasMore) {
      _loadMoreCountries();
    }
  }

  Future<void> _loadCountries({bool refresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (refresh) {
        _currentPage = 1;
        _countries.clear();
      }
    });

    try {
      final result = await _repository.findAll(
        page: _currentPage,
        perPage: _perPage,
        name: _searchQuery.isEmpty ? null : _searchQuery,
        orderBy: _isAscending ? 'name ASC' : 'name DESC',
        isActive: true,
      );

      setState(() {
        _countries.addAll(result.data);
        _totalCount = result.total;
        _hasMore = _countries.length < _totalCount;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  Future<void> _loadMoreCountries() async {
    if (_hasMore && !_isLoading) {
      setState(() {
        _currentPage++;
      });
      await _loadCountries();
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
        _loadCountries(refresh: true);
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
    _loadCountries(refresh: true);
  }

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
    });
    _loadCountries(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MainLayout(
      title: i18n.tr('home.countries'),
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
      ],
      body: Column(
        children: [
          // Barre de recherche dans le body
          if (_isSearching)
            Container(
              padding: const EdgeInsets.all(8.0),
              color: isDark ? pkpDark: pkpSand,
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
          
          // Liste des pays
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _loadCountries(refresh: true),
              child: _countries.isEmpty && _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _countries.isEmpty
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
                          padding: EdgeInsets.only(top: 5),
                          itemCount: _countries.length + (_hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= _countries.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final country = _countries[index];
                            return _buildCountryCard(country, isDark);
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryCard(Country country, bool isDark) {
    final flagPath = 'assets/images/drapeau/${country.sigle.toLowerCase()}.jpg';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      elevation: 0,
      color: isDark ? pkpDark : pkpSand,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(
          color: Colors.black12,
          width: 0.5,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Navigation vers les détails du pays
          // Navigator.push(context, ...);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 6.0,
          ),
          child: Row(
            children: [
              // Drapeau
              Container(
                width: 50,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
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
                            country.sigle,
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
              
              // Informations du pays
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      country.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
           
                    Text(
                      country.sigle.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Icône chevron
              Icon(
                Icons.chevron_right,
                color: isDark ? Colors.white : Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
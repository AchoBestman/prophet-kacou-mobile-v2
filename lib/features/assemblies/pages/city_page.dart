// lib/features/assemblies/pages/city_page.dart
import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/city.dart';
import 'package:prophet_kacou/core/models/country.dart';
import 'package:prophet_kacou/core/repositories/city.dart';
import 'package:prophet_kacou/features/assemblies/pages/assemblies_detail_page.dart';
import 'package:prophet_kacou/i18n/i18n.dart';

class CityPage extends StatefulWidget {
  final Country country;

  const CityPage({super.key, required this.country});

  @override
  State<CityPage> createState() => _CityPageState();
}

class _CityPageState extends State<CityPage>
    with SingleTickerProviderStateMixin {
  final CityRepository _repository = CityRepository();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late TabController _tabController;

  final List<City> _cities = [];
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
    _tabController = TabController(length: 2, vsync: this);
    _loadCities();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        !_isLoading &&
        _hasMore) {
      _loadMoreCities();
    }
  }

  Future<void> _loadCities({bool refresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (refresh) {
        _currentPage = 1;
        _cities.clear();
      }
    });

    try {
      final result = await _repository.findAll(
        page: _currentPage,
        perPage: _perPage,
        libelle: _searchQuery.isEmpty ? null : _searchQuery,
        countryId: widget.country.id,
        orderBy: _isAscending ? 'cities."order" ASC' : 'cities."order" DESC',
        isActive: true,
      );

      setState(() {
        _cities.addAll(result.data);
        _totalCount = result.total;
        _hasMore = _cities.length < _totalCount;
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

  Future<void> _loadMoreCities() async {
    if (_hasMore && !_isLoading) {
      setState(() {
        _currentPage++;
      });
      await _loadCities();
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
        _loadCities(refresh: true);
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
    _loadCities(refresh: true);
  }

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
    });
    _loadCities(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.country.name,
        ),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: Icon(
              _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
            ),
            onPressed: _toggleSortOrder,
            tooltip: _isAscending ? 'A-Z' : 'Z-A',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: isDark ? theme.tabBarTheme.labelColor : Colors.white,
          unselectedLabelColor: theme.tabBarTheme.unselectedLabelColor,
          indicatorColor: isDark ? theme.tabBarTheme.labelColor : Colors.white,
          tabs: const [
            Tab(text: 'Assemblies'),
            Tab(text: 'Apostle'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            // Tab Assemblies
            _buildAssembliesTab(isDark),
            // Tab Apostle
            _buildApostleTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAssembliesTab(bool isDark) {
    return Column(
      children: [
        // Barre de recherche
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

        // Liste des villes
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _loadCities(refresh: true),
            child: _cities.isEmpty && _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _cities.isEmpty
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
                    padding: const EdgeInsets.only(top: 5),
                    itemCount: _cities.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= _cities.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final city = _cities[index];
                      return _buildCityCard(city, isDark);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildApostleTab() {
    return const Center(
      child: Text('Apostle Tab', style: TextStyle(fontSize: 18)),
    );
  }

  Widget _buildCityCard(City city, bool isDark) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      elevation: 0,
      color: isDark ? pkpDark : pkpSand,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Colors.black12, width: 0.5),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AssembliesDetailPage(city: city)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: Row(
            children: [
              // Icône de la ville
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  Icons.location_city,
                  color: isDark ? Colors.white : Theme.of(context).primaryColor,
                  size: 28,
                ),
              ),

              const SizedBox(width: 16),

              // Informations de la ville
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      city.libelle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (city.description != null &&
                        city.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          city.description!,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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

import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/assembly.dart';
import 'package:prophet_kacou/core/models/city.dart';
import 'package:prophet_kacou/core/repositories/assembly.dart';
import 'package:prophet_kacou/i18n/i18n.dart';

class AssembliesDetailPage extends StatefulWidget {
  final City city;

  const AssembliesDetailPage({super.key, required this.city});

  @override
  State<AssembliesDetailPage> createState() => _AssembliesDetailPageState();
}

class _AssembliesDetailPageState extends State<AssembliesDetailPage> {
  final AssemblyRepository _repository = AssemblyRepository();
  final TextEditingController _searchController = TextEditingController();

  final List<Assembly> _assemblies = [];
  bool _isLoading = false;
  bool _isSearching = false;
  bool _isAscending = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAssemblies();
  }

  Future<void> _loadAssemblies() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final result = await _repository.findAll(
        cityId: widget.city.id,
        name: _searchQuery.isNotEmpty ? _searchQuery : null,
        orderBy: _isAscending ? 'assemblies.name ASC' : 'assemblies.name DESC',
        isActive: true,
      );

      setState(() {
        _assemblies
          ..clear()
          ..addAll(result.data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
        _loadAssemblies();
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
    _loadAssemblies();
  }

  void _toggleSortOrder() {
    setState(() => _isAscending = !_isAscending);
    _loadAssemblies();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.city.libelle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
            tooltip: _isAscending ? 'A–Z' : 'Z–A',
          ),
        ],
      ),
      body: SafeArea(child: Column(
        children: [
          if (_isSearching)
            Container(
              padding: const EdgeInsets.all(8),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey.shade800 : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _assemblies.isEmpty
                ? Center(
                    child: Text(
                      i18n.tr('table.no_result'),
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _assemblies.length,
                    itemBuilder: (context, index) {
                      final assembly = _assemblies[index];
                      return _buildAssemblyCard(assembly, isDark);
                    },
                  ),
          ),
        ],
      )),
    );
  }

Widget _buildAssemblyCard(Assembly assembly, bool isDark) {
  final head = assembly.head;
  final phones = (head?.phone != null && head!.phone!.isNotEmpty)
      ? head.phone!.split('/')
      : [];

  // Style commun pour tous les textes sauf taille
  TextStyle commonTextStyle(double fontSize) => TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black87,
      );

  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    elevation: 3,
    color: isDark ? pkpDark : pkpSand,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: isDark ? Colors.white : pkpIndigo),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nom de l'assemblée
          Text(
            assembly.name ?? '—',
            style: commonTextStyle(20),
          ),
          const SizedBox(height: 12),

          // Responsable
          if (head != null)
            Row(
              children: [
                Icon(Icons.person, size: 18, color: isDark ? Colors.white70 : Colors.grey[700]),
                const SizedBox(width: 8),
                Text(head.fullName, style: commonTextStyle(16)),
              ],
            ),
          if (head != null) const SizedBox(height: 8),

          // Téléphones
          if (phones.isNotEmpty)
            ...phones.map((phone) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Icon(Icons.phone, size: 18, color: isDark ? Colors.white70 : Colors.grey[700]),
                      const SizedBox(width: 8),
                      Text(phone.trim(), style: commonTextStyle(15)),
                    ],
                  ),
                )),
          if (phones.isNotEmpty) const SizedBox(height: 8),

          // Email
          if (head?.email != null && head!.email!.isNotEmpty)
            Row(
              children: [
                Icon(Icons.email, size: 18, color: isDark ? Colors.white70 : Colors.grey[700]),
                const SizedBox(width: 8),
                Text(head.email!, style: commonTextStyle(13)),
              ],
            ),
          if (head?.email != null && head!.email!.isNotEmpty) const SizedBox(height: 8),

          // Adresse
          if (assembly.address != null && assembly.address!.isNotEmpty)
            Row(
              children: [
                Icon(Icons.location_on, size: 18, color: isDark ? Colors.white70 : Colors.grey[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(assembly.address!, style: commonTextStyle(13)),
                ),
              ],
            ),
          if (assembly.address != null && assembly.address!.isNotEmpty) const SizedBox(height: 8),

          // Localisation
          if (assembly.localisation != null && assembly.localisation!.isNotEmpty)
            Row(
              children: [
                Icon(Icons.map, size: 18, color: isDark ? Colors.white70 : Colors.grey[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(assembly.localisation!, style: commonTextStyle(13)),
                ),
              ],
            ),
        ],
      ),
    ),
  );
}

}

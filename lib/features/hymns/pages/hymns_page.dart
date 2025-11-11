import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/album.dart';
import 'package:prophet_kacou/core/repositories/album.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';
import 'album_detail_page.dart';

class HymnsPage extends StatefulWidget {
  const HymnsPage({super.key});

  @override
  State<HymnsPage> createState() => _HymnsPageState();
}

class _HymnsPageState extends State<HymnsPage> {
  final AlbumRepository _repository = AlbumRepository();
  final TextEditingController _searchController = TextEditingController();

  List<Album> _albums = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String _searchQuery = '';
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _loadAlbums();
  }

  Future<void> _loadAlbums({bool refresh = false}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    if (refresh) _albums.clear();

    try {
      final result = await _repository.findAll(
        searchQuery: _searchQuery,
        orderBy: _isAscending ? '"order" ASC' : '"order" DESC',
      );

      setState(() {
        _albums = result.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
        _loadAlbums(refresh: true);
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
    _loadAlbums(refresh: true);
  }

  void _toggleSortOrder() {
    setState(() => _isAscending = !_isAscending);
    _loadAlbums(refresh: true);
  }

  void _openAlbumDetail(Album album) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AlbumDetailPage(album: album)),
    );
  }

  Widget _buildAlbumCard(Album album, bool isDark) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      elevation: 0,
      color: isDark ? pkpDark : pkpSand,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Colors.black12, width: 0.5),
      ),
      child: InkWell(
        onTap: () => _openAlbumDetail(album),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: Row(
            children: [
              // Icône album (remplace le drapeau)
              Container(
                width: 50,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.white, width: 0.5),
                ),
                child: const Center(
                  child: Icon(
                    Icons.playlist_play,
                    color: Colors.blueAccent,
                    size: 24,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Infos de l’album
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      album.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (album.description != null &&
                        album.description!.trim().isNotEmpty)
                      Text(
                        album.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),

              // Chevron
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MainLayout(
      title: i18n.tr('home.hymns'),
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _albums.isEmpty
                    ? Center(child: Text(i18n.tr('table.no_result')))
                    : RefreshIndicator(
                        onRefresh: () => _loadAlbums(refresh: true),
                        child: ListView.builder(
                          itemCount: _albums.length,
                          itemBuilder: (context, index) {
                            final album = _albums[index];
                            return _buildAlbumCard(album, isDark);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

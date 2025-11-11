import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/album.dart';
import 'package:prophet_kacou/core/models/song.dart';
import 'package:prophet_kacou/core/repositories/song.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';

class AlbumDetailPage extends StatefulWidget {
  final Album album;

  const AlbumDetailPage({super.key, required this.album});

  @override
  State<AlbumDetailPage> createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  final SongRepository _repository = SongRepository();
  final TextEditingController _searchController = TextEditingController();

  List<Song> _songs = [];
  List<Song> _filteredSongs = [];
  bool _isLoading = false;
  bool _isSearching = false;
  bool _isAscending = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    setState(() => _isLoading = true);
    try {
      final result = await _repository.findAll(
        albumId: widget.album.id,
        isActive: true,
        searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
        orderBy: _isAscending ? '"order" ASC' : '"order" DESC',
      );

      setState(() {
        _songs = result.data;
        _filteredSongs = _songs;
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
        _filteredSongs = _songs;
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _filteredSongs = _songs
          .where(
            (s) =>
                s.title.toLowerCase().contains(value.toLowerCase()) ||
                (s.content != null &&
                    s.content!.toLowerCase().contains(value.toLowerCase())),
          )
          .toList();
    });
  }

  void _toggleSortOrder() {
    setState(() => _isAscending = !_isAscending);
    _loadSongs();
  }

  Widget _buildSongCard(Song song, int index, bool isDark) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      elevation: 0,
      color: isDark ? pkpDark : pkpSand,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Colors.black12, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Row(
          children: [
            const Icon(
              Icons.music_note_rounded,
              color: Colors.deepPurple,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${index + 1} - ${song.title}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (song.audio != null)
                  InkWell(
                    onTap: () {
                      // TODO: logique lecture audio
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(
                        0.0,
                      ), // Contrôle total du padding
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.orange[600],
                        size: 20,
                      ),
                    ),
                  ),
                const SizedBox(width: 4), // Espacement entre les icônes
                if (song.audio != null)
                  InkWell(
                    onTap: () {
                      // TODO: logique téléchargement
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Icon(
                        Icons.download_rounded,
                        color: isDark ? Colors.lightBlue : Colors.blue,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MainLayout(
      title: widget.album.title,
      actions: [
        Transform.scale(
          scale: 0.85,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(_isSearching ? Icons.close : Icons.search),
                tooltip: i18n.tr('button.search'),
                onPressed: _toggleSearch,
              ),
              IconButton(
                icon: Icon(
                  _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                ),
                tooltip: i18n.tr('button.order'),
                onPressed: _toggleSortOrder,
              ),
              IconButton(
                icon: const Icon(Icons.home),
                tooltip: i18n.tr('title.albums'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
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
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredSongs.isEmpty
                ? Center(child: Text(i18n.tr('table.no_result')))
                : RefreshIndicator(
                    onRefresh: _loadSongs,
                    child: ListView.builder(
                      itemCount: _filteredSongs.length,
                      itemBuilder: (context, index) {
                        final song = _filteredSongs[index];
                        return _buildSongCard(song, index, isDark);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

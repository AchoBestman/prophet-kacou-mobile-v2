import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:prophet_kacou/core/models/photo.dart';
import 'package:prophet_kacou/core/repositories/photo.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';

class PhotosPage extends StatefulWidget {
  const PhotosPage({super.key});

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  final PhotoRepository _repository = PhotoRepository();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isAscending = true;
  String _searchQuery = '';
  bool _isLoading = false;

  final List<Photo> _photos = [];
  int _currentPage = 1;
  final int _perPage = 20;
  int _totalCount = 0;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos({bool refresh = false}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    if (refresh) {
      _currentPage = 1;
      _photos.clear();
    }

    try {
      final result = await _repository.findAll(
        lang: i18n.lang,
        page: _currentPage,
        perPage: _perPage,
        searchQuery: _searchQuery,
        orderBy: _isAscending ? '"order" ASC' : '"order" DESC',
      );

      setState(() {
        _photos.addAll(result.data);
        _totalCount = result.total;
        _hasMore = _photos.length < _totalCount;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
        _loadPhotos(refresh: true);
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
    _loadPhotos(refresh: true);
  }

  void _toggleSortOrder() {
    setState(() => _isAscending = !_isAscending);
    _loadPhotos(refresh: true);
  }

  void _openPhotoGallery(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoGalleryPage(
          photos: _photos,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MainLayout(
      title: i18n.tr('home.photos'),
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
  child: _isLoading && _photos.isEmpty
      ? const Center(child: CircularProgressIndicator())
      : _photos.isEmpty
          ? Center(child: Text(i18n.tr('table.no_result')))
          : RefreshIndicator(
              onRefresh: () => _loadPhotos(refresh: true),
              child: LayoutBuilder(
  builder: (context, constraints) {
    int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;

    // Déterminer le nombre de lignes visibles par écran
    int rows = 2;

    // Calculer l'aspect ratio pour afficher au moins 2 photos par écran
    double gridHeight = constraints.maxHeight;
    double cardHeight = gridHeight / rows;
    double childAspectRatio = constraints.maxWidth / crossAxisCount / cardHeight;

    final filteredPhotos = _searchQuery.isEmpty
        ? _photos
        : _photos.where((photo) {
            final query = _searchQuery.toLowerCase();
            final title = photo.title?.toLowerCase() ?? '';
            final description = photo.description?.toLowerCase() ?? '';
            return title.contains(query) || description.contains(query);
          }).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: filteredPhotos.length,
      itemBuilder: (context, index) {
        final photo = filteredPhotos[index];
        return GestureDetector(
          onTap: () => _openPhotoGallery(index),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isDark ? Colors.white : Colors.blue,
                width: 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: photo.url.startsWith('http')
                      ? Image.network(
                          photo.url,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image),
                        )
                      : const Icon(Icons.broken_image),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (photo.title != null)
                        Text(
                          photo.title!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (photo.description != null)
                        Text(
                          photo.description!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  },
)

            ),
),

        ],
      ),
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
    );
  }
}

/// Page pour afficher photo plein écran avec zoom
class PhotoGalleryPage extends StatelessWidget {
  final List<Photo> photos;
  final int initialIndex;

  const PhotoGalleryPage({
    super.key,
    required this.photos,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PhotoViewGallery.builder(
        itemCount: photos.length,
        pageController: PageController(initialPage: initialIndex),
        builder: (context, index) {
          final photo = photos[index];
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(photo.url),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.0,
            heroAttributes: PhotoViewHeroAttributes(tag: photo.id),
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}

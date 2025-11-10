import 'package:flutter/material.dart';
import 'package:prophet_kacou/core/models/video.dart';
import 'package:prophet_kacou/core/repositories/video.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  final VideoRepository _repository = VideoRepository();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isAscending = true;
  String _searchQuery = '';
  bool _isLoading = false;

  final List<Video> _videos = [];
  int _currentPage = 1;
  final int _perPage = 20;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos({bool refresh = false}) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    if (refresh) {
      _currentPage = 1;
      _videos.clear();
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
        _videos.addAll(result.data);
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
        _loadVideos(refresh: true);
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
    _loadVideos(refresh: true);
  }

  void _toggleSortOrder() {
    setState(() => _isAscending = !_isAscending);
    _loadVideos(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MainLayout(
      title: i18n.tr('home.videos'),
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
            child: _isLoading && _videos.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _videos.isEmpty
                ? Center(child: Text(i18n.tr('table.no_result')))
                : RefreshIndicator(
                    onRefresh: () => _loadVideos(refresh: true),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _videos.length,
                      itemBuilder: (context, index) {
                        final video = _videos[index];
                        final videoId = getVideoId(video.url);
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isDark ? Colors.white : Colors.blue,
                              width: 1,
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              YoutubePlayer(
                                controller: YoutubePlayerController(
                                  initialVideoId: videoId,
                                  flags: const YoutubePlayerFlags(
                                    autoPlay: false,
                                    mute: false,
                                  ),
                                ),
                                showVideoProgressIndicator: true,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (video.title != null)
                                      Text(
                                        video.title!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    if (video.description != null)
                                      Text(
                                        video.description!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark
                                              ? Colors.white70
                                              : Colors.black87,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
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

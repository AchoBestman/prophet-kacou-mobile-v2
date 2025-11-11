import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/sermon.dart';
import 'package:prophet_kacou/core/repositories/sermon.dart';
import 'package:prophet_kacou/features/sermons/pages/sermon_detail_page.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';

class SermonsPage extends StatefulWidget {
  const SermonsPage({super.key});

  @override
  State<SermonsPage> createState() => _SermonsPageState();
}

class _SermonsPageState extends State<SermonsPage>
    with SingleTickerProviderStateMixin {
  bool ascending = true;
  String searchQuery = '';
  late TabController _tabController;
  final SermonRepository repository = SermonRepository();

  List<Sermon> sermonsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSermons();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSermons() async {
    setState(() => isLoading = true);
    try {
      final result = await repository.findAll(
        lang: i18n.lang,
        searchQuery: searchQuery,
        orderBy: 'number ${ascending ? "ASC" : "DESC"}',
      );

      setState(() {
        sermonsList = result;
        isLoading = false;
      });
    } catch (e) {
      print("Erreur lors du chargement des sermons : $e");
      setState(() => isLoading = false);
    }
  }

  void _toggleOrder() {
    setState(() {
      ascending = !ascending;
    });
    _loadSermons();
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
    _loadSermons();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MainLayout(
      title: "Sermons",
      actions: [
        // 🔍 Recherche
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () async {
            final query = await showSearch<String>(
              context: context,
              delegate: SermonSearchDelegate(onSearch: _onSearchChanged),
            );
            if (query != null) {
              _onSearchChanged(query);
            }
          },
        ),
        // 🔽 Tri
        IconButton(
          icon: Icon(
            ascending ? Icons.arrow_downward : Icons.arrow_upward,
            color: Colors.white,
          ),
          onPressed: _toggleOrder,
        ),
      ],
      body: Column(
        children: [
          Container(
            color: theme.scaffoldBackgroundColor,
            child: TabBar(
              controller: _tabController,
              labelColor: theme.tabBarTheme.labelColor,
              unselectedLabelColor: theme.tabBarTheme.unselectedLabelColor,
              indicatorColor: theme.tabBarTheme.indicatorColor,
              tabs: const [
                Tab(text: 'SERMONS'),
                Tab(text: 'READ A PASSAGE'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                RefreshIndicator(
                  onRefresh: _loadSermons,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: sermonsList.length,
                          itemBuilder: (context, index) {
                            final sermon = sermonsList[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        SermonDetailPage(sermonId: sermon.id),
                                  ),
                                );
                              },
                              child: Card(
                                color: isDark ? pkpDark : pkpSand,
                                margin: const EdgeInsets.symmetric(vertical: 1),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 🔹 Ligne du haut : Chapter et Publication Date
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            sermon.chapter,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: isDark
                                                  ? Colors.lightBlue
                                                  : Colors.blue,
                                            ),
                                          ),
                                          if (sermon.publicationDate != null)
                                            Text(
                                              sermon.publicationDate!,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: isDark
                                                    ? Colors.lightBlue
                                                    : Colors.blue,
                                              ),
                                            ),
                                        ],
                                      ),

                                      // 🔹 Titre du sermon
                                      Text(
                                        sermon.title,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color:
                                              theme.textTheme.bodyLarge?.color,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),

                                      // 🔹 Boutons en bas à droite
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          if (sermon.audio != null)
                                            InkWell(
                                              onTap: () {
                                                // TODO: logique lecture audio
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                          const SizedBox(
                                            width: 4,
                                          ), // Espacement entre les icônes
                                          if (sermon.audio != null)
                                            InkWell(
                                              onTap: () {
                                                // TODO: logique téléchargement
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  0.0,
                                                ),
                                                child: Icon(
                                                  Icons.download_rounded,
                                                  color: isDark
                                                      ? Colors.lightBlue
                                                      : Colors.blue,
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
                          },
                        ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: const Text("No passage selected yet."),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔍 Délégué pour la recherche
class SermonSearchDelegate extends SearchDelegate<String> {
  final Function(String) onSearch;

  SermonSearchDelegate({required this.onSearch});

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        query = '';
        onSearch(query);
      },
    ),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, ''),
  );

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    close(context, query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}

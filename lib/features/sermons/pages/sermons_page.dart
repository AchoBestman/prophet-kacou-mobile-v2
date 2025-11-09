import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/models/sermon_model.dart';
import 'package:prophet_kacou/features/sermons/pages/sermon_detail_page.dart';
import 'package:prophet_kacou/features/sermons/services/sermon_service.dart';
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
  late TabController _tabController;
  final SermonService service = SermonService();
  
  List<Sermon> sermonsList = [];

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
    try {
      final result = await service.findAll(
        'fr-fr',
        params: {'per_page': 174},
        order: {'column': 'number', 'direction': ascending ? 'ASC' : 'DESC'},
      );

      setState(() {
        sermonsList = List<Sermon>.from(result.data);
      });
    } catch (e) {
      print("Erreur lors du chargement des sermons : $e");
    }
  }

  void _toggleOrder() {
    setState(() {
      ascending = !ascending;
      sermonsList = List<Sermon>.from(sermonsList)
        ..sort(
          (a, b) => ascending
              ? a.number.compareTo(b.number)
              : b.number.compareTo(a.number),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MainLayout(
      title: i18n.tr('home.sermon'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Recherche globale')));
          },
        ),
        IconButton(
          icon: Icon(
            ascending ? Icons.arrow_downward : Icons.arrow_upward,
            color: Colors.white,
          ),
          onPressed: _toggleOrder,
          tooltip: ascending
              ? 'Trier par ordre décroissant'
              : 'Trier par ordre croissant',
        ),
      ],
      body: Column(
        children: [
          // TabBar avec background adapté au thème
          Container(
            color: theme.scaffoldBackgroundColor,
            child: TabBar(
              controller: _tabController,
              labelColor: theme.tabBarTheme.labelColor,
              unselectedLabelColor: theme.tabBarTheme.unselectedLabelColor,
              indicatorColor: theme.tabBarTheme.indicatorColor,
              tabs: const [
                Tab(text: 'THE 74 SERMONS'),
                Tab(text: 'READ A PASSAGE'),
              ],
            ),
          ),
          // Contenu des onglets
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Liste des sermons
                RefreshIndicator(
                  onRefresh: _loadSermons,
                  child: Container(
                    color: theme.scaffoldBackgroundColor,
                    child: ListView.builder(
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
                                    SermonDetailPage(sermon: sermon),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 0.6,
                              horizontal: 0,
                            ),
                            elevation: 1,
                            // ✅ Enlever color pour utiliser theme.cardTheme.color automatiquement
                            color: isDark ? pkpDark :pkpSand,
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          sermon.chapter,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? Colors.lightBlue
                                                : Colors.blue,
                                          ),
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
                                  const SizedBox(height: 4),
                                  Text(
                                    sermon.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: theme.textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 6),
                                  if (sermon.audio != null)
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            style: ButtonStyle(
                                              elevation:
                                                  WidgetStateProperty.all(0),
                                              padding: WidgetStateProperty.all(
                                                EdgeInsets.zero,
                                              ),
                                              minimumSize:
                                                  WidgetStateProperty.all(
                                                    Size.zero,
                                                  ),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            icon: Icon(
                                              Icons.play_arrow,
                                              color: Colors.orange[600],
                                            ),
                                            onPressed: () {
                                              // Logique play/pause
                                            },
                                          ),
                                          IconButton(
                                            style: ButtonStyle(
                                              elevation:
                                                  WidgetStateProperty.all(0),
                                              minimumSize:
                                                  WidgetStateProperty.all(
                                                    Size.zero,
                                                  ),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              padding: WidgetStateProperty.all(
                                                EdgeInsets.zero,
                                              ),
                                            ),
                                            icon: Icon(
                                              Icons.download,
                                              color: isDark
                                                  ? Colors.lightBlue
                                                  : Colors.blue,
                                            ),
                                            onPressed: () {
                                              // Logique téléchargement
                                            },
                                          ),
                                        ],
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
                // Onglet 2
                Container(
                  color: theme.scaffoldBackgroundColor,
                  child: Center(
                    child: Text(
                      'No passage selected yet.',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.grey[400] : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

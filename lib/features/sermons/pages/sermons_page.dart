import 'package:flutter/material.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';
import 'package:prophet_kacou/features/sermons/pages/sermon_detail_page.dart';

class SermonsPage extends StatefulWidget {
  const SermonsPage({super.key});

  @override
  State<SermonsPage> createState() => _SermonsPageState();
}

class _SermonsPageState extends State<SermonsPage>
    with SingleTickerProviderStateMixin {
  bool ascending = true; // 🔁 État du tri
  late TabController _tabController;

  // 🔹 Exemple de données des 174 sermons (ici simulées)
  final List<Map<String, String>> sermons = List.generate(
    174,
    (index) => {
      'title': 'Kacou ${index + 1}: Sermon ${index + 1}',
      'date': '202${index % 5}-0${(index % 9) + 1}-15',
    },
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleOrder() {
    setState(() {
      ascending = !ascending;
      sermons.sort((a, b) => ascending
          ? a['title']!.compareTo(b['title']!)
          : b['title']!.compareTo(a['title']!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: i18n.tr('home.sermon'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Recherche globale')),
            );
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
          // 🔹 Onglets
          TabBar(
            controller: _tabController,
            labelColor: Colors.indigo,
            indicatorColor: Colors.indigo,
            tabs: const [
              Tab(text: 'THE 74 SERMONS'),
              Tab(text: 'READ A PASSAGE'),
            ],
          ),
          // 🔹 Contenu des onglets
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 🧾 Onglet 1 : Liste des sermons
                ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: sermons.length,
                  itemBuilder: (context, index) {
                    final sermon = sermons[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      elevation: 1,
                      child: ListTile(
                        title: Text(
                          sermon['title']!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(sermon['date']!),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SermonDetailPage(
                                title: sermon['title']!,
                                date: sermon['date']!,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                // 📖 Onglet 2 : Lecture de passage
                const Center(
                  child: Text(
                    'No passage selected yet.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
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

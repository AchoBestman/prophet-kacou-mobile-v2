import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:prophet_kacou/core/models/download_progress.dart';
import 'package:prophet_kacou/core/models/langue.dart';
import 'package:prophet_kacou/core/repositories/langue.dart';
import 'package:prophet_kacou/core/services/download_manager.dart';
import 'package:prophet_kacou/core/utils/alert_dialog.dart';
import 'package:prophet_kacou/core/utils/connection.dart';
import 'package:prophet_kacou/core/utils/download_utils.dart';
import 'package:prophet_kacou/core/utils/langues.dart';
import 'package:prophet_kacou/core/utils/notificaction.dart';
import 'package:prophet_kacou/features/sermons/pages/sermons_page.dart';
import 'package:prophet_kacou/features/settings/pages/update_button.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/i18n/language_provider.dart';
import 'package:prophet_kacou/i18n/langue_model.dart';
import 'package:prophet_kacou/shared/layouts/main_layout.dart';
import 'package:provider/provider.dart';

class LanguagesPage extends StatefulWidget {
  const LanguagesPage({super.key});

  @override
  State<LanguagesPage> createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage> {
  final LangueRepository _repository = LangueRepository();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final updateButtonKey = GlobalKey<UpdateButtonState>();

  final Map<String, StreamSubscription> _downloadSubscriptions = {};
  final Map<String, DownloadProgress> _downloadProgresses = {};
  final DownloadManager _downloadManager = DownloadManager();
  final Set<String> _preparingDownloads = {};
  List<dynamic> _updates = [];

  final List<Langue> _langues = [];
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
    _loadLangues();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        !_isLoading &&
        _hasMore) {
      _loadMoreLangues();
    }
  }

  Future<void> _refreshDbUpdates() async {
    updateButtonKey.currentState?.refreshUpdates();
  }

  Future<void> _startDownload(Langue langue) async {
    if (_downloadProgresses.containsKey(langue.initial) ||
        _preparingDownloads.contains(langue.initial))
      return;

    String fullPath = languePath(langue.initial);
    setState(() => _preparingDownloads.add(langue.initial));

    await DownloadUtils.startDownload(
      context,
      langue.initial,
      fullPath,
      null,
      onProgress: (progress) {
        if (!mounted) return;
        setState(() => _downloadProgresses[langue.initial] = progress);
        _preparingDownloads.remove(langue.initial);
      },
      onCompleted: () {
        if (!mounted) return;
        setState(() {
          langue.isDownloaded = true;
          _downloadProgresses.remove(langue.initial);
          _sortLangues();
        });
        NotificactionService.showSuccessMessage(
          context,
          '${langue.libelle}: ${i18n.tr('download.pdf_download_title')}',
        );
      },
      onError: (error) {
        if (!mounted) return;
        setState(() {
          _downloadProgresses.remove(langue.initial);
          _preparingDownloads.remove(langue.initial);
        });
        NotificactionService.showErrorMessage(context, error);
      },
    );
  }

  void _cancelDownload(String id) {
    final cancelled = _downloadManager.cancel(id);
    if (cancelled) {
      setState(() {
        _downloadProgresses.remove(id);
        _preparingDownloads.remove(id);
      });
      _downloadSubscriptions[id]?.cancel();
      _downloadSubscriptions.remove(id);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    // Annuler tous les abonnements spécifiques aux téléchargements
    for (var subscription in _downloadSubscriptions.values) {
      subscription.cancel();
    }
    _downloadSubscriptions.clear();
    super.dispose();
  }

  // Méthode de tri à extraire pour la réutiliser
  void _sortLangues() async {
    final priority = await DBManager.priorityDB();

    // Garder l'ordre original pour les non téléchargées
    final originalIndex = <String, int>{};
    for (var i = 0; i < _langues.length; i++) {
      originalIndex[_langues[i].initial] = i;
    }

    _langues.sort((a, b) {
      // Rangs :
      // 0 = langue active
      // 1 = langues prioritaires téléchargées (sauf si c'est la langue active)
      // 2 = autres langues téléchargées
      // 3 = langues non téléchargées
      int rank(Langue l) {
        final isActive = l.initial == i18n.lang;
        final isPriority = priority.contains(l.initial);

        if (isActive) return 0;
        if (isPriority && l.isDownloaded) return 1;
        if (l.isDownloaded) return 2;
        return 3;
      }

      final ra = rank(a);
      final rb = rank(b);

      // Si rangs différents, trier par rang
      if (ra != rb) return ra.compareTo(rb);

      // Même rang : tri spécifique selon le rang
      if (ra == 0) {
        // Langue active (cas improbable de doublon)
        return 0;
      }

      if (ra == 1) {
        // Langues prioritaires téléchargées : ordre fixe (en-en, fr-fr, es-es, pt-pt)
        final ia = priority.indexOf(a.initial);
        final ib = priority.indexOf(b.initial);
        return ia.compareTo(ib);
      }

      if (ra == 2) {
        // Autres langues téléchargées : tri alphabétique par libellé
        return a.libelle.compareTo(b.libelle);
      }

      // ra == 3 : langues non téléchargées, conserver l'ordre d'origine
      final oa = originalIndex[a.initial] ?? 0;
      final ob = originalIndex[b.initial] ?? 0;
      return oa.compareTo(ob);
    });

    // Éliminer les doublons par initial
    final seen = <String>{};
    _langues.retainWhere((l) {
      final keep = !seen.contains(l.initial);
      seen.add(l.initial);
      return keep;
    });
  }

  Future<void> _loadLangues({bool refresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (refresh) {
        _currentPage = 1;
        _langues.clear();
        _hasMore = true;
      }
    });

    try {
      final result = await _repository.findAll(
        page: _currentPage,
        perPage: _perPage,
        name: _searchQuery.isEmpty ? null : _searchQuery,
        initial: _searchQuery.isEmpty ? null : _searchQuery,
        orderBy: _isAscending ? '"order" ASC' : '"order" DESC',
      );

      // Ajouter les nouvelles langues
      final newLangues = result.data;

      // Vérifier l'état de téléchargement AVANT le tri
      for (var langue in newLangues) {
        langue.isDownloaded = await DBManager.dbExists(langue.initial);
      }

      setState(() {
        _langues.addAll(newLangues);
        _totalCount = result.total;
        _hasMore = _langues.length < _totalCount;

        // Trier uniquement si c'est un refresh (nouvelle recherche ou premier chargement)
        if (refresh || _currentPage == 1) {
          _sortLangues();
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        NotificactionService.showErrorMessage(context, 'Erreur: $e');
      }
    }
  }

  Future<void> _loadMoreLangues() async {
    if (_hasMore && !_isLoading) {
      _currentPage++;
      await _loadLangues(); // Ne pas passer refresh=true ici
    }
  }

  Future _deleteLangue(Langue langue) async {
    if (!await ConnectionUtils.hasConnection()) {
      ConnectionUtils.showNoConnectionMessage(context);
      return;
    }

    final confirm = await _showDeleteConfirmation(langue);

    if (confirm) {
      await DBManager.deleteDatabase(langue.initial);

      setState(() {
        // Marquer comme non téléchargée
        langue.isDownloaded = false;
        _refreshDbUpdates();
        // Re-trier la liste pour repositionner la langue
        _sortLangues();
      });
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
        _loadLangues(refresh: true);
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
    _loadLangues(refresh: true);
  }

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
    });
    _loadLangues(refresh: true);
  }

  Future<bool> _showDeleteConfirmation(Langue langue) async {
    return await DialogUtils.confirmDialog(
      context,
      "${i18n.tr('button.confirm_action')} (${langue.libelle})",
    );
  }

  Future<bool> _downloadConfirmation(Langue langue) async {
    return await DialogUtils.confirmDialog(
      context,
      "${i18n.tr('download.langue_not_found')} (${langue.libelle})",
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MainLayout(
      title: i18n.tr('home.langues'),
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
        UpdateButton(
          key: updateButtonKey,
          isOnLanguagesPage: true,
          onUpdatesReceived: (updates) {
            setState(() {
              _updates = updates;
            });
          },
        ),
      ],
      body: Column(
        children: [
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
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _loadLangues(refresh: true),
              child: _langues.isEmpty && _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _langues.isEmpty
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
                      itemCount: _langues.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _langues.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final langue = _langues[index];
                        return _buildLangueCard(
                          langue,
                          isDark,
                          languageProvider,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget de carte de langue modifié
  Widget _buildLangueCard(
    Langue langue,
    bool isDark,
    LanguageProvider languageProvider,
  ) {
    final countryCode = extractCountryCode(langue.initial).toLowerCase();
    final flagPath = 'assets/images/drapeau/$countryCode.jpg';
    final progress = _downloadProgresses[langue.initial];
    final isDownloading =
        progress != null && progress.status == DownloadStatus.downloading;
    final isPreparing = _preparingDownloads.contains(langue.initial);
    final containsLangue = _updates.any((u) => u['langue'] == langue.initial);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: isDark ? pkpDark : pkpSand,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Colors.black12, width: 0.5),
      ),
      child: Column(
        children: [
          // Partie principale de la carte
          InkWell(
            onTap: isDownloading || isPreparing
                ? null
                : () async {
                    await languageProvider.changeLanguage(
                      LanguageData(
                        id: langue.id,
                        name: langue.libelle,
                        lang: langue.initial,
                        countryFip: countryCode,
                        icon: flagPath,
                        translation: langue.webTranslation ?? "",
                      ),
                    );

                    if (!mounted) return;

                    if (langue.isDownloaded) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SermonsPage()),
                      );
                    } else {
                      bool confirm = await _downloadConfirmation(langue);
                      if (confirm) _startDownload(langue);
                    }
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
                    width: 48,
                    height: 34,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        flagPath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.1),
                          child: Center(
                            child: Text(
                              langue.initial.toUpperCase(),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          langue.libelle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          langue.initial.toUpperCase(),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Télécharger
                      if (!langue.isDownloaded &&
                          !isDownloading &&
                          !isPreparing)
                        _iconButton(
                          icon: Icons.download_rounded,
                          color: isDark ? Colors.lightBlue : Colors.blue,
                          onTap: () => _startDownload(langue),
                        ),

                      // Loader préparation
                      if (isPreparing) _loader(isDark, langue.isDownloaded),

                      // Mettre à jour
                      if (langue.isDownloaded &&
                          containsLangue &&
                          !isDownloading &&
                          !isPreparing)
                        _iconButton(
                          icon: Icons.refresh_rounded,
                          color: Colors.green,
                          onTap: () => _startDownload(langue),
                        ),

                      // Supprimer
                      if (langue.isDownloaded &&
                          i18n.lang != langue.initial &&
                          !isDownloading &&
                          !isPreparing)
                        _iconButton(
                          icon: Icons.delete_rounded,
                          color: Colors.red,
                          onTap: () => _deleteLangue(langue),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Barre de progression
          if (isDownloading)
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
              child: Column(
                children: [
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Texte et pourcentage
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    i18n.tr(
                                      'download.waiting_for_downloaded_langue',
                                    ),
                                    style: TextStyle(
                                      fontSize: 11,
                                      overflow: TextOverflow.ellipsis,
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${progress.percent.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.lightBlue.shade300
                                        : Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // LinearProgressIndicator
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress.percent / 100,
                                minHeight: 6,
                                backgroundColor: isDark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade300,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isDark
                                      ? Colors.lightBlue.shade400
                                      : Colors.blue.shade600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            // Taille téléchargée
                            Text(
                              '${progress.downloadedMb.toStringAsFixed(1)} MB / ${progress.totalMb.toStringAsFixed(1)} MB',
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Bouton annuler
                      InkWell(
                        onTap: () => _cancelDownload(langue.initial),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.red.shade900.withOpacity(0.3)
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? Colors.red.shade700
                                  : Colors.red.shade300,
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: isDark
                                ? Colors.red.shade300
                                : Colors.red.shade700,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Widget pour bouton simple
  Widget _iconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  /// Loader pendant préparation ou update
  Widget _loader(bool isDark, bool isUpdate) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isUpdate ? Colors.green : (isDark ? Colors.lightBlue : Colors.blue),
          ),
        ),
      ),
    );
  }
}

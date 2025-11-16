// lib/shared/widgets/update_button.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:prophet_kacou/core/services/api_service.dart';
import 'package:prophet_kacou/core/utils/connection.dart';
import 'package:prophet_kacou/core/utils/notificaction.dart';
import 'package:prophet_kacou/features/settings/pages/languages_page.dart';
import 'package:prophet_kacou/i18n/i18n.dart';

class UpdateButton extends StatefulWidget {
  final bool isOnLanguagesPage;

  /// ⚡ Callback pour remonter les mises à jour récupérées
  final void Function(List<dynamic> updates)? onUpdatesReceived;

  const UpdateButton({
    super.key,
    this.isOnLanguagesPage = false,
    this.onUpdatesReceived,
  });

  @override
  State<UpdateButton> createState() => UpdateButtonState();
}

class UpdateButtonState extends State<UpdateButton> {
  int _updateCount = 0;
  bool _isChecking = false;
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    setState(() => _isChecking = true);

    try {
      final updates = await getDbUpdates();

      if (mounted) {
        setState(() {
          _updateCount = updates.length;
          _isChecking = false;
        });

        // ⚡ Remonter les updates au parent
        if (widget.onUpdatesReceived != null) {
          widget.onUpdatesReceived!(updates);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isChecking = false);
        NotificactionService.showErrorMessage(
          context,
          'Erreur de vérification: $e',
        );
      }
    }
  }

  Future<void> refreshUpdates() async {
    if (mounted) {
      if (!await ConnectionUtils.hasConnection()) {
        ConnectionUtils.showNoConnectionMessage(context);
        return;
      }

      setState(() => _isChecking = true);
    }

    await setDbUpdates(i18n.lang);
    await _checkForUpdates();

    if (mounted) {
      NotificactionService.showSuccessMessage(
        context,
        'Mise á jour effectué avec success!',
      );
    }
  }

  void _handleTap() async {
    if (widget.isOnLanguagesPage) {
      await refreshUpdates();
    } else {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const LanguagesPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: _isChecking
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Icon(
                  _updateCount > 0
                      ? Icons.system_security_update_rounded
                      : Icons.refresh,
                ),
          onPressed: _isChecking ? null : _handleTap,
          tooltip: widget.isOnLanguagesPage
              ? 'Vérifier les mises à jour'
              : 'Voir les mises à jour',
        ),
        if (_updateCount > 0 && !_isChecking)
          Positioned(
            right: 8,
            top: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Center(
                child: Text(
                  _updateCount > 99 ? '99+' : _updateCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

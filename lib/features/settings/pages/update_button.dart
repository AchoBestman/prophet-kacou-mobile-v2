// lib/shared/widgets/update_button.dart
import 'package:flutter/material.dart';
import 'package:prophet_kacou/features/settings/pages/languages_page.dart';

class UpdateButton extends StatefulWidget {
  final VoidCallback? onUpdateCheck;
  final bool isOnLanguagesPage;

  const UpdateButton({
    super.key,
    this.onUpdateCheck,
    this.isOnLanguagesPage = false,
  });

  @override
  State<UpdateButton> createState() => _UpdateButtonState();
}

class _UpdateButtonState extends State<UpdateButton> {
  int _updateCount = 0;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    setState(() => _isChecking = true);

    try {
      // TODO: Implémenter la logique de vérification des mises à jour
      // Exemple: appeler un service qui compare les versions locales avec le serveur
      await Future.delayed(const Duration(seconds: 1)); // Simulation
      
      // TODO: Remplacer par le vrai nombre de mises à jour disponibles
      final updates = 1; // await _updateService.checkAvailableUpdates();
      
      if (mounted) {
        setState(() {
          _updateCount = updates;
          _isChecking = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isChecking = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de vérification: $e')),
        );
      }
    }
  }

  void _handleTap() {
    if (widget.isOnLanguagesPage) {
      // Si on est déjà sur la page langues, lancer la recherche de mises à jour
      if (widget.onUpdateCheck != null) {
        widget.onUpdateCheck!();
      } else {
        _checkForUpdates();
      }
    } else {
      // Sinon, naviguer vers la page langues
      final navigator = Navigator.of(context);
      navigator.push(
        MaterialPageRoute(
          builder: (context) => const LanguagesPage(),
        ),
      );
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
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(_updateCount > 0 ? Icons.system_security_update_rounded : Icons.update_disabled),
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
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
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
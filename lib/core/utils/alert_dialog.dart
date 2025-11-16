import 'package:flutter/material.dart';
import 'package:prophet_kacou/colors/custom_colors.dart';
import 'package:prophet_kacou/i18n/i18n.dart';

class DialogUtils {
  /// Affiche un dialog de confirmation et retourne true si confirmé
  static Future<bool> confirmDialog(BuildContext context, String message) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              backgroundColor: isDark ? pkpDark : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      size: 48,
                      color: isDark ? Colors.amber : Colors.redAccent,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: isDark
                                ? Colors.white
                                : Colors.black87,
                          ),
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(i18n.tr('button.cancel')),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(
                            i18n.tr('button.confirm'),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        false;
  }
}

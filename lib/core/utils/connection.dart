import 'dart:io';
import 'package:flutter/material.dart';
import 'package:prophet_kacou/core/utils/notificaction.dart';
import 'package:prophet_kacou/i18n/i18n.dart';

class ConnectionUtils {
  static Future<bool> hasConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static void showNoConnectionMessage(BuildContext context) {
    NotificactionService.showErrorMessage(
      context,
      i18n.tr("alert.cannot_download"),
    );
  }
}

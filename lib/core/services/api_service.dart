import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:prophet_kacou/core/constants/app_strings.dart';
import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

Future<void> setDbUpdates(String initial) async {
  final Dio dio = Dio();
  try {
    final localLangues = await DBManager.getAllExistingDB();
    final response = await dio.get(
      '${AppStrings.apiUrl}/$initial/langue-releases/all-new-updates',
      queryParameters: {'langs[]': localLangues},
    );

    if (response.statusCode == 200 && response.data != null) {
      final prefs = await SharedPreferences.getInstance();

      if (response.data is List) {
        final jsonString = jsonEncode(response.data);
        prefs.setString(AppStrings.downloadDbUpdates, jsonString);
      }
    }
  } catch (e) {
    log('❌ Erreur lors de la récupération des mises à jour : $e');
  }
}

Future<List<dynamic>> getDbUpdates() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(AppStrings.downloadDbUpdates);

  if (raw != null) {
    final List decoded = jsonDecode(raw);
    return decoded;
  }

  return [];
}

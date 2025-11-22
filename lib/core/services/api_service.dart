import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:prophet_kacou/core/constants/app_strings.dart';
import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
//{lang}/langue-releases/has-update

Future<void> langueHasNewUpdate(String initial, String last_update_at) async {
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
        final common = (response.data as List).firstWhere((u) => u['langue'] == "common", orElse: () => null);
        //any((u) => u['langue'] == "common");
        if(common != null){
          final String lng = common["langue"];
          final String updated_at = common["updated_at"];
        }
        print(response.data);
        final jsonString = jsonEncode(response.data);
        prefs.setString(AppStrings.downloadDbUpdates, jsonString);
      }
    }
  } catch (e) {
    log('❌ Erreur lors de la récupération des mises à jour : $e');
  }
}

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
        final common = (response.data as List).firstWhere((u) => u['langue'] == "common", orElse: () => null);
        //any((u) => u['langue'] == "common");
        if(common != null){
          final String lng = common["langue"];
          final String updated_at = common["updated_at"];
        }
        print(response.data);
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

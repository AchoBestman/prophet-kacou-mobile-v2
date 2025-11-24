import 'dart:convert';
import 'dart:developer';
import 'package:prophet_kacou/core/constants/app_strings.dart';
import 'package:prophet_kacou/core/models/app_data_update.dart';
import 'package:prophet_kacou/core/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Fonctions privées (non exportées)
Future<void> _setTotalAppDataUpdatesAvailable(List<String> data) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(AppStrings.totalDbAvailableUpdateKey, jsonEncode(data));
}

Future<List<AppDataUpdate>> _getAppDataUpdatesAvailable() async {
  final prefs = await SharedPreferences.getInstance();
  final response = prefs.getString(AppStrings.dbAvailableUpdateKey);
  if (response == null) return [];

  final List<dynamic> jsonList = jsonDecode(response);
  return jsonList.map((json) => AppDataUpdate.fromJson(json)).toList();
}

Future<List<AppDataUpdate>> _getLastAppDataUpdates() async {
  final prefs = await SharedPreferences.getInstance();
  final response = prefs.getString(AppStrings.dbLastUpdateKey);
  if (response == null) return [];

  final List<dynamic> jsonList = jsonDecode(response);
  return jsonList.map((json) => AppDataUpdate.fromJson(json)).toList();
}

Future<AppDataUpdate?> _getAppDataUpdateAvailable(String lang) async {
  final updates = await _getAppDataUpdatesAvailable();
  try {
    return updates.firstWhere((item) => item.langue == lang);
  } catch (e) {
    return null;
  }
}

Future<AppDataUpdate?> _getLastAppDataUpdate(String lang) async {
  final updates = await _getLastAppDataUpdates();
  try {
    return updates.firstWhere((item) => item.langue == lang);
  } catch (e) {
    return null;
  }
}

// Fonctions publiques (exportées)
Future<List<String>> getTotalAppDataUpdatesAvailable() async {
  final prefs = await SharedPreferences.getInstance();
  final response = prefs.getString(AppStrings.totalDbAvailableUpdateKey);
  if (response == null) return [];

  final List<dynamic> jsonList = jsonDecode(response);
  return jsonList.map((e) => e.toString()).toList();
}

Future<void> setAppDataUpdatesAvailable(List<AppDataUpdate> data) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonList = data.map((item) => item.toJson()).toList();
  await prefs.setString(AppStrings.dbAvailableUpdateKey, jsonEncode(jsonList));
}

Future<void> setLastAppDataUpdates(List<AppDataUpdate> data) async {
  final lastUpdates = await _getLastAppDataUpdates();
  if (lastUpdates.isEmpty) {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = data.map((item) => item.toJson()).toList();
    await prefs.setString(AppStrings.dbLastUpdateKey, jsonEncode(jsonList));
  }
}

Future<AppDataUpdate?> dbHasNewUpdate(String lang) async {
  final totalAvailable = await getTotalAppDataUpdatesAvailable();
  final lastUpdatedAt = await _getLastAppDataUpdate(lang);
  final currentUpdate = await _getAppDataUpdateAvailable(lang);

  if (currentUpdate == null || currentUpdate.updatedAt.isEmpty) return null;

  final lastTime = lastUpdatedAt != null && lastUpdatedAt.updatedAt.isNotEmpty
      ? DateTime.parse(lastUpdatedAt.updatedAt).millisecondsSinceEpoch
      : 0;


  final currentTime = DateTime.parse(
    currentUpdate.updatedAt,
  ).millisecondsSinceEpoch;

  final hasUpdate = currentTime > lastTime;
  if (hasUpdate && !totalAvailable.contains(lang)) {
    totalAvailable.add(lang);
    await _setTotalAppDataUpdatesAvailable(totalAvailable);
  }

  return hasUpdate ? currentUpdate : null;
}

Future<void> updateLangueLastUpdate(AppDataUpdate? data) async {
  if (data == null) return;
  final updates = await _getLastAppDataUpdates();
  final exists = updates.any((item) => item.langue == data.langue);

  final List<AppDataUpdate> response = exists
      ? updates.map((item) => item.langue == data.langue ? data : item).toList()
      : [...updates, data];

  final prefs = await SharedPreferences.getInstance();
  final jsonList = response.map((item) => item.toJson()).toList();
  await prefs.setString(AppStrings.dbLastUpdateKey, jsonEncode(jsonList));

  final totalAvailable = await getTotalAppDataUpdatesAvailable();
  final newTotal = totalAvailable.where((item) => item != data.langue).toList();
  await _setTotalAppDataUpdatesAvailable(newTotal);
}

Future<void> availableServerLanguesUpdates(String lng) async {
  try{
    await setDbUpdates(lng);
  }catch(err){
    log('erreur lors de la mise a jour des langues: $err');
  }
}

Future<void> setUpdateIsPending(bool status) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(AppStrings.updateIsPending, status);
}

Future<bool?> getUpdateIsPending() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(AppStrings.updateIsPending);
}


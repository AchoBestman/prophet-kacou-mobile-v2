import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:prophet_kacou/core/constants/app_strings.dart';
import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:prophet_kacou/core/models/app_data_update.dart';
import 'package:prophet_kacou/core/repositories/langue.dart';
import 'package:prophet_kacou/core/utils/app_data_updates.dart';
import 'package:prophet_kacou/core/utils/download_utils.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'dart:developer';

Future<void> setDbUpdates(String initial) async {
  final Dio dio = Dio();
  final LangueRepository langueRepo = LangueRepository();
  final canSendRequest = await getUpdateIsPending();
  if (canSendRequest != null && canSendRequest == true) {
    return;
  }

  try {
    final localLangues = await DBManager.getAllExistingDB();
    print("local langues to updates: $localLangues");

    setUpdateIsPending(true);
    final response = await dio.get(
      '${AppStrings.apiUrl}/$initial/langue-releases/all-new-updates',
      queryParameters: {'langs[]': localLangues},
    );

    if (response.statusCode != 200) {
      setUpdateIsPending(false);
      throw Exception('HTTP error ${response.statusCode}');
    }

    final responseBody = response.data;
    List<dynamic>? jsonData;
print("responseBody: $responseBody");
    if (responseBody is List) {
      jsonData = responseBody;
    } else if(responseBody is String) {
      jsonData = jsonDecode(response.data);
    }

    //
    if(jsonData == null){
      return ;
    }

    final data = jsonData.map((json) => AppDataUpdate.fromJson(json)).toList();

    await setAppDataUpdatesAvailable(data);
    await setLastAppDataUpdates(data);

    for (var item in data) {
      await dbHasNewUpdate(item.langue);
    }

    final common = data.firstWhere(
      (item) => item.langue == "common",
      orElse: () =>
          AppDataUpdate(langue: '', updatedAt: ''),
    );

    if (common.updatedAt.isNotEmpty) {
     
      final lastUpdatedAt = await langueRepo.findLangueLastUpdate(
        i18n.lang,
        common.langue,
      );

      if (lastUpdatedAt == null ||
          DateTime.parse(
            common.updatedAt,
          ).isAfter(DateTime.parse(lastUpdatedAt.updatedAt))) {
        try {
          print('${common.updatedAt} download updated common database finish');

          await DownloadUtils.startDownloadCommonDB();
          setUpdateIsPending(false);
        } catch (err) {
          log('Error downloading database: $err');
        } finally {
          setUpdateIsPending(false);
        }
      }
    }
  } catch (e) {
    log('❌ Erreur lors de la récupération des mises à jour : $e');
  } finally {
    setUpdateIsPending(false);
  }
}



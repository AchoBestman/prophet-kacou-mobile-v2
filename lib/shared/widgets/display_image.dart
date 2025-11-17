import 'package:flutter/material.dart';
import 'package:prophet_kacou/core/models/sermon.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Widget displayImage(BuildContext context, Sermon sermon) {
  final imgBytes = sermon.image?.file;

  if (imgBytes == null || imgBytes.isEmpty) {
    return const Text("");
  }

  return GestureDetector(
    onTap: () async {
      try {
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/sermon_image_${sermon.id}.jpg';

        final file = File(filePath);
        await file.writeAsBytes(imgBytes);

        await OpenFilex.open(filePath);
      } catch (e) {
        debugPrint("Erreur lors de l’ouverture de l’image : $e");
      }
    },
    child: Center(
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Image.memory(
          imgBytes,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image, size: 64),
        ),
      ),
    ),
  );
}

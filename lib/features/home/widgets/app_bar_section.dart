import 'package:flutter/material.dart';
import 'package:prophet_kacou/i18n/i18n.dart';

class AppBarSection extends StatelessWidget {
  final String title;

  const AppBarSection({super.key, this.title = ""});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/sermons');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
          ),
          label: Text(i18n.tr('home.sermon'), style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}

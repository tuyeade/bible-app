import 'package:flutter/material.dart';
import '../../domain/entities/bible_model.dart';

class VerseTile extends StatelessWidget {
  final Verse verse;

  const VerseTile({super.key, required this.verse});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        verse.verse.toString(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),

      title: Text(verse.text),
    );
  }
}

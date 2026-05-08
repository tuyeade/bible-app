import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/bible_providers.dart';

class VersesScreen extends ConsumerWidget {
  final String reference;

  const VersesScreen({super.key, required this.reference});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versesAsync = ref.watch(versesProvider(reference));

    return Scaffold(
      appBar: AppBar(title: Text(reference)),
      body: versesAsync.when(
        data: (verses) {
          return ListView.builder(
            itemCount: verses.length,
            itemBuilder: (context, index) {
              final verse = verses[index];
              return ListTile(
                leading: Text("${verse.verse}"),
                title: Text(verse.text),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text(e.toString())),
      ),
    );
  }
}

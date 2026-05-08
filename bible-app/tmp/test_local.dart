import 'package:flutter/widgets.dart'; // Just to resolve dependencies if any
import 'lib/data/local_bible_service.dart';
import 'lib/data/amharic_bible_api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localService = LocalBibleService();
  final amharicService = AmharicBibleApiService(localBibleService: localService);
  
  try {
    final verses = await localService.fetchVerses('1 thessalonians 3');
    print('Local length: ${verses.length}');
  } catch (e) {
    print('Local fail: $e');
  }
}

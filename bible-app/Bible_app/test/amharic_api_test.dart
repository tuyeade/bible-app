import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/data/amharic_bible_api_service.dart';
import 'package:flutter/widgets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  test('Amharic API Test', () async {
    final service = AmharicBibleApiService();
    try {
      final verses = await service.fetchVerses('genesis 1');
      print('Amharic verses loaded successfully: \${verses.length}');
    } catch (e, stack) {
      print('Failed to load verses: \$e');
      print('Stack trace: \$stack');
      rethrow;
    }
  });
}

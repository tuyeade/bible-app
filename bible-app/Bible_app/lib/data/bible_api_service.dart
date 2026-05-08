import 'package:dio/dio.dart';
import '../domain/entities/bible_passage.dart';
import '../domain/entities/bible_model.dart';

class BibleApiService {
  final Dio _dio;

  BibleApiService({Dio? dio}) : _dio = dio ?? Dio();

  /// Fetch a full passage from the API
  Future<BiblePassage> fetchPassage(String query) async {
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      throw ArgumentError('Query cannot be empty');
    }

    final encoded = Uri.encodeComponent(trimmed);
    final url = 'https://bible-api.com/$encoded';

    final response = await _dio.get(url);

    return BiblePassage.fromJson(response.data as Map<String, dynamic>);
  }

  /// Fetch only verses (most used by the UI)
  Future<List<Verse>> fetchVerses(String query) async {
    final passage = await fetchPassage(query);
    return passage.verses;
  }
}

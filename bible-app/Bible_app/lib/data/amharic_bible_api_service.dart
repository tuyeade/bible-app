import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../domain/entities/bible_model.dart';
import 'local_bible_service.dart';

class AmharicBibleApiService {
  final LocalBibleService? localBibleService;
  final Dio _dio;

  // Cache the result in memory as it's around 4.5MB
  // Made static to persist across multiple service instance creations
  static Map<String, dynamic>? _amharicBibleData;
  static bool _isLoading = false;

  AmharicBibleApiService({this.localBibleService, Dio? dio}) : _dio = dio ?? Dio();

  Future<void> _fetchAndCacheIfNeeded() async {
    if (_amharicBibleData != null) return;
    if (_isLoading) {
      // Very basic lock: wait if another call is currently fetching
      while (_isLoading) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return;
    }

    _isLoading = true;
    try {
      final jsonString = await rootBundle.loadString('assets/am_bible.json');
      _amharicBibleData = await compute(jsonDecode, jsonString) as Map<String, dynamic>;
    } catch (e, stackTrace) {
      debugPrint('Error loading Amharic Bible: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Fetch error: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Get verses for a specific book and chapter
  Future<List<Verse>> fetchVerses(String reference) async {
    final int lastSpaceIndex = reference.lastIndexOf(' ');
    if (lastSpaceIndex == -1) {
      throw Exception('Invalid reference format. Expected "Book Chapter"');
    }

    final bookName = reference
        .substring(0, lastSpaceIndex)
        .trim()
        .toLowerCase();
    final chapterStr = reference.substring(lastSpaceIndex + 1).trim();
    final chapterNum = int.tryParse(chapterStr);

    if (chapterNum == null || chapterNum < 1) {
      throw Exception('Invalid chapter number');
    }

    // Map English name to an index since both our App's book list and Amharic JSON follow the standard 66 book order.
    final bookIndex = _getBookIndexFromName(bookName);

    try {
      // 1. Try to fetch from external API (only NT books are currently available, e.g. MAT-REV)
      final bookCode = _getApiBookCode(bookIndex);
      final url = 'https://bible-verse-et.vercel.app/v1/chapters/am/$bookCode/$chapterNum?showNumbers=true';
      final response = await _dio.get(
        url,
        options: Options(
          validateStatus: (status) => status == 200,
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final text = response.data.toString();
        final regex = RegExp(r'<v>(\d+)</v>\s*(.*?)(?=(?:<v>\d+</v>)|$)', dotAll: true);
        final matches = regex.allMatches(text);
        
        if (matches.isNotEmpty) {
          final List<Verse> apiVerses = [];
          for (final m in matches) {
            final vNum = int.parse(m.group(1)!);
            final vText = m.group(2)!.trim();
            apiVerses.add(Verse(verse: vNum, text: vText));
          }
          return apiVerses;
        }
      }
    } catch (e) {
      debugPrint('External API fetch failed for $bookName, falling back to local JSON. Error: $e');
    }

    // 2. Fallback to Local JSON
    await _fetchAndCacheIfNeeded();

    if (_amharicBibleData == null) {
      throw Exception('Data is still null after fetch. Unexpected error.');
    }

    final List<dynamic> books = _amharicBibleData!['books'];
    if (bookIndex < 0 || bookIndex >= books.length) {
      throw Exception(
        'Amharic Book not found: $bookName (index $bookIndex out of bounds)',
      );
    }

    final bookData = books[bookIndex];

    final List<dynamic> chapters = bookData['chapters'];

    // Chapter index might not be sequential or 0-based in magna25 repo, but they should be in order.
    // Let's find the chapter object where "chapter" == chapterStr
    final chapterData = chapters.firstWhere(
      (c) => c['chapter'] == chapterStr,
      orElse: () => null,
    );

    if (chapterData == null) {
      throw Exception('Chapter not found: $chapterNum in $bookName');
    }

    final List<dynamic> verseStrings = chapterData['verses'];
    int targetLength = verseStrings.length;

    // Leverage the KJV source-of-truth JSON as padding boundary structure to make up for Magna25's missing dropped verse indexes
    if (localBibleService != null) {
      try {
        final kjvVerses = await localBibleService!.fetchVerses(reference);
        if (kjvVerses.length > targetLength) {
          targetLength = kjvVerses.length;
        }
      } catch (_) {}
    }

    final List<Verse> result = [];
    for (int i = 0; i < targetLength; i++) {
      String vText = "";
      if (i < verseStrings.length) {
        vText = verseStrings[i] as String;
      }

      if (vText.trim().isEmpty) {
        vText =
            "ትርጉም አልተገኘም ወይም ከሌላ ጥቅስ ጋር ተዋህዷል"; // Translation not found or merged within Amharic translation source
      }

      result.add(Verse(verse: i + 1, text: vText));
    }

    return result;
  }

  int _getBookIndexFromName(String name) {
    const orderedBooks = [
      'genesis',
      'exodus',
      'leviticus',
      'numbers',
      'deuteronomy',
      'joshua',
      'judges',
      'ruth',
      '1 samuel',
      '2 samuel',
      '1 kings',
      '2 kings',
      '1 chronicles',
      '2 chronicles',
      'ezra',
      'nehemiah',
      'esther',
      'job',
      'psalms',
      'proverbs',
      'ecclesiastes',
      'song of solomon',
      'isaiah',
      'jeremiah',
      'lamentations',
      'ezekiel',
      'daniel',
      'hosea',
      'joel',
      'amos',
      'obadiah',
      'jonah',
      'micah',
      'nahum',
      'habakkuk',
      'zephaniah',
      'haggai',
      'zechariah',
      'malachi',
      'matthew',
      'mark',
      'luke',
      'john',
      'acts',
      'romans',
      '1 corinthians',
      '2 corinthians',
      'galatians',
      'ephesians',
      'philippians',
      'colossians',
      '1 thessalonians',
      '2 thessalonians',
      '1 timothy',
      '2 timothy',
      'titus',
      'philemon',
      'hebrews',
      'james',
      '1 peter',
      '2 peter',
      '1 john',
      '2 john',
      '3 john',
      'jude',
      'revelation',
    ];
    // Map 'psalm' to 'psalms' just in case
    final normalized = name == 'psalm' ? 'psalms' : name;
    return orderedBooks.indexOf(normalized);
  }

  String _getApiBookCode(int index) {
    const apiCodes = [
      'GEN', 'EXO', 'LEV', 'NUM', 'DEU', 'JOS', 'JDG', 'RUT', '1SA', '2SA',
      '1KI', '2KI', '1CH', '2CH', 'EZR', 'NEH', 'EST', 'JOB', 'PSA', 'PRO',
      'ECC', 'SNG', 'ISA', 'JER', 'LAM', 'EZK', 'DAN', 'HOS', 'JOL', 'AMO',
      'OBA', 'JON', 'MIC', 'NAM', 'HAB', 'ZEP', 'HAG', 'ZEC', 'MAL', 'MAT',
      'MRK', 'LUK', 'JHN', 'ACT', 'ROM', '1CO', '2CO', 'GAL', 'EPH', 'PHP',
      'COL', '1TH', '2TH', '1TI', '2TI', 'TIT', 'PHM', 'HEB', 'JAS', '1PE',
      '2PE', '1JN', '2JN', '3JN', 'JUD', 'REV',
    ];
    if (index >= 0 && index < apiCodes.length) {
      return apiCodes[index];
    }
    return '';
  }
}

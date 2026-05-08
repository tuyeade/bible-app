import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../domain/entities/bible_model.dart';

class LocalBibleService {
  List<dynamic>? _bibleData;

  /// Load the full offline KJV Bible into memory
  Future<void> _loadBibleDataIfNeeded() async {
    if (_bibleData != null) return;
    
    final jsonString = await rootBundle.loadString('assets/en_kjv.json');
    _bibleData = await compute(jsonDecode, jsonString) as List<dynamic>;
  }

  /// Get verses for a specific book and chapter
  /// E.g. reference might be "John 3" from the ui or API, but since
  /// we have book selection and chapter selection screens, we can parse it.
  Future<List<Verse>> fetchVerses(String reference) async {
    await _loadBibleDataIfNeeded();

    if (_bibleData == null) {
      throw Exception('Failed to load Bible data');
    }

    // example reference: "Genesis 1"
    // find last space to separate book from chapter
    final int lastSpaceIndex = reference.lastIndexOf(' ');
    if (lastSpaceIndex == -1) {
      throw Exception('Invalid reference format. Expected "Book Chapter"');
    }

    final bookName = reference.substring(0, lastSpaceIndex).trim().toLowerCase();
    final chapterStr = reference.substring(lastSpaceIndex + 1).trim();
    final chapterNum = int.tryParse(chapterStr);

    if (chapterNum == null || chapterNum < 1) {
      throw Exception('Invalid chapter number');
    }

    // Since our JSON uses abbreviations ("gn", "jo", etc), we map it first
    final abbrev = _getAbbrevFromName(bookName);
    
    // Find the book in our JSON data
    final bookData = _bibleData!.firstWhere(
      (b) => b['abbrev'] == abbrev,
      orElse: () => null,
    );

    if (bookData == null) {
      throw Exception('Book not found: $bookName (mapped to $abbrev)');
    }

    final List<dynamic> chapters = bookData['chapters'];
    
    // Chapter index is 0-based
    if (chapterNum > chapters.length) {
      throw Exception('Chapter not found: $chapterNum in $bookName');
    }

    // The JSON stores chapters as a list of strings (verses)
    final List<dynamic> verseStrings = chapters[chapterNum - 1];
    
    final List<Verse> result = [];
    for (int i = 0; i < verseStrings.length; i++) {
      result.add(Verse(
        verse: i + 1,
        text: verseStrings[i] as String,
      ));
    }
    
    return result;
  }

  String _getAbbrevFromName(String name) {
    // Map full names to abbreviations used by en_kjv.json
    const map = {
      'genesis': 'gn', 'exodus': 'ex', 'leviticus': 'lv', 'numbers': 'nm', 'deuteronomy': 'dt',
      'joshua': 'js', 'judges': 'jud', 'ruth': 'rt', '1 samuel': '1sm', '2 samuel': '2sm',
      '1 kings': '1kgs', '2 kings': '2kgs', '1 chronicles': '1ch', '2 chronicles': '2ch',
      'ezra': 'ezr', 'nehemiah': 'ne', 'esther': 'et', 'job': 'job', 'psalms': 'ps', 'psalm': 'ps',
      'proverbs': 'prv', 'ecclesiastes': 'ec', 'song of solomon': 'so', 'isaiah': 'is',
      'jeremiah': 'jr', 'lamentations': 'lm', 'ezekiel': 'ez', 'daniel': 'dn', 'hosea': 'ho',
      'joel': 'jl', 'amos': 'am', 'obadiah': 'ob', 'jonah': 'jn', 'micah': 'mi', 'nahum': 'na',
      'habakkuk': 'hk', 'zephaniah': 'zp', 'haggai': 'hg', 'zechariah': 'zc', 'malachi': 'ml',
      'matthew': 'mt', 'mark': 'mk', 'luke': 'lk', 'john': 'jo', 'acts': 'act', 'romans': 'rm',
      '1 corinthians': '1co', '2 corinthians': '2co', 'galatians': 'gl', 'ephesians': 'eph',
      'philippians': 'ph', 'colossians': 'cl', '1 thessalonians': '1ts', '2 thessalonians': '2ts',
      '1 timothy': '1tm', '2 timothy': '2tm', 'titus': 'tt', 'philemon': 'phm', 'hebrews': 'hb',
      'james': 'jm', '1 peter': '1pe', '2 peter': '2pe', '1 john': '1jo', '2 john': '2jo',
      '3 john': '3jo', 'jude': 'jd', 'revelation': 're'
    };
    
    return map[name] ?? 'unk';
  }
}

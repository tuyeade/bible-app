import 'dart:convert';
import 'dart:io';

void main() async {
  try {
    // Mimic the LocalBibleService loading
    final file = File('C:\\Users\\hp\\Desktop\\Bible_App\\flutter_application_1\\assets\\en_kjv.json');
    if (!await file.exists()) {
       print('File not found: ${file.path}');
       return;
    }
    final jsonString = await file.readAsString();
    final List<dynamic> bibleData = jsonDecode(jsonString);
    
    // 1 thessalonians is '1ts'
    final abbrev = '1ts';
    final bookData = bibleData.firstWhere(
      (b) => b['abbrev'] == abbrev,
      orElse: () => null,
    );
    
    if (bookData == null) {
      print('Book not found in en_kjv');
      return;
    }
    
    final chapters = bookData['chapters'];
    if (3 > chapters.length) {
      print('Chapter out of bounds');
      return;
    }
    
    final verses = chapters[2]; // Chapter 3 (0-indexed)
    print('KJV has ${verses.length} verses in 1 Thess 3');
  } catch (e) {
    print('Failed: $e');
  }
}

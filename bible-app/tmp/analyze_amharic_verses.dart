import 'dart:convert';
import 'dart:io';

void main() async {
  final request = await HttpClient().getUrl(Uri.parse('https://raw.githubusercontent.com/magna25/amharic-bible-json/master/amharic_bible.json'));
  final response = await request.close();
  final stringData = await response.transform(utf8.decoder).join();
  final Map<String, dynamic> data = jsonDecode(stringData);
  
  final books = data['books'] as List<dynamic>;
  
  // Find 1 Thessalonians
  // "1 thessalonians" is book 52 (0-indexed) or let's search it
  var thess = books.firstWhere((b) => b['name'] == '1 Thessalonians' || b['name'] == '1thessalonians' || b['name'].toString().toLowerCase() == '1 thessalonians', orElse: () => null);
  
  if (thess == null) {
     thess = books[51]; 
  }

  print("Found book: ${thess?['name'] ?? 'Unknown'} at index 51");
  
  final chapters = thess['chapters'] as List<dynamic>;
  final chap3 = chapters.firstWhere((c) => c['chapter'] == "3", orElse: () => null);
  
  if (chap3 != null) {
    final verses = chap3['verses'] as List<dynamic>;
    print("Chapter 3 has ${verses.length} verses in the amharic JSON.");
    for(int i=0; i<verses.length; i++){
      print("${i+1}: ${verses[i]}");
    }
  } else {
    print("Chapter 3 not found");
  }
}

import 'dart:convert';
import 'dart:io';

void main() async {
  print('Fetching...');
  final request = await HttpClient().getUrl(
    Uri.parse('https://bible-verse-et.vercel.app/v1/books/Amharic%20'),
  );
  final response = await request.close();
  final stringData = await response.transform(utf8.decoder).join();

  final Map<String, dynamic> data = jsonDecode(stringData);

  final Set<String> matches = {};
  final RegExp bracketRegex = RegExp(r'\[.*?\]');

  for (var book in data.values) {
    if (book is Map) {
      for (var chapter in book.values) {
        if (chapter is Map) {
          for (var verseKey in chapter.keys) {
            String text = chapter[verseKey].toString();
            for (var match in bracketRegex.allMatches(text)) {
              matches.add(match.group(0)!);
            }
          }
        }
      }
    }
  }

  print('Found artifacts:');
  for (var match in matches) {
    print(match);
  }
}

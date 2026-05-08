import 'dart:convert';
import 'dart:io';

void main() async {
  final request = await HttpClient().getUrl(
    Uri.parse('https://bible-verse-et.vercel.app/v1/books/Amharic%20'),
  );
  final response = await request.close();
  final stringData = await response.transform(utf8.decoder).join();
  final Map<String, dynamic> data = jsonDecode(stringData);

  final Set<String> matches = {};
  final RegExp bracketRegex = RegExp(r'\[.*?\]');

  for (var book in data['books']) {
    for (var chapter in book['chapters']) {
      for (var verse in chapter['verses']) {
        String text = verse.toString();
        for (var match in bracketRegex.allMatches(text)) {
          matches.add(match.group(0)!);
          if (matches.length > 20) break;
        }
        if (matches.length > 20) break;
      }
      if (matches.length > 20) break;
    }
    if (matches.length > 20) break;
  }

  print('Found Amharic artifacts:');
  for (var match in matches) {
    print(match);
  }
}

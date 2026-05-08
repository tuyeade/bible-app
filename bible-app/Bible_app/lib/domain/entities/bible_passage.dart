import 'bible_model.dart';

class BiblePassage {
  final String reference;
  final List<Verse> verses;
  final String text;

  BiblePassage({
    required this.reference,
    required this.verses,
    required this.text,
  });

  factory BiblePassage.fromJson(Map<String, dynamic> json) {
    return BiblePassage(
      reference: json['reference'] ?? '',
      verses:
          (json['verses'] as List<dynamic>?)
              ?.map((v) => Verse.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
      text: json['text'] ?? '',
    );
  }
}

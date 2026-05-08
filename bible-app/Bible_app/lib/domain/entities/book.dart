class Book {
  final String abbr;
  final String name;
  final String desc;
  final String testament;
  final dynamic chapters;

  Book({
    required this.abbr,
    required this.name,
    required this.desc,
    this.testament = '',
    this.chapters,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      abbr: json['abbr'],
      name: json['name'],
      desc: json['desc'],
      testament: json['testament'] ?? '',
      chapters: json['chapters'],
    );
  }
}

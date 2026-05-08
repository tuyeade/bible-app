import 'dart:convert';
import 'package:flutter/services.dart';
import '../domain/entities/book.dart';

class BookService {
  /// Load books from local JSON file
  Future<List<Book>> loadBooks() async {
    final jsonString = await rootBundle.loadString('assets/books.json');

    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList.map((json) => Book.fromJson(json)).toList();
  }
}

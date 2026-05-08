import '../entities/bible_model.dart';
import '../entities/book.dart';

abstract class BibleRepository {
  // Get all books of the Bible
  Future<List<Book>> getBooks();

  // Get all verses for a specific reference (like "Genesis 1")
  Future<List<Verse>> getVerses(String reference);
}

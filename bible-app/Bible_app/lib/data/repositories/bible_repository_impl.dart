import '../../domain/entities/bible_model.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/bible_repository.dart';
import '../local_bible_service.dart';
import '../book_service.dart';
import '../amharic_bible_api_service.dart';

class BibleRepositoryImpl implements BibleRepository {
  final LocalBibleService localBibleService;
  final AmharicBibleApiService amharicBibleApiService;
  final BookService bookService;
  final String currentVersion;

  BibleRepositoryImpl({
    required this.localBibleService, 
    required this.amharicBibleApiService,
    required this.bookService,
    required this.currentVersion,
  });

  @override
  Future<List<Book>> getBooks() async {
    return await bookService.loadBooks(); // Loads books from JSON
  }

  @override
  Future<List<Verse>> getVerses(String reference) async {
    if (currentVersion == 'amharic') {
      return await amharicBibleApiService.fetchVerses(reference);
    }
    return await localBibleService.fetchVerses(reference); // Fetches verses locally
  }
}

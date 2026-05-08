import '../repositories/bible_repository.dart';
import '../entities/book.dart';

class GetBibleBooksUseCase {
  final BibleRepository repository;

  GetBibleBooksUseCase(this.repository);

  Future<List<Book>> call() async {
    return await repository.getBooks();
  }
}

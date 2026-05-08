import '../repositories/bible_repository.dart';
import '../entities/bible_model.dart';

class GetChapterVersesUseCase {
  final BibleRepository repository;

  GetChapterVersesUseCase(this.repository);

  Future<List<Verse>> call(String reference) {
    return repository.getVerses(reference);
  }
}

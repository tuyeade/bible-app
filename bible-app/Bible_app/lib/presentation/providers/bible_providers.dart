import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local_bible_service.dart';
import '../../data/amharic_bible_api_service.dart';
import '../../data/repositories/bible_repository_impl.dart';
import '../../domain/entities/bible_model.dart';
import '../../domain/repositories/bible_repository.dart';
import '../../domain/usecases/get_chapter_verses_use_case.dart';
import '../../data/book_service.dart';

// Version State Provider
final bibleVersionProvider = StateProvider<String>((ref) => 'en_kjv');

// Local Bible Service Provider
final localBibleServiceProvider = Provider((ref) => LocalBibleService());

// Amharic Bible API Service Provider
final amharicBibleServiceProvider = Provider((ref) {
  final localBible = ref.watch(localBibleServiceProvider);
  return AmharicBibleApiService(localBibleService: localBible);
});

// Book Service Provider
final bookServiceProvider = Provider((ref) => BookService());

// Repository Provider
final bibleRepositoryProvider = Provider<BibleRepository>((ref) {
  final localBible = ref.watch(localBibleServiceProvider);
  final amharicBible = ref.watch(amharicBibleServiceProvider);
  final book = ref.watch(bookServiceProvider);
  final currentVersion = ref.watch(bibleVersionProvider);
  
  return BibleRepositoryImpl(
    localBibleService: localBible, 
    amharicBibleApiService: amharicBible,
    bookService: book,
    currentVersion: currentVersion,
  );
});

// Use Case Provider
final getChapterVersesProvider = Provider((ref) {
  final repository = ref.watch(bibleRepositoryProvider);
  return GetChapterVersesUseCase(repository);
});

// Verses Provider (FutureProvider.family allows parameter)
final versesProvider = FutureProvider.family<List<Verse>, String>((
  ref,
  reference,
) {
  final usecase = ref.watch(getChapterVersesProvider);
  return usecase(reference);
});

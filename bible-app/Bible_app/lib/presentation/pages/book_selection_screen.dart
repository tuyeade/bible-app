import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/book.dart';
import '../../data/book_service.dart';
import '../providers/bible_providers.dart';
import '../../core/localization/amharic_localization.dart';
import 'chapter_selection_screen.dart';

class BookSelectionScreen extends ConsumerStatefulWidget {
  const BookSelectionScreen({super.key});

  @override
  ConsumerState<BookSelectionScreen> createState() =>
      _BookSelectionScreenState();
}

class _BookSelectionScreenState extends ConsumerState<BookSelectionScreen> {
  final BookService _bookService = BookService();
  late Future<List<Book>> _booksFuture;

  // To handle filtering
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _booksFuture = _bookService.loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    final isAmharic = ref.watch(bibleVersionProvider) == 'amharic';

    String t(String text) {
      return isAmharic ? AmharicLocalization.translateUiText(text) : text;
    }

    String b(String name) {
      return isAmharic ? AmharicLocalization.translateBookName(name) : name;
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            t('Select Book'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
            dividerColor: Theme.of(context).dividerColor.withOpacity(0.5),
            tabs: [
              Tab(text: t('Old Testament')),
              Tab(text: t('New Testament')),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                decoration: InputDecoration(
                  hintText: t('Search books...'),
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Book>>(
                future: _booksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        t('Error loading books'),
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        t('No books available'),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    );
                  }

                  final allBooks = snapshot.data!;

                  return TabBarView(
                    children: [
                      _buildBookList(allBooks, true, _searchQuery, t, b),
                      _buildBookList(allBooks, false, _searchQuery, t, b),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookList(
    List<Book> allBooks,
    bool isOldTestament,
    String searchQuery,
    String Function(String) t,
    String Function(String) b,
  ) {
    final filteredBooks = allBooks
        .asMap()
        .entries
        .where((entry) {
          final index = entry.key;
          final book = entry.value;

          // Genesis to Malachi (0 to 38) are Old Testament. Matthew to Revelation (39 to 65) are New Testament.
          if (isOldTestament && index >= 39) return false;
          if (!isOldTestament && index < 39) return false;

          // Filter by translated name or english name
          final translatedName = b(book.name).toLowerCase();
          final originalName = book.name.toLowerCase();
          return translatedName.contains(searchQuery) ||
              originalName.contains(searchQuery);
        })
        .map((e) => e.value)
        .toList();

    if (filteredBooks.isEmpty) {
      return Center(
        child: Text(
          t('No books found'),
          style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: filteredBooks.length,
      itemBuilder: (context, index) {
        final book = filteredBooks[index];
        final testamentStr = book.testament.isNotEmpty
            ? '${t(book.testament)} • '
            : '';

        return Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            title: Text(
              b(book.name),
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                '$testamentStr${book.chapters} ${t("Chapters")}',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 13,
                ),
              ),
            ),
            trailing: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceTint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.secondary,
                size: 24,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChapterSelectionScreen(book: book),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

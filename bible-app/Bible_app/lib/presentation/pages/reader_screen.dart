import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/bible_model.dart';
import '../providers/bible_providers.dart';
import '../../core/localization/amharic_localization.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final Book book;
  final int chapter;

  const ReaderScreen({super.key, required this.book, required this.chapter});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  late PageController _pageController;
  late int _currentChapter;

  @override
  void initState() {
    super.initState();
    _currentChapter = widget.chapter;
    _pageController = PageController(initialPage: _currentChapter - 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentVersion = ref.watch(bibleVersionProvider);

    final isAmharic = currentVersion == 'amharic';
    
    String t(String text) {
      return isAmharic ? AmharicLocalization.translateUiText(text) : text;
    }

    String b(String name) {
      return isAmharic ? AmharicLocalization.translateBookName(name) : name;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Theme.of(context).appBarTheme.iconTheme?.color ?? Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${b(widget.book.name)} $_currentChapter',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).appBarTheme.foregroundColor),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: Theme.of(context).appBarTheme.iconTheme?.color ?? Theme.of(context).iconTheme.color,
            ),
          ],
        ),
        actions: [
          // Version Toggle
          DropdownButton<String>(
            value: currentVersion,
            dropdownColor: Theme.of(context).cardColor,
            iconEnabledColor: Theme.of(context).appBarTheme.iconTheme?.color ?? Theme.of(context).iconTheme.color,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'en_kjv', child: Text('KJV')),
              DropdownMenuItem(value: 'amharic', child: Text('አማርኛ')),
            ],
            onChanged: (val) {
              if (val != null) {
                ref.read(bibleVersionProvider.notifier).state = val;
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.text_fields, color: Theme.of(context).appBarTheme.iconTheme?.color ?? Theme.of(context).iconTheme.color),
            onPressed: () {},
          ),
        ],
        elevation: 0,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.book.chapters,
        onPageChanged: (index) {
          setState(() {
            _currentChapter = index + 1;
          });
        },
        itemBuilder: (context, index) {
          final pageChapter = index + 1;
          final reference = '${widget.book.name} $pageChapter';
          
          return Consumer(
            builder: (context, ref, _) {
              final versesAsyncValue = ref.watch(versesProvider(reference));
              
              return Stack(
                children: [
                  versesAsyncValue.when(
            loading: () => Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              ),
            ),
            error: (err, stack) => Center(
              child: Text(
                '${t("Error")}: $err',
                style: const TextStyle(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            ),
            data: (verses) {
              if (verses.isEmpty) {
                return Center(
                  child: Text(
                    t('No verses found.'),
                    style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 120,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            b(widget.book.name).toUpperCase(),
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isAmharic ? '${t("Chapter")} $pageChapter' : 'Chapter $pageChapter',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...verses.map(
                      (verse) => Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: _buildVerse(context, verse, isAmharic),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    },
  );
},
      ),
    );
  }

  Widget _buildVerse(BuildContext context, Verse verse, bool isAmharic) {
    String verseText = verse.text;
    
    // Fix issue where Amharic JSON contains "[Merged With next verse]" or "[see V...]"
    if (isAmharic) {
      // Catch "[Merged With next verse]"
      verseText = verseText.replaceAll(
        RegExp(r'\[Merged [Ww]ith next verse\]', caseSensitive: false), 
        '[ከሚቀጥለው ጥቅስ ጋር ተዋህዷል]'
      );
      
      // Catch "[see V2]" or "[see v 2]"
      verseText = verseText.replaceAllMapped(
        RegExp(r'\[see [Vv]\s*(\d+)\]', caseSensitive: false),
        (match) => '[ጥቅስ ${match.group(1)} ተመልከት]'
      );

      // Catch "[see verse 2]"
      verseText = verseText.replaceAllMapped(
        RegExp(r'\[see verse\s*(\d+)\]', caseSensitive: false),
        (match) => '[ጥቅስ ${match.group(1)} ተመልከት]'
      );

      // Wipe out any remaining generic [English text] artifacts
      verseText = verseText.replaceAll(
        RegExp(r'\[[a-zA-Z0-9\s\.\,\-\:]+\]'),
        ''
      ).trim();
      
      // Remove any literal '[' or ']' around Amharic interpolated texts
      // so it reads smoothly without ugly brackets.
      verseText = verseText.replaceAll('[', '').replaceAll(']', '');
    }

    return RichText(
      text: TextSpan(
        style: isAmharic 
          ? const TextStyle(fontSize: 22, height: 1.8) 
          : GoogleFonts.lora(fontSize: 20, height: 1.6),
        children: [
          TextSpan(
            text: '${verse.verse}  ',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          TextSpan(
            text: verseText,
            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
        ],
      ),
    );
  }
}

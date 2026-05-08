import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/book.dart';
import '../providers/theme_provider.dart';
import '../providers/bible_providers.dart';
import '../../core/localization/amharic_localization.dart';
import 'book_selection_screen.dart';
import 'chapter_selection_screen.dart';

class HomeScreen extends ConsumerWidget {
  // Optional: pass last read book & chapter dynamically
  final Book? lastReadBook;
  final int? lastReadChapter;

  const HomeScreen({super.key, this.lastReadBook, this.lastReadChapter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current theme to change the icon appropriately
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
    final isAmharic = ref.watch(bibleVersionProvider) == 'amharic';
    
    String t(String text) => isAmharic ? AmharicLocalization.translateUiText(text) : text;
    String b(String name) => isAmharic ? AmharicLocalization.translateBookName(name) : name;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF1CA2F1),
            child: const Icon(Icons.person, color: Colors.white, size: 18),
          ),
        ),
        title: const Text(
          'My Bible App',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        actions: [
          DropdownButton<String>(
            value: ref.watch(bibleVersionProvider),
            dropdownColor: Theme.of(context).cardColor,
            iconEnabledColor: Theme.of(context).appBarTheme.iconTheme?.color ?? Theme.of(context).iconTheme.color,
            underline: const SizedBox(),
            items: const [
               DropdownMenuItem(value: 'en_kjv', child: Text('KJV', style: TextStyle(fontSize: 14))),
               DropdownMenuItem(value: 'amharic', child: Text('አማ', style: TextStyle(fontSize: 14))),
            ],
            onChanged: (val) {
              if (val != null) {
                ref.read(bibleVersionProvider.notifier).state = val;
              }
            },
          ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVerseOfTheDay(context, t),
              const SizedBox(height: 24),
              _buildSectionTitle(context, t('CONTINUE READING'), actionTitle: t('See All')),
              const SizedBox(height: 12),
              _buildContinueReading(context, t, b, isAmharic),
              const SizedBox(height: 24),
              _buildSectionTitle(context, t('DAILY DEVOTIONAL'), actionTitle: t('View All')),
              const SizedBox(height: 12),
              _buildDailyDevotionals(context, t),
              const SizedBox(height: 24),
              _buildSectionTitle(context, t('HOW ARE YOU FEELING?')),
              const SizedBox(height: 12),
              _buildMoodTracker(context, t),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerseOfTheDay(BuildContext context, String Function(String) t) {
    return GestureDetector(
      onTap: () {
        // Go to full book selection if tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BookSelectionScreen()),
        );
      },
      child: Container(
        height: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Text(
                  t('VERSE OF THE DAY').toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF81D4FA),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '"The Lord is my shepherd;\nI shall not want. He makes me\nlie down in green pastures."',
                style: GoogleFonts.lora(
                  color: Colors.white,
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Psalm 23:1-2',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(
                          Icons.bookmark_border,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueReading(BuildContext context, String Function(String) t, String Function(String) b, bool isAmharic) {
    return GestureDetector(
      onTap: () {
        // Navigate to ChapterSelectionScreen dynamically (example with Psalm chapter 23)
        if (lastReadBook != null && lastReadChapter != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChapterSelectionScreen(
                book: lastReadBook!,
              ), // Pass the required book parameter
            ),
          );
        } else {
          // Default fallback
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BookSelectionScreen(),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceTint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.menu_book,
                color: Theme.of(context).colorScheme.secondary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${b("Psalms")} 23',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAmharic ? 'ጥቅስ 1-2: "እግዚአብሔር እረኛዬ ነው..."' : 'Verse 1-2: "The Lord is my shepherd..."',
                    style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: CircularProgressIndicator(
                    value: 0.65,
                    strokeWidth: 4,
                    backgroundColor: Theme.of(context).dividerColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Text(
                  '65%',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, {String? actionTitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        if (actionTitle != null)
          Text(
            actionTitle,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _buildDailyDevotionals(BuildContext context, String Function(String) t) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surfaceTint,
            ),
            child: Icon(
              Icons.menu_book,
              color: Theme.of(context).colorScheme.secondary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t('Walking in Faith'),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  t('Day 4 of 7 • 5 min read'),
                  style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 13),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
        ],
      ),
    );
  }

  Widget _buildMoodTracker(BuildContext context, String Function(String) t) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMoodItem(context, '😢', t('Sad')),
        _buildMoodItem(context, '😠', t('Angry')),
        _buildMoodItem(context, '🙏', t('Grateful')),
        _buildMoodItem(context, '😊', t('Joyful')),
        _buildMoodItem(context, '❤️', t('Loved')),
      ],
    );
  }

  Widget _buildMoodItem(BuildContext context, String emoji, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 24)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 11),
        ),
      ],
    );
  }
}

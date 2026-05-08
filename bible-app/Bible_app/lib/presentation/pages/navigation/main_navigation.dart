import 'package:flutter/material.dart';

import '../home_screen.dart';
import '../book_selection_screen.dart';
import '../library_plans_screen.dart';
import '../../../domain/entities/book.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Default values for initial experience
  final lastReadBook = Book(
    abbr: 'Gen',
    name: 'Genesis',
    desc: 'The first book of the Bible',
    testament: 'Old Testament',
    chapters: 50,
  );
  final lastReadChapter = 1;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(lastReadBook: lastReadBook, lastReadChapter: lastReadChapter),
      const BookSelectionScreen(),
      const LibraryPlansScreen(),
      const Center(
        child: Text(
          "Discover",
          style: TextStyle(fontSize: 18),
        ),
      ),
      const Center(
        child: Text(
          "More",
          style: TextStyle(fontSize: 18),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Theme.of(context).dividerColor, width: 1.0)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'BIBLE',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'PLANS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'DISCOVER',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'MORE',
            ),
          ],
        ),
      ),
    );
  }
}

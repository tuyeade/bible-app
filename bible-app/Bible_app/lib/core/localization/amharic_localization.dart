// Helper functionality to translate English UI strings and Bible Book Names to Amharic.

class AmharicLocalization {
  
  // Translates the English book name (e.g., 'Genesis') to Amharic
  static String translateBookName(String englishName) {
    final lower = englishName.toLowerCase();
    return _bookNames[lower] ?? englishName;
  }

  // Translates UI text like 'Old Testament' to Amharic
  static String translateUiText(String englishText) {
    if (englishText.isEmpty) return '';
    final lower = englishText.toLowerCase().trim();
    if (_uiText.containsKey(lower)) {
      // Preserve capitalization if needed? No, usually Amharic doesn't have casing.
      return _uiText[lower]!;
    }
    return englishText;
  }

  // A mapping of standard UI terms.
  static const Map<String, String> _uiText = {
    'old testament': 'ብሉይ ኪዳን',
    'new testament': 'አዲስ ኪዳን',
    'chapter': 'ምዕራፍ',
    'chapters': 'ምዕራፎች',
    'chapters in total': 'ምዕራፎች በድምሩ',
    'select book': 'መጽሐፍ ይምረጡ',
    'select chapter': 'ምዕራፍ ይምረጡ',
    'continue reading': 'ማንበብ ይቀጥሉ',
    'from the beginning': 'ከመጀመሪያው',
    'share': 'አጋራ',
    'save': 'አስቀምጥ',
    'verse of the day': 'የእለቱ ጥቅስ',
    'daily devotional': 'የዕለት መንፈሳዊ ትምህርት',
    'how are you feeling?': 'እንዴት ይሰማዎታል?',
    'see all': 'ሁሉንም እይ',
    'view all': 'ሁሉንም እይ',
    'search books...': 'መጽሐፍትን ፈልግ...',
    'no books found': 'ምንም መጽሐፍ አልተገኘም',
    'error loading books': 'መጽሐፍትን መጫን አልተቻለም',
    'of': 'ከ',
    'no verses found.': 'ምንም ጥቅሶች አልተገኙም.',
    'error': 'ስህተት',
    'sad': 'ሐዘን',
    'angry': 'ቁጣ',
    'grateful': 'ምስጋና',
    'joyful': 'ደስታ',
    'loved': 'ፍቅር',
    'walking in faith': 'በእምነት መራመድ',
    'day 4 of 7 • 5 min read': 'ቀን 4 ከ 7 • የ 5 ደቂቃ ንባብ',
    'previous': 'ቀዳሚ',
    'next': 'ቀጣይ',
  };

  // The 66 books of the Protestant Bible mapped to Amharic (ኦሪት, መጽሐፈ, ትንቢተ, ወዘተ)
  static const Map<String, String> _bookNames = {
    'genesis': 'ኦሪት ዘፍጥረት',
    'exodus': 'ኦሪት ዘጸአት',
    'leviticus': 'ኦሪት ዘሌዋውያን',
    'numbers': 'ኦሪት ዘኍልቍ',
    'deuteronomy': 'ኦሪት ዘዳግም',
    'joshua': 'መጽሐፈ ኢያሱ ወልደ ነዌ',
    'judges': 'መጽሐፈ መሳፍንት',
    'ruth': 'መጽሐፈ ሩት',
    '1 samuel': 'መጽሐፈ ሳሙኤል ቀዳማዊ',
    '2 samuel': 'መጽሐፈ ሳሙኤል ካልዕ',
    '1 kings': 'መጽሐፈ ነገሥት ቀዳማዊ',
    '2 kings': 'መጽሐፈ ነገሥት ካልዕ',
    '1 chronicles': 'መጽሐፈ ዜና መዋዕል ቀዳማዊ',
    '2 chronicles': 'መጽሐፈ ዜና መዋዕል ካልዕ',
    'ezra': 'መጽሐፈ ዕዝራ',
    'nehemiah': 'መጽሐፈ ነህምያ',
    'esther': 'መጽሐፈ አስቴር',
    'job': 'መጽሐፈ ኢዮብ',
    'psalms': 'መዝሙረ ዳዊት',
    'psalm': 'መዝሙረ ዳዊት',
    'proverbs': 'መጽሐፈ ምሳሌ',
    'ecclesiastes': 'መጽሐፈ መክብብ',
    'song of solomon': 'መኃልየ መኃልይ ዘሰሎሞን',
    'isaiah': 'ትንቢተ ኢሳይያስ',
    'jeremiah': 'ትንቢተ ኤርምያስ',
    'lamentations': 'ሰቆቃወ ኤርምያስ',
    'ezekiel': 'ትንቢተ ሕዝቅኤል',
    'daniel': 'ትንቢተ ዳንኤል',
    'hosea': 'ትንቢተ ሆሴዕ',
    'joel': 'ትንቢተ ኢዮኤል',
    'amos': 'ትንቢተ አሞጽ',
    'obadiah': 'ትንቢተ አብድዩ',
    'jonah': 'ትንቢተ ዮናስ',
    'micah': 'ትንቢተ ሚክያስ',
    'nahum': 'ትንቢተ ናሆም',
    'habakkuk': 'ትንቢተ ዕንባቆም',
    'zephaniah': 'ትንቢተ ሶፎንያስ',
    'haggai': 'ትንቢተ ሐጌ',
    'zechariah': 'ትንቢተ ዘካርያስ',
    'malachi': 'ትንቢተ ሚልክያስ',
    'matthew': 'የማቴዎስ ወንጌል',
    'mark': 'የማርቆስ ወንጌል',
    'luke': 'የሉቃስ ወንጌል',
    'john': 'የዮሐንስ ወንጌል',
    'acts': 'የሐዋርያት ሥራ',
    'romans': 'ወደ ሮሜ ሰዎች',
    '1 corinthians': '1ኛ ወደ ቆሮንቶስ ሰዎች',
    '2 corinthians': '2ኛ ወደ ቆሮንቶስ ሰዎች',
    'galatians': 'ወደ ገላትያ ሰዎች',
    'ephesians': 'ወደ ኤፌሶን ሰዎች',
    'philippians': 'ወደ ፊልጵስዩስ ሰዎች',
    'colossians': 'ወደ ቆላስይስ ሰዎች',
    '1 thessalonians': '1ኛ ወደ ተሰሎንቄ ሰዎች',
    '2 thessalonians': '2ኛ ወደ ተሰሎንቄ ሰዎች',
    '1 timothy': '1ኛ ወደ ጢሞቴዎስ',
    '2 timothy': '2ኛ ወደ ጢሞቴዎስ',
    'titus': 'ወደ ቲቶ',
    'philemon': 'ወደ ፊልሞና',
    'hebrews': 'ወደ ዕብራውያን',
    'james': 'የያዕቆብ መልእክት',
    '1 peter': 'የጴጥሮስ 1ኛ መልእክት',
    '2 peter': 'የጴጥሮስ 2ኛ መልእክት',
    '1 john': 'የዮሐንስ 1ኛ መልእክት',
    '2 john': 'የዮሐንስ 2ኛ መልእክት',
    '3 john': 'የዮሐንስ 3ኛ መልእክት',
    'jude': 'የይሁዳ መልእክት',
    'revelation': 'የዮሐንስ ራእይ',
  };
}

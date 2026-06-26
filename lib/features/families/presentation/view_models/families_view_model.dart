import 'package:flutter/material.dart';
import 'package:global_language_distribution_map/data/models/language.dart';
import 'package:global_language_distribution_map/data/repositories/language_repository.dart';

/// Data class representing a language family with stats.
class FamilyStat {
  final String name;
  final int languageCount;
  final String speakerCount; // Display string like "3.2 Billion"
  final String emoji;

  const FamilyStat({
    required this.name,
    required this.languageCount,
    required this.speakerCount,
    required this.emoji,
  });
}

/// ViewModel for the Families screen.
class FamiliesViewModel extends ChangeNotifier {
  final LanguageRepository _repository;

  List<FamilyStat> _allFamilies = [];
  List<FamilyStat> _filteredFamilies = [];
  String _searchQuery = '';
  bool _isLoading = true;

  static const Map<String, String> _speakerCounts = {
    'Indo-European': '3.2 Billion',
    'Sino-Tibetan': '1.4 Billion',
    'Niger-Congo': '700 Million',
    'Afro-Asiatic': '400 Million',
    'Austronesian': '386 Million',
    'Dravidian': '250 Million',
    'Turkic': '200 Million',
    'Japonic': '128 Million',
    'Tai-Kadai': '93 Million',
    'Koreanic': '82 Million',
    'Austroasiatic': '117 Million',
    'Uralic': '25 Million',
  };

  static const Map<String, String> _familyEmojis = {
    'Indo-European': '🇪🇺',
    'Sino-Tibetan': '🇨🇳',
    'Afro-Asiatic': '🌍',
    'Niger-Congo': '🌾',
    'Austronesian': '🌴',
    'Dravidian': '🛕',
    'Turkic': '🐎',
    'Japonic': '🇯🇵',
    'Koreanic': '🇰🇷',
    'Tai-Kadai': '🐘',
    'Austroasiatic': '🍜',
    'Uralic': '🌲',
    'Bookkeeping': '📚',
    'Tuu': '🏜️',
    'Khoe-Kwadi': '🐐',
  };

  FamiliesViewModel({required LanguageRepository repository})
      : _repository = repository {
    _loadFamilies();
  }

  List<FamilyStat> get filteredFamilies => _filteredFamilies;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  int get totalFamilies => _allFamilies.length;

  void _loadFamilies() {
    final all = _repository.getAllLanguages();
    final familyCounts = <String, int>{};
    for (final lang in all) {
      familyCounts[lang.languageFamily] =
          (familyCounts[lang.languageFamily] ?? 0) + 1;
    }

    // Sort by language count (descending)
    final sortedEntries = familyCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    _allFamilies = sortedEntries.map((entry) {
      return FamilyStat(
        name: entry.key,
        languageCount: entry.value,
        speakerCount: _speakerCounts[entry.key] ?? 'Unknown',
        emoji: _familyEmojis[entry.key] ?? '🗣',
      );
    }).toList();

    _filteredFamilies = _allFamilies;
    _isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredFamilies = _allFamilies;
    } else {
      final lower = query.toLowerCase();
      _filteredFamilies = _allFamilies
          .where((f) => f.name.toLowerCase().contains(lower))
          .toList();
    }
    notifyListeners();
  }

  /// Returns languages for a given family.
  List<Language> getLanguagesForFamily(String family) {
    return _repository.filterByFamily(family);
  }
}

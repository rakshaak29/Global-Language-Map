import 'package:flutter/material.dart';
import 'package:global_language_distribution_map/core/constants/app_constants.dart';
import 'package:global_language_distribution_map/data/repositories/language_repository.dart';

/// Data class representing a single guided tour.
class TourData {
  final String name;
  final String description;
  final String langCount;
  final Color color;
  final Color dotColor;
  final List<String> regions;

  const TourData({
    required this.name,
    required this.description,
    required this.langCount,
    required this.color,
    required this.dotColor,
    required this.regions,
  });
}

/// ViewModel for the Tours screen.
class ToursViewModel extends ChangeNotifier {
  final LanguageRepository _repository;

  late final List<TourData> _tours;
  bool _isRunning = false;
  String? _activeTourName;

  ToursViewModel({required LanguageRepository repository})
      : _repository = repository {
    _buildTours();
  }

  List<TourData> get tours => _tours;
  bool get isRunning => _isRunning;
  String? get activeTourName => _activeTourName;

  void _buildTours() {
    _tours = AppConstants.guidedTours.map((tourData) {
      return TourData(
        name: tourData['name'] as String,
        description: tourData['description'] as String,
        langCount: tourData['langCount'] as String,
        color: Color(int.parse(tourData['color'] as String)),
        dotColor: Color(int.parse(tourData['dotColor'] as String)),
        regions: List<String>.from(tourData['regions'] as List),
      );
    }).toList();
  }

  /// Start a guided tour — returns languages filtered for this tour's region.
  void startTour(TourData tour) {
    _isRunning = true;
    _activeTourName = tour.name;
    notifyListeners();
  }

  void stopTour() {
    _isRunning = false;
    _activeTourName = null;
    notifyListeners();
  }

  int getLanguageCountForRegion(List<String> regions) {
    final all = _repository.getAllLanguages();
    return all.where((lang) {
      final region = lang.countryRegion.toUpperCase();
      return regions.any((r) => region.contains(r.toUpperCase()));
    }).length;
  }
}

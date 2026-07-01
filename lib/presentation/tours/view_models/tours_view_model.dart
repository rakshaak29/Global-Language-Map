import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:global_language_distribution_map/core/constants/app_constants.dart';
import 'package:global_language_distribution_map/data/models/language.dart';
import 'package:global_language_distribution_map/data/repositories/language_repository.dart';
import 'package:global_language_distribution_map/data/services/kml_service.dart';
import 'package:global_language_distribution_map/data/services/liquid_galaxy_service.dart';

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
  final LiquidGalaxyService _lgService;

  late final List<TourData> _tours;
  bool _isRunning = false;
  bool _isPaused = false;
  TourData? _activeTour;
  
  List<Language> _tourLanguages = [];
  int _currentWaypointIndex = 0;
  Timer? _playbackTimer;

  // Stream for notifying MapScreen about waypoint changes
  final _waypointController = StreamController<Language>.broadcast();
  Stream<Language> get onWaypointChanged => _waypointController.stream;

  ToursViewModel({
    required LanguageRepository repository,
    required LiquidGalaxyService lgService,
  })  : _repository = repository,
        _lgService = lgService {
    _buildTours();
  }

  List<TourData> get tours => _tours;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;
  String? get activeTourName => _activeTour?.name;
  TourData? get activeTour => _activeTour;
  List<Language> get tourLanguages => _tourLanguages;
  int get currentWaypointIndex => _currentWaypointIndex;
  int get totalWaypoints => _tourLanguages.length;
  Language? get currentWaypoint =>
      _tourLanguages.isNotEmpty && _currentWaypointIndex < _tourLanguages.length
          ? _tourLanguages[_currentWaypointIndex]
          : null;

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

  /// Get list of languages corresponding to the tour regions.
  /// Filters to mappable languages and takes the top 8 by speaker count.
  List<Language> getTourLanguagesList(TourData tour) {
    final all = _repository.getAllLanguages();
    final filtered = all.where((lang) {
      if (!lang.hasCoordinates) return false;
      final region = lang.countryRegion.toUpperCase();
      return tour.regions.any((r) => region.contains(r.toUpperCase()));
    }).toList();

    // Sort by speaker count descending and limit to top 8
    filtered.sort((a, b) => b.speakerCount.compareTo(a.speakerCount));
    return filtered.take(8).toList();
  }

  /// Start a guided tour
  void startTour(TourData tour) {
    stopTour(); // Stop any active tour first

    _activeTour = tour;
    _tourLanguages = getTourLanguagesList(tour);
    
    if (_tourLanguages.isEmpty) {
      _isRunning = false;
      return;
    }

    _isRunning = true;
    _isPaused = false;
    _currentWaypointIndex = 0;

    _triggerWaypoint();
    _startTimer();
    notifyListeners();
  }

  /// Pause the tour playback
  void pauseTour() {
    if (!_isRunning || _isPaused) return;
    _isPaused = true;
    _playbackTimer?.cancel();
    notifyListeners();
  }

  /// Resume the tour playback
  void resumeTour() {
    if (!_isRunning || !_isPaused) return;
    _isPaused = false;
    _startTimer();
    notifyListeners();
  }

  /// Stop the tour
  void stopTour() {
    _playbackTimer?.cancel();
    _playbackTimer = null;
    _isRunning = false;
    _isPaused = false;
    _activeTour = null;
    _tourLanguages = [];
    _currentWaypointIndex = 0;
    notifyListeners();
  }

  void _startTimer() {
    _playbackTimer?.cancel();
    // Move to next waypoint every 6 seconds
    _playbackTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      _nextWaypoint();
    });
  }

  void _nextWaypoint() {
    if (_currentWaypointIndex < _tourLanguages.length - 1) {
      _currentWaypointIndex++;
      _triggerWaypoint();
      notifyListeners();
    } else {
      stopTour();
    }
  }

  void _triggerWaypoint() {
    final lang = currentWaypoint;
    if (lang != null) {
      _waypointController.add(lang);
      
      if (_lgService.isConnected) {
        _lgService.flyTo(
          latitude: lang.latitude,
          longitude: lang.longitude,
          name: lang.name,
        );
      }
    }
  }

  /// Generate gx:Tour compatible KML content.
  String generateTourKml(TourData tour) {
    final langs = getTourLanguagesList(tour);
    return KmlService.generateTourKml(tour.name, langs);
  }

  /// Export tour compatible KML to a file.
  Future<void> exportTourKml(TourData tour) async {
    final kmlContent = generateTourKml(tour);
    final safeName = tour.name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_');
    final filename = 'tour_$safeName';
    final bytes = Uint8List.fromList(utf8.encode(kmlContent));

    await FileSaver.instance.saveFile(
      name: filename,
      bytes: bytes,
      ext: 'kml',
      mimeType: MimeType.other,
    );
  }

  int getLanguageCountForRegion(List<String> regions) {
    final all = _repository.getAllLanguages();
    return all.where((lang) {
      final region = lang.countryRegion.toUpperCase();
      return regions.any((r) => region.contains(r.toUpperCase()));
    }).length;
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    _waypointController.close();
    super.dispose();
  }
}

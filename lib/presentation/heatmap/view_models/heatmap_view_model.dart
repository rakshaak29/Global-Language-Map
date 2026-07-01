import 'dart:convert';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:global_language_distribution_map/data/repositories/language_repository.dart';
import 'package:global_language_distribution_map/data/services/heatmap_service.dart';

/// ViewModel for the Linguistic Diversity Heatmap Screen.
class HeatmapViewModel extends ChangeNotifier {
  final LanguageRepository _repository;
  
  List<HeatmapCell> _cells = [];
  bool _isLoading = true;
  bool _heatmapEnabled = true;

  HeatmapViewModel({required LanguageRepository repository})
      : _repository = repository {
    _calculateDensity();
  }

  List<HeatmapCell> get cells => _cells;
  bool get isLoading => _isLoading;
  bool get heatmapEnabled => _heatmapEnabled;

  void toggleHeatmap(bool value) {
    _heatmapEnabled = value;
    notifyListeners();
  }

  void _calculateDensity() {
    final languages = _repository.getAllLanguages();
    _cells = HeatmapService.calculateDensity(languages);
    _isLoading = false;
    notifyListeners();
  }

  /// Export Heatmap KML overlay to a file.
  Future<void> exportHeatmapKml() async {
    final kmlContent = HeatmapService.generateHeatmapKml(_cells);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filename = 'language_density_heatmap_$timestamp';
    final bytes = Uint8List.fromList(utf8.encode(kmlContent));

    await FileSaver.instance.saveFile(
      name: filename,
      bytes: bytes,
      ext: 'kml',
      mimeType: MimeType.other,
    );
  }
}

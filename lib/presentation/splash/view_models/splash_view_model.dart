import 'package:flutter/material.dart';
import 'package:global_language_distribution_map/data/repositories/language_repository.dart';

/// ViewModel for the Splash screen.
///
/// Handles initial data loading and reports readiness.
class SplashViewModel extends ChangeNotifier {
  final LanguageRepository _repository;

  bool _isLoading = true;
  bool _isReady = false;
  String? _error;
  String _statusMessage = 'Initializing...';

  SplashViewModel({required LanguageRepository repository})
      : _repository = repository;

  bool get isLoading => _isLoading;
  bool get isReady => _isReady;
  String? get error => _error;
  String get statusMessage => _statusMessage;

  /// Load all required data for the application.
  Future<void> initialize() async {
    try {
      _statusMessage = 'Loading language data...';
      notifyListeners();

      await _repository.loadData();

      _statusMessage =
          'Loaded ${_repository.totalCount} languages';
      _isLoading = false;
      _isReady = true;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load data: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
}

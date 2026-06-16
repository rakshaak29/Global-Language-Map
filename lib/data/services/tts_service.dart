import 'package:flutter_tts/flutter_tts.dart';

/// Service that provides text-to-speech functionality for language details.
///
/// Uses Flutter TTS to read aloud language information when a marker
/// is tapped on the map. Designed as a singleton to avoid creating
/// multiple TTS engine instances.
class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  bool _isSpeaking = false;

  TtsService._internal();

  bool get isSpeaking => _isSpeaking;

  /// Initialize the TTS engine with default settings.
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setStartHandler(() {
      _isSpeaking = true;
    });

    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
    });

    _flutterTts.setCancelHandler(() {
      _isSpeaking = false;
    });

    _flutterTts.setErrorHandler((msg) {
      _isSpeaking = false;
    });

    _isInitialized = true;
  }

  /// Speak the provided text. Stops any current speech first.
  Future<void> speak(String text) async {
    await initialize();
    await stop();
    _isSpeaking = true;
    await _flutterTts.speak(text);
  }

  /// Stop current speech.
  Future<void> stop() async {
    _isSpeaking = false;
    await _flutterTts.stop();
  }

  /// Generate a natural-sounding description for a language.
  static String buildLanguageDescription({
    required String name,
    required String family,
    required String endangeredStatus,
    required String countryRegion,
    required double latitude,
    required double longitude,
  }) {
    final buffer = StringBuffer();

    buffer.write('$name. ');
    buffer.write('This language belongs to the $family family. ');
    buffer.write('It is spoken in $countryRegion. ');

    // Describe endangerment status naturally
    switch (endangeredStatus.toLowerCase()) {
      case 'not endangered':
        buffer.write('This language is currently not endangered. ');
        break;
      case 'threatened':
        buffer.write('This language is classified as threatened. ');
        break;
      case 'shifting':
        buffer.write(
            'This language is shifting, meaning fewer people are learning it. ');
        break;
      case 'moribund':
        buffer.write(
            'This language is moribund, with very few remaining speakers. ');
        break;
      case 'nearly extinct':
        buffer.write(
            'This language is nearly extinct, with only a handful of speakers left. ');
        break;
      case 'extinct':
        buffer.write('This language is unfortunately extinct. ');
        break;
      default:
        buffer.write('Its endangerment status is $endangeredStatus. ');
    }

    buffer.write(
        'Located at coordinates ${latitude.toStringAsFixed(2)} latitude, '
        '${longitude.toStringAsFixed(2)} longitude.');

    return buffer.toString();
  }

  /// Dispose of the TTS engine.
  Future<void> dispose() async {
    await stop();
    _isInitialized = false;
  }
}

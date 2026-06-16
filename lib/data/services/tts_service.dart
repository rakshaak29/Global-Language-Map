import 'package:flutter_tts/flutter_tts.dart';

/// Service that provides text-to-speech functionality for language details.
///
/// Uses Flutter TTS to read aloud language information when a marker
/// is tapped on the map. Designed as a singleton with fully lazy
/// initialization — the TTS engine is only created on first user-triggered
/// speak action to avoid browser autoplay restrictions.
class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  // Lazy — only created when user first taps speak
  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  bool _isSpeaking = false;

  TtsService._internal();

  bool get isSpeaking => _isSpeaking;

  /// Initialize the TTS engine lazily on first use.
  /// Must only be called from a user gesture context (tap/click).
  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;

    try {
      _flutterTts = FlutterTts();

      // Use British English for a smoother, polished accent
      await _flutterTts!.setLanguage('en-GB');

      // Moderate-fast rate for natural conversational pace
      await _flutterTts!.setSpeechRate(0.55);

      await _flutterTts!.setVolume(1.0);

      // Slightly lower pitch for a warmer, soothing tone
      await _flutterTts!.setPitch(0.9);

      _flutterTts!.setStartHandler(() {
        _isSpeaking = true;
      });

      _flutterTts!.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _flutterTts!.setCancelHandler(() {
        _isSpeaking = false;
      });

      _flutterTts!.setErrorHandler((msg) {
        _isSpeaking = false;
      });

      _isInitialized = true;
    } catch (_) {
      // TTS not available on this platform/browser
      _flutterTts = null;
      _isInitialized = false;
    }
  }

  /// Speak the provided text. Stops any current speech first.
  /// Safe to call — gracefully no-ops if TTS is unavailable.
  Future<void> speak(String text) async {
    try {
      await _ensureInitialized();
      if (_flutterTts == null) return;

      await _flutterTts!.stop();
      _isSpeaking = true;
      await _flutterTts!.speak(text);
    } catch (_) {
      _isSpeaking = false;
    }
  }

  /// Stop current speech.
  Future<void> stop() async {
    _isSpeaking = false;
    try {
      await _flutterTts?.stop();
    } catch (_) {
      // Ignore stop errors
    }
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
    _flutterTts = null;
    _isInitialized = false;
  }
}

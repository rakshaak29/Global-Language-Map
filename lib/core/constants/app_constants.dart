/// Application-wide constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'Global Language Distribution Map';
  static const String appVersion = '1.0.0';

  /// Data source attributions
  static const String glottologAttribution =
      'Language data from Glottolog 5.3 (https://glottolog.org). '
      'Licensed under CC BY 4.0.';

  static const String unescoAttribution =
      'Endangerment data from UNESCO Atlas of the World\'s Languages in Danger. '
      'Published by The Guardian.';

  /// Endangerment status display labels
  static const Map<String, String> endangermentLabels = {
    'not endangered': 'Safe',
    'threatened': 'Threatened',
    'shifting': 'Shifting',
    'moribund': 'Moribund',
    'nearly extinct': 'Nearly Extinct',
    'extinct': 'Extinct',
  };
}

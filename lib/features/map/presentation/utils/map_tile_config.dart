/// Map tile configuration.
///
/// Uses OpenStreetMap-compatible tile providers that don't require API keys.
/// CartoDB Voyager provides a colorful, Google Maps-like appearance.
class MapTileConfig {
  MapTileConfig._();

  /// CartoDB Voyager — colorful, Google Maps-like style with streets,
  /// terrain colors, and labels. Works with retina mode.
  static const String voyagerTileUrl =
      'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png';

  /// CartoDB Dark Matter — dark theme alternative.
  static const String darkTileUrl =
      'https://basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png';

  /// CartoDB Positron — clean, minimal light theme.
  static const String lightTileUrl =
      'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png';

  /// Standard OpenStreetMap tiles as fallback.
  static const String osmTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  /// Attribution for CartoDB tiles.
  static const String cartoAttribution =
      '&copy; OpenStreetMap contributors &copy; CARTO';

  /// Attribution for OSM tiles.
  static const String osmAttribution =
      '&copy; OpenStreetMap contributors';

  /// Returns the colorful Voyager tile URL (Google Maps-like appearance).
  /// Always uses Voyager regardless of theme for a familiar map look.
  static String getTileUrl(bool isDarkMode) {
    return voyagerTileUrl;
  }
}

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:xml/xml.dart';

/// Service for generating FlyTo KML views (`<LookAt>` tags) for Google Earth.
///
/// Designed to be Liquid Galaxy-independent so it can be reused later
/// via SSH commands or in-app triggers.
class FlyToService {
  FlyToService._();

  static const String _kmlNamespace = 'http://www.opengis.net/kml/2.2';

  /// Generates a reusable FlyTo KML document containing a `<LookAt>` element
  /// and a highlighted circular polygon area representing where the language is spoken.
  ///
  /// [altitudeRange] acts as the range/altitude from the target point in meters (default 50,000m ≈ 50km).
  /// [tilt] is the angle from nadir in degrees (0 = straight down, 90 = horizon, default 45°).
  /// [heading] is the compass direction in degrees (0 = north, default 0°).
  static String generateFlyToKml({
    required double latitude,
    required double longitude,
    String name = 'Location',
    double altitudeRange = 50000,
    double tilt = 45,
    double heading = 0,
  }) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element('kml',
        namespaces: {_kmlNamespace: ''},
        namespace: _kmlNamespace, nest: () {
      builder.element('Document', nest: () {
        builder.element('name', nest: 'FlyTo: $name');

        // 1. LookAt camera position
        builder.element('LookAt', nest: () {
          builder.element('longitude', nest: longitude.toStringAsFixed(6));
          builder.element('latitude', nest: latitude.toStringAsFixed(6));
          builder.element('altitude', nest: '0');
          builder.element('range', nest: altitudeRange.toStringAsFixed(0));
          builder.element('tilt', nest: tilt.toStringAsFixed(0));
          builder.element('heading', nest: heading.toStringAsFixed(0));
          builder.element('altitudeMode', nest: 'relativeToGround');
        });

        // 2. Style for the highlighted region (unique per name/language)
        final styleId = 'style-flyto';
        final uniqueColor = _stringToKmlColor(name);
        final borderColor = uniqueColor.replaceAll(RegExp(r'^..'), 'ff'); // solid border

        builder.element('Style', attributes: {'id': styleId}, nest: () {
          builder.element('IconStyle', nest: () {
            builder.element('color', nest: 'ff50af4c'); // default green icon
            builder.element('scale', nest: '1.0');
            builder.element('Icon', nest: () {
              builder.element('href', nest: () {
                builder.text(
                    'http://maps.google.com/mapfiles/kml/shapes/shaded_dot.png');
              });
            });
          });
          builder.element('LineStyle', nest: () {
            builder.element('color', nest: borderColor);
            builder.element('width', nest: '2');
          });
          builder.element('PolyStyle', nest: () {
            builder.element('color', nest: uniqueColor);
            builder.element('fill', nest: '1');
            builder.element('outline', nest: '1');
          });
        });

        // 3. Placemark with MultiGeometry (Point + Polygon highlight)
        builder.element('Placemark', nest: () {
          builder.element('name', nest: name);
          builder.element('styleUrl', nest: '#$styleId');
          builder.element('MultiGeometry', nest: () {
            // Point for map pin
            builder.element('Point', nest: () {
              builder.element('coordinates', nest: () {
                builder.text('$longitude,$latitude,0');
              });
            });

            // Polygon Circle for highlighted spoken region
            final circleCoords =
                _generateCircleCoordinates(latitude, longitude, 40000.0);
            builder.element('Polygon', nest: () {
              builder.element('outerBoundaryIs', nest: () {
                builder.element('LinearRing', nest: () {
                  builder.element('coordinates', nest: () {
                    builder.text(circleCoords.join('\n'));
                  });
                });
              });
            });
          });
        });
      });
    });

    return builder.buildDocument().toXmlString(pretty: true, indent: '  ');
  }

  /// Triggers a cross-platform download/save of the FlyTo KML snippet.
  static Future<void> saveFlyToKml({
    required String name,
    required double latitude,
    required double longitude,
    double altitudeRange = 50000,
    double tilt = 45,
    double heading = 0,
  }) async {
    final kmlContent = generateFlyToKml(
      latitude: latitude,
      longitude: longitude,
      name: name,
      altitudeRange: altitudeRange,
      tilt: tilt,
      heading: heading,
    );

    final safeName = name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_');

    final filename = 'flyto_$safeName';
    final bytes = Uint8List.fromList(utf8.encode(kmlContent));

    await FileSaver.instance.saveFile(
      name: filename,
      bytes: bytes,
      ext: 'kml',
      mimeType: MimeType.other,
    );
  }

  /// Generate a unique semi-transparent KML color code from a string.
  static String _stringToKmlColor(String str) {
    int hash = 0;
    for (int i = 0; i < str.length; i++) {
      hash = str.codeUnitAt(i) + ((hash << 5) - hash);
    }
    final r = (hash & 0xFF0000) >> 16;
    final g = (hash & 0x00FF00) >> 8;
    final b = (hash & 0x0000FF);
    final rHex = r.toRadixString(16).padLeft(2, '0');
    final gHex = g.toRadixString(16).padLeft(2, '0');
    final bHex = b.toRadixString(16).padLeft(2, '0');
    return '50$bHex$gHex$rHex'; // ~30% opacity unique color
  }

  /// Generates a list of coordinates forming a circle around the center point.
  static List<String> _generateCircleCoordinates(
      double lat, double lng, double radius) {
    final coords = <String>[];
    const segments = 36;
    const earthRadius = 6378137.0;

    final latRad = lat * pi / 180;
    final lngRad = lng * pi / 180;
    final distanceRad = radius / earthRadius;

    for (int i = 0; i <= segments; i++) {
      final bearingRad = (i * 360 / segments) * pi / 180;

      final destLatRad = asin(sin(latRad) * cos(distanceRad) +
          cos(latRad) * sin(distanceRad) * cos(bearingRad));
      final destLngRad = lngRad +
          atan2(sin(bearingRad) * sin(distanceRad) * cos(latRad),
              cos(distanceRad) - sin(latRad) * sin(destLatRad));

      final destLat = destLatRad * 180 / pi;
      final destLng = destLngRad * 180 / pi;
      coords.add(
          '${destLng.toStringAsFixed(6)},${destLat.toStringAsFixed(6)},0');
    }
    return coords;
  }
}

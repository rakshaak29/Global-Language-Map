import 'dart:convert';
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

  /// Generates a reusable FlyTo KML snippet containing a `<LookAt>` element.
  ///
  /// [altitudeRange] acts as the range/altitude from the target point in meters (default 50,000m ≈ 50km).
  /// [tilt] is the angle from nadir in degrees (0 = straight down, 90 = horizon, default 45°).
  /// [heading] is the compass direction in degrees (0 = north, default 0°).
  static String generateFlyToKml({
    required double latitude,
    required double longitude,
    double altitudeRange = 50000,
    double tilt = 45,
    double heading = 0,
  }) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element('kml',
        namespaces: {_kmlNamespace: ''},
        namespace: _kmlNamespace, nest: () {
      builder.element('LookAt', nest: () {
        builder.element('longitude', nest: longitude.toStringAsFixed(6));
        builder.element('latitude', nest: latitude.toStringAsFixed(6));
        builder.element('altitude', nest: '0');
        builder.element('range', nest: altitudeRange.toStringAsFixed(0));
        builder.element('tilt', nest: tilt.toStringAsFixed(0));
        builder.element('heading', nest: heading.toStringAsFixed(0));
        builder.element('altitudeMode', nest: 'relativeToGround');
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
}

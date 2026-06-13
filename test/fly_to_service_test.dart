import 'package:flutter_test/flutter_test.dart';
import 'package:global_language_distribution_map/data/services/fly_to_service.dart';
import 'package:xml/xml.dart';

void main() {
  group('FlyToService', () {
    test('generateFlyToKml produces valid XML with LookAt', () {
      final kml = FlyToService.generateFlyToKml(
        latitude: 35.6762,
        longitude: 139.6503,
        altitudeRange: 40000,
        tilt: 30,
        heading: 90,
      );

      // Verify KML structure
      final doc = XmlDocument.parse(kml);
      expect(doc, isNotNull);

      final kmlElement = doc.rootElement;
      expect(kmlElement.name.local, equals('kml'));

      final lookAt = kmlElement.findElements('LookAt').first;
      expect(
        lookAt.findElements('latitude').first.innerText,
        equals('35.676200'),
      );
      expect(
        lookAt.findElements('longitude').first.innerText,
        equals('139.650300'),
      );
      expect(
        lookAt.findElements('range').first.innerText,
        equals('40000'),
      );
      expect(
        lookAt.findElements('tilt').first.innerText,
        equals('30'),
      );
      expect(
        lookAt.findElements('heading').first.innerText,
        equals('90'),
      );
      expect(
        lookAt.findElements('altitudeMode').first.innerText,
        equals('relativeToGround'),
      );
    });

    test('generateFlyToKml uses default values correctly', () {
      final kml = FlyToService.generateFlyToKml(
        latitude: -1.0,
        longitude: 52.0,
      );

      final doc = XmlDocument.parse(kml);
      final lookAt = doc.rootElement.findElements('LookAt').first;

      expect(
        lookAt.findElements('range').first.innerText,
        equals('50000'), // Default range
      );
      expect(
        lookAt.findElements('tilt').first.innerText,
        equals('45'), // Default tilt
      );
      expect(
        lookAt.findElements('heading').first.innerText,
        equals('0'), // Default heading
      );
    });
  });
}

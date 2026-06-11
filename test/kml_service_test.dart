import 'package:flutter_test/flutter_test.dart';
import 'package:global_language_distribution_map/data/models/language.dart';
import 'package:global_language_distribution_map/data/services/kml_service.dart';
import 'package:xml/xml.dart';

void main() {
  group('KmlService', () {
    final sampleLanguages = [
      const Language(
        id: 'engl1234',
        name: 'English',
        languageFamily: 'Indo-European',
        countryRegion: 'United Kingdom',
        latitude: 52.0,
        longitude: -1.0,
        endangeredStatus: 'not endangered',
        description: 'A West Germanic language.',
      ),
      const Language(
        id: 'ainu1240',
        name: 'Ainu',
        languageFamily: 'Ainu',
        countryRegion: 'Japan',
        latitude: 42.5,
        longitude: 141.35,
        endangeredStatus: 'nearly extinct',
        description: 'Indigenous language of the Ainu people.',
      ),
      const Language(
        id: 'tasm1234',
        name: 'Tasmanian',
        languageFamily: 'Tasmanian',
        countryRegion: 'Australia',
        latitude: -42.0,
        longitude: 146.0,
        endangeredStatus: 'extinct',
        description: '',
      ),
      const Language(
        id: 'nocoords',
        name: 'No Coordinates Language',
        languageFamily: 'Unknown',
        countryRegion: 'Unknown',
        latitude: 0.0,
        longitude: 0.0,
        endangeredStatus: 'not endangered',
        description: '',
      ),
    ];

    test('generateKml produces valid XML', () {
      final kml = KmlService.generateKml(sampleLanguages);

      // Should not throw when parsing
      final doc = XmlDocument.parse(kml);
      expect(doc, isNotNull);

      // Should have the KML root element
      final kmlElement = doc.rootElement;
      expect(kmlElement.name.local, equals('kml'));
    });

    test('generateKml includes Document with name and description', () {
      final kml = KmlService.generateKml(
        sampleLanguages,
        title: 'Test Document',
      );
      final doc = XmlDocument.parse(kml);
      final document = doc.rootElement.findElements('Document').first;

      expect(
        document.findElements('name').first.innerText,
        equals('Test Document'),
      );
      expect(
        document.findElements('description').first.innerText,
        isNotEmpty,
      );
    });

    test('generateKml creates styles for all endangerment levels', () {
      final kml = KmlService.generateKml(sampleLanguages);
      final doc = XmlDocument.parse(kml);
      final document = doc.rootElement.findElements('Document').first;
      final styles = document.findElements('Style');

      // Should have 6 styles (one per endangerment level)
      expect(styles.length, equals(6));

      // Verify style IDs
      final styleIds = styles.map((s) => s.getAttribute('id')).toSet();
      expect(styleIds, contains('style-not-endangered'));
      expect(styleIds, contains('style-threatened'));
      expect(styleIds, contains('style-shifting'));
      expect(styleIds, contains('style-moribund'));
      expect(styleIds, contains('style-nearly-extinct'));
      expect(styleIds, contains('style-extinct'));
    });

    test('generateKml organizes placemarks into folders by status', () {
      final kml = KmlService.generateKml(sampleLanguages);
      final doc = XmlDocument.parse(kml);
      final document = doc.rootElement.findElements('Document').first;
      final folders = document.findElements('Folder');

      // Should have folders for the 3 distinct statuses in sample data
      // (not endangered, nearly extinct, extinct)
      expect(folders.length, equals(3));

      // Check folder names include counts
      final folderNames =
          folders.map((f) => f.findElements('name').first.innerText).toList();
      expect(folderNames.any((name) => name.contains('Safe')), isTrue);
      expect(
          folderNames.any((name) => name.contains('Nearly Extinct')), isTrue);
      expect(folderNames.any((name) => name.contains('Extinct')), isTrue);
    });

    test('generateKml filters out languages without coordinates', () {
      final kml = KmlService.generateKml(sampleLanguages);
      final doc = XmlDocument.parse(kml);
      final document = doc.rootElement.findElements('Document').first;

      // Count all placemarks across all folders
      int placemarkCount = 0;
      for (final folder in document.findElements('Folder')) {
        placemarkCount += folder.findElements('Placemark').length;
      }

      // Should have 3 placemarks (4 languages - 1 without coords)
      expect(placemarkCount, equals(3));
    });

    test('generatePlacemark includes correct coordinates', () {
      final kml = KmlService.generateKml([sampleLanguages[0]]);
      final doc = XmlDocument.parse(kml);

      // Find the placemark
      final folder = doc.rootElement
          .findElements('Document')
          .first
          .findElements('Folder')
          .first;
      final placemark = folder.findElements('Placemark').first;
      final coords = placemark
          .findElements('Point')
          .first
          .findElements('coordinates')
          .first
          .innerText;

      // KML format is longitude,latitude,altitude
      expect(coords, equals('-1.0,52.0,0'));
    });

    test('generatePlacemark includes description with metadata', () {
      final kml = KmlService.generateKml([sampleLanguages[0]]);
      final doc = XmlDocument.parse(kml);

      final folder = doc.rootElement
          .findElements('Document')
          .first
          .findElements('Folder')
          .first;
      final placemark = folder.findElements('Placemark').first;
      final description =
          placemark.findElements('description').first.innerText;

      expect(description, contains('Indo-European'));
      expect(description, contains('United Kingdom'));
      expect(description, contains('Safe'));
    });

    test('generatePlacemark includes LookAt element', () {
      final kml = KmlService.generateKml([sampleLanguages[0]]);
      final doc = XmlDocument.parse(kml);

      final folder = doc.rootElement
          .findElements('Document')
          .first
          .findElements('Folder')
          .first;
      final placemark = folder.findElements('Placemark').first;
      final lookAt = placemark.findElements('LookAt');

      expect(lookAt.length, equals(1));
      expect(
        lookAt.first.findElements('latitude').first.innerText,
        equals('52.000000'),
      );
      expect(
        lookAt.first.findElements('longitude').first.innerText,
        equals('-1.000000'),
      );
    });

    test('generatePlacemark includes styleUrl', () {
      final kml = KmlService.generateKml([sampleLanguages[0]]);
      final doc = XmlDocument.parse(kml);

      final folder = doc.rootElement
          .findElements('Document')
          .first
          .findElements('Folder')
          .first;
      final placemark = folder.findElements('Placemark').first;
      final styleUrl = placemark.findElements('styleUrl').first.innerText;

      expect(styleUrl, equals('#style-not-endangered'));
    });

    test('generateSingleLanguageKml creates valid KML for one language', () {
      final kml = KmlService.generateSingleLanguageKml(sampleLanguages[0]);
      final doc = XmlDocument.parse(kml);

      final document = doc.rootElement.findElements('Document').first;
      expect(
        document.findElements('name').first.innerText,
        equals('English'),
      );

      final placemarks = document.findElements('Placemark');
      expect(placemarks.length, equals(1));
    });

    test('generateLookAtKml creates valid LookAt element', () {
      final kml = KmlService.generateLookAtKml(
        latitude: 52.0,
        longitude: -1.0,
        range: 100000,
        tilt: 60,
        heading: 45,
      );
      final doc = XmlDocument.parse(kml);
      final lookAt = doc.rootElement.findElements('LookAt').first;

      expect(
        lookAt.findElements('latitude').first.innerText,
        equals('52.000000'),
      );
      expect(
        lookAt.findElements('longitude').first.innerText,
        equals('-1.000000'),
      );
      expect(
        lookAt.findElements('range').first.innerText,
        equals('100000'),
      );
      expect(
        lookAt.findElements('tilt').first.innerText,
        equals('60'),
      );
      expect(
        lookAt.findElements('heading').first.innerText,
        equals('45'),
      );
    });

    test('generateKml handles empty language list', () {
      final kml = KmlService.generateKml([]);
      final doc = XmlDocument.parse(kml);

      final document = doc.rootElement.findElements('Document').first;
      final folders = document.findElements('Folder');

      expect(folders.length, equals(0));
    });
  });
}

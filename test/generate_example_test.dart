import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_language_distribution_map/data/models/language.dart';
import 'package:global_language_distribution_map/data/services/kml_service.dart';

void main() {
  test('Generate medium KML', () {
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
        id: 'haw1245',
        name: 'Hawaiian',
        languageFamily: 'Austronesian',
        countryRegion: 'United States',
        latitude: 19.8968,
        longitude: -155.5828,
        endangeredStatus: 'threatened',
        description: 'Polynesian language of the Hawaiian Islands.',
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
        description: 'Extinct languages of Tasmania.',
      ),
      const Language(
        id: 'sibe1234',
        name: 'Siberian Yupik',
        languageFamily: 'Eskimo-Aleut',
        countryRegion: 'Russia',
        latitude: 64.5,
        longitude: -171.0,
        endangeredStatus: 'shifting',
        description: 'Spoken in Siberia and St. Lawrence Island.',
      ),
      const Language(
        id: 'choc1234',
        name: 'Choctaw',
        languageFamily: 'Muskogean',
        countryRegion: 'United States',
        latitude: 34.0,
        longitude: -89.0,
        endangeredStatus: 'moribund',
        description: 'Native American language of the Choctaw Nation.',
      ),
    ];

    final kml = KmlService.generateKml(
      sampleLanguages,
      title: 'Medium Sample - Global Languages',
      description: 'A medium-sized sample showcasing 6 languages across all endangerment statuses. Includes lookat camera paths, styling, and 40km circular region overlays.',
    );

    final file = File('medium_example.kml');
    file.writeAsStringSync(kml);
    print('Successfully generated medium_example.kml');
  });
}

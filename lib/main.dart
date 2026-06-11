import 'package:flutter/material.dart';
import 'package:global_language_distribution_map/app/app.dart';
import 'package:global_language_distribution_map/data/repositories/language_repository.dart';
import 'package:global_language_distribution_map/features/home/presentation/view_models/home_view_model.dart';
import 'package:global_language_distribution_map/features/kml_export/presentation/view_models/kml_export_view_model.dart';
import 'package:global_language_distribution_map/features/map/presentation/view_models/map_view_model.dart';
import 'package:global_language_distribution_map/features/settings/presentation/view_models/settings_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final languageRepository = LanguageRepository();

  runApp(
    MultiProvider(
      providers: [
        Provider<LanguageRepository>.value(
          value: languageRepository,
        ),
        ChangeNotifierProvider<SettingsViewModel>(
          create: (_) => SettingsViewModel(),
        ),
        ChangeNotifierProxyProvider<LanguageRepository, HomeViewModel>(
          create: (context) => HomeViewModel(
            repository: context.read<LanguageRepository>(),
          ),
          update: (context, repository, previous) =>
              previous ?? HomeViewModel(repository: repository),
        ),
        ChangeNotifierProxyProvider<LanguageRepository, MapViewModel>(
          create: (context) => MapViewModel(
            repository: context.read<LanguageRepository>(),
          ),
          update: (context, repository, previous) =>
              previous ?? MapViewModel(repository: repository),
        ),
        ChangeNotifierProxyProvider<LanguageRepository, KmlExportViewModel>(
          create: (context) => KmlExportViewModel(
            repository: context.read<LanguageRepository>(),
          ),
          update: (context, repository, previous) =>
              previous ?? KmlExportViewModel(repository: repository),
        ),
      ],
      child: const App(),
    ),
  );
}

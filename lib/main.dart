import 'package:flutter/material.dart';
import 'package:global_language_distribution_map/app/app.dart';
import 'package:global_language_distribution_map/data/repositories/language_repository.dart';
import 'package:global_language_distribution_map/features/endangered/presentation/view_models/endangered_view_model.dart';
import 'package:global_language_distribution_map/features/families/presentation/view_models/families_view_model.dart';
import 'package:global_language_distribution_map/features/home/presentation/view_models/home_view_model.dart';
import 'package:global_language_distribution_map/features/kml_export/presentation/view_models/kml_export_view_model.dart';
import 'package:global_language_distribution_map/features/map/presentation/view_models/map_view_model.dart';
import 'package:global_language_distribution_map/features/settings/presentation/view_models/settings_view_model.dart';
import 'package:global_language_distribution_map/features/tours/presentation/view_models/tours_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final languageRepository = LanguageRepository();

  // Load data eagerly so it's available regardless of which route
  // the browser lands on (e.g., after a page refresh on /home or /map).
  await languageRepository.loadData();

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
        ChangeNotifierProxyProvider<LanguageRepository, FamiliesViewModel>(
          create: (context) => FamiliesViewModel(
            repository: context.read<LanguageRepository>(),
          ),
          update: (context, repository, previous) =>
              previous ?? FamiliesViewModel(repository: repository),
        ),
        ChangeNotifierProxyProvider<LanguageRepository, ToursViewModel>(
          create: (context) => ToursViewModel(
            repository: context.read<LanguageRepository>(),
          ),
          update: (context, repository, previous) =>
              previous ?? ToursViewModel(repository: repository),
        ),
        ChangeNotifierProxyProvider<LanguageRepository, EndangeredViewModel>(
          create: (context) => EndangeredViewModel(
            repository: context.read<LanguageRepository>(),
          ),
          update: (context, repository, previous) =>
              previous ?? EndangeredViewModel(repository: repository),
        ),
      ],
      child: const App(),
    ),
  );
}

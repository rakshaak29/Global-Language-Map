import 'package:flutter/material.dart';
import 'package:global_language_distribution_map/app/router.dart';
import 'package:global_language_distribution_map/core/constants/app_constants.dart';
import 'package:global_language_distribution_map/features/settings/presentation/view_models/settings_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// The Settings Screen of the application.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final viewModel = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Section: General
          _buildSectionHeader(context, 'General'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      viewModel.isDarkMode
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    'Dark Mode',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Toggle dark or light user interface theme',
                    style: GoogleFonts.inter(fontSize: 12),
                  ),
                  value: viewModel.isDarkMode,
                  onChanged: (value) {
                    viewModel.toggleTheme();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Section: Liquid Galaxy
          _buildSectionHeader(context, 'Liquid Galaxy'),
          Card(
            child: Column(
              children: [
                ListTile(
                  onTap: () => context.push(RoutePaths.kmlExport),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.public_rounded,
                      color: colorScheme.secondary,
                    ),
                  ),
                  title: Text(
                    'Export KML',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Generate KML files for Google Earth',
                    style: GoogleFonts.inter(fontSize: 12),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Section: Data Sources
          _buildSectionHeader(context, 'Data Sources'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.source_rounded,
                          color: colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Data Processing & Aggregation',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'This application relies on offline, normalized datasets merged from primary academic and humanitarian directories:',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDataAttributionTile(
                    context,
                    title: 'Glottolog (v5.3)',
                    subtitle: AppConstants.glottologAttribution,
                  ),
                  const Divider(height: 24),
                  _buildDataAttributionTile(
                    context,
                    title: 'UNESCO Endangered Languages',
                    subtitle: AppConstants.unescoAttribution,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Section: About
          _buildSectionHeader(context, 'About App'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  title: Text(
                    'Version',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Text(
                    AppConstants.appVersion,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDataAttributionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

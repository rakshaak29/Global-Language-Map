import 'package:flutter/material.dart';
import 'package:global_language_distribution_map/app/theme.dart';
import 'package:global_language_distribution_map/presentation/settings/view_models/settings_view_model.dart';
import 'package:global_language_distribution_map/presentation/settings/widgets/settings_section_title.dart';
import 'package:google_fonts/google_fonts.dart';

/// Card showing display-related toggles and marker size slider.
class DisplaySettingsCard extends StatelessWidget {
  final SettingsViewModel viewModel;

  const DisplaySettingsCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionTitle(title: 'Display Settings'),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          color: colorScheme.surfaceContainerLow,
          child: Column(
            children: [
              SwitchListTile(
                value: viewModel.darkMapTheme,
                onChanged: (_) => viewModel.toggleDarkMapTheme(),
                title: Text(
                  'Dark Map Theme',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Apply dark mode tiles to map screens',
                  style: GoogleFonts.inter(fontSize: 12),
                ),
                activeThumbColor: AppTheme.primaryGreen,
              ),
              const Divider(height: 1),
              SwitchListTile(
                value: viewModel.showLanguageMarkers,
                onChanged: (_) => viewModel.toggleShowLanguageMarkers(),
                title: Text(
                  'Show Language Markers',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Toggle clustering dots on the map',
                  style: GoogleFonts.inter(fontSize: 12),
                ),
                activeThumbColor: AppTheme.primaryGreen,
              ),
              const Divider(height: 1),
              SwitchListTile(
                value: viewModel.autoFlyOnSelect,
                onChanged: (_) => viewModel.toggleAutoFlyOnSelect(),
                title: Text(
                  'Auto-Fly on Select',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Automatically fly LG to language coordinates',
                  style: GoogleFonts.inter(fontSize: 12),
                ),
                activeThumbColor: AppTheme.primaryGreen,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ─── Marker Size ───────────────────────────────────
        const SettingsSectionTitle(title: 'Marker Size'),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          color: colorScheme.surfaceContainerLow,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adjust the size of language markers on the map.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Scale Multiplier',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Text(
                      '${viewModel.markerSize.toStringAsFixed(1)}x',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
                Slider.adaptive(
                  value: viewModel.markerSize,
                  min: 0.5,
                  max: 2.5,
                  divisions: 20,
                  activeColor: AppTheme.primaryGreen,
                  onChanged: viewModel.setMarkerSize,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

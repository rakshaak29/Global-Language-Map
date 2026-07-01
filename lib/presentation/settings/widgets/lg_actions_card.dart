import 'package:flutter/material.dart';
import 'package:global_language_distribution_map/app/theme.dart';
import 'package:global_language_distribution_map/presentation/settings/view_models/settings_view_model.dart';
import 'package:global_language_distribution_map/presentation/settings/widgets/settings_section_title.dart';
import 'package:google_fonts/google_fonts.dart';

/// Card showing Liquid Galaxy action buttons (Clear KML, Send Demo, Relaunch GE, Reboot).
class LgActionsCard extends StatelessWidget {
  final SettingsViewModel viewModel;

  const LgActionsCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionTitle(title: 'Liquid Galaxy Actions'),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          color: colorScheme.surfaceContainerLow,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final success = await viewModel.clearKml();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? 'KML cleared on Liquid Galaxy'
                                      : 'Failed to clear KML',
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.clear_all_rounded, size: 18),
                        label: Text(
                          'Clear KML',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final success = await viewModel.sendKml('');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? 'KML sent to Liquid Galaxy'
                                      : 'Failed to send KML',
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.send_rounded, size: 18),
                        label: Text(
                          'Send Demo KML',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final success = await viewModel.relaunchGoogleEarth();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? 'Relaunching Google Earth...'
                                      : 'Failed to relaunch Google Earth',
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.restart_alt_rounded, size: 18),
                        label: Text(
                          'Relaunch GE',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Reboot Liquid Galaxy?'),
                              content: const Text('Are you sure you want to reboot all LG screens?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Reboot', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            final success = await viewModel.reboot();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? 'Rebooting Liquid Galaxy...'
                                        : 'Failed to send reboot command',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.power_settings_new_rounded, size: 18),
                        label: Text(
                          'Reboot LG',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

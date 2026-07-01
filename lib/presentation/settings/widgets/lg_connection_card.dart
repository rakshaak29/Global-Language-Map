import 'package:flutter/material.dart';
import 'package:global_language_distribution_map/app/theme.dart';
import 'package:global_language_distribution_map/data/services/liquid_galaxy_service.dart';
import 'package:global_language_distribution_map/presentation/settings/view_models/settings_view_model.dart';
import 'package:global_language_distribution_map/presentation/settings/widgets/settings_section_title.dart';
import 'package:google_fonts/google_fonts.dart';

/// Card showing connection form and status for Liquid Galaxy.
class LgConnectionCard extends StatelessWidget {
  final SettingsViewModel viewModel;
  final TextEditingController hostController;
  final TextEditingController portController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const LgConnectionCard({
    super.key,
    required this.viewModel,
    required this.hostController,
    required this.portController,
    required this.usernameController,
    required this.passwordController,
  });

  Color _getStatusColor(LgConnectionStatus status) {
    switch (status) {
      case LgConnectionStatus.connected:
        return AppTheme.primaryGreen;
      case LgConnectionStatus.connecting:
        return Colors.orange;
      case LgConnectionStatus.error:
        return Colors.red;
      case LgConnectionStatus.disconnected:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionTitle(title: 'Liquid Galaxy Connection'),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Row
                Row(
                  children: [
                    Text(
                      'LG Connection Status',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(viewModel.connectionStatus).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getStatusColor(viewModel.connectionStatus).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        viewModel.connectionStatusText.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: _getStatusColor(viewModel.connectionStatus),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // IP Address Field
                TextField(
                  controller: hostController,
                  onChanged: viewModel.setHost,
                  style: GoogleFonts.inter(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'IP/Host Address',
                    labelStyle: GoogleFonts.inter(fontSize: 13),
                    hintText: 'e.g. 192.168.1.100',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.computer_rounded, size: 20),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 12),

                // Port Field
                TextField(
                  controller: portController,
                  onChanged: viewModel.setPort,
                  style: GoogleFonts.inter(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'SSH Port',
                    labelStyle: GoogleFonts.inter(fontSize: 13),
                    hintText: 'e.g. 22',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.input_rounded, size: 20),
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),

                // Username Field
                TextField(
                  controller: usernameController,
                  onChanged: viewModel.setUsername,
                  style: GoogleFonts.inter(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'SSH Username',
                    labelStyle: GoogleFonts.inter(fontSize: 13),
                    hintText: 'e.g. lg',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person_rounded, size: 20),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 12),

                // Password Field
                TextField(
                  controller: passwordController,
                  onChanged: viewModel.setPassword,
                  obscureText: true,
                  style: GoogleFonts.inter(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'SSH Password',
                    labelStyle: GoogleFonts.inter(fontSize: 13),
                    hintText: 'Required',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock_rounded, size: 20),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 16),

                // Connection Buttons Row
                Row(
                  children: [
                    if (viewModel.isConnected)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: viewModel.disconnect,
                          icon: const Icon(Icons.power_off_rounded, size: 18),
                          label: Text(
                            'Disconnect',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: viewModel.isConnecting
                              ? null
                              : () => viewModel.testConnection(),
                          icon: viewModel.isConnecting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.network_check_rounded, size: 18),
                          label: Text(
                            viewModel.isConnecting ? 'Connecting...' : 'Connect to LG',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                  ],
                ),

                if (viewModel.connectionError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    viewModel.connectionError!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

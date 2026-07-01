import 'package:flutter/material.dart';
import 'package:global_language_distribution_map/app/router.dart';
import 'package:global_language_distribution_map/core/widgets/curved_header.dart';
import 'package:global_language_distribution_map/presentation/settings/view_models/settings_view_model.dart';
import 'package:global_language_distribution_map/presentation/settings/widgets/lg_connection_card.dart';
import 'package:global_language_distribution_map/presentation/settings/widgets/lg_actions_card.dart';
import 'package:global_language_distribution_map/presentation/settings/widgets/display_settings_card.dart';
import 'package:global_language_distribution_map/presentation/settings/widgets/settings_section_title.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// Redesigned Settings Screen.
///
/// Features a dark-green curved header, Liquid Galaxy connection config
/// with status badge, display switches, marker size slider, and an "About" link.
/// Sub-widgets are extracted into separate files under `widgets/`.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _hostController;
  late final TextEditingController _portController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _geminiApiKeyController;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<SettingsViewModel>();
    _hostController = TextEditingController(text: viewModel.host);
    _portController = TextEditingController(text: viewModel.port);
    _usernameController = TextEditingController(text: viewModel.username);
    _passwordController = TextEditingController(text: viewModel.password);
    _geminiApiKeyController = TextEditingController(text: viewModel.geminiApiKey);
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _geminiApiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final viewModel = context.watch<SettingsViewModel>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Curved Header
            CurvedHeader(
              overline: 'System Configuration',
              title: 'Settings',
              height: 140,
              actions: [
                HeaderIconButton(
                  icon: viewModel.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  onPressed: () => viewModel.toggleTheme(),
                  tooltip: 'Toggle Theme',
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Liquid Galaxy Connection ────────────────────────
                  LgConnectionCard(
                    viewModel: viewModel,
                    hostController: _hostController,
                    portController: _portController,
                    usernameController: _usernameController,
                    passwordController: _passwordController,
                  ),
                  const SizedBox(height: 16),

                  // ─── Liquid Galaxy Actions ───────────────────────────
                  if (viewModel.isConnected) ...[
                    LgActionsCard(viewModel: viewModel),
                    const SizedBox(height: 16),
                  ],

                  // ─── Display Settings ────────────────────────────────
                  DisplaySettingsCard(viewModel: viewModel),
                  const SizedBox(height: 16),

                  // ─── Gemini AI Assistant ────────────────────────────
                  const SettingsSectionTitle(title: 'Gemini AI Assistant'),
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
                          Text(
                            'Enter your Gemini API Key to enable the AI assistant chat.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _geminiApiKeyController,
                            onChanged: viewModel.setGeminiApiKey,
                            obscureText: true,
                            style: GoogleFonts.inter(fontSize: 14),
                            decoration: InputDecoration(
                              labelText: 'Gemini API Key',
                              labelStyle: GoogleFonts.inter(fontSize: 13),
                              hintText: 'AIzaSy...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.vpn_key_rounded, size: 20),
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // About Section Link
                  InkWell(
                    onTap: () => context.push(RoutePaths.about),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: colorScheme.primary),
                          const SizedBox(width: 12),
                          Text(
                            'About App',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.arrow_forward_ios_rounded, size: 16, color: colorScheme.onSurfaceVariant),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

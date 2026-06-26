import 'package:flutter/material.dart';
import 'package:global_language_distribution_map/app/router.dart';
import 'package:global_language_distribution_map/app/theme.dart';
import 'package:global_language_distribution_map/core/constants/app_constants.dart';
import 'package:global_language_distribution_map/data/models/language.dart';
import 'package:global_language_distribution_map/data/services/tts_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

/// Redesigned full-width bottom sheet that displays language details.
///
/// Includes:
/// - Header: Name, Family, TTS & Close buttons
/// - 2x2 grid of info cards: Speakers, Script, Region, Status
/// - Country chips list
/// - "View Details" (outlined) and "Fly to Location" (filled green) action buttons
class LanguageDetailSheet extends StatefulWidget {
  final Language language;
  final VoidCallback? onClose;
  final VoidCallback? onFlyTo;

  const LanguageDetailSheet({
    super.key,
    required this.language,
    this.onClose,
    this.onFlyTo,
  });

  @override
  State<LanguageDetailSheet> createState() => _LanguageDetailSheetState();
}

class _LanguageDetailSheetState extends State<LanguageDetailSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  final TtsService _tts = TtsService();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // Slide up from bottom
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  Future<void> _speakLanguageInfo() async {
    final text = TtsService.buildLanguageDescription(
      name: widget.language.name,
      family: widget.language.languageFamily,
      endangeredStatus: widget.language.endangeredStatus,
      countryRegion: widget.language.countryRegion,
      latitude: widget.language.latitude,
      longitude: widget.language.longitude,
    );

    try {
      setState(() => _isSpeaking = true);
      await _tts.speak(text);

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _isSpeaking = _tts.isSpeaking);
        }
      });
    } catch (_) {
      if (mounted) setState(() => _isSpeaking = false);
    }
  }

  Future<void> _toggleSpeech() async {
    if (_isSpeaking) {
      await _tts.stop();
      if (mounted) setState(() => _isSpeaking = false);
    } else {
      await _speakLanguageInfo();
    }
  }

  @override
  void dispose() {
    _tts.stop();
    _animController.dispose();
    super.dispose();
  }

  static String _parseSpeakers(String description) {
    final match =
        RegExp(r'speakers:\s*([\d.]+)', caseSensitive: false).firstMatch(description);
    if (match != null) {
      final count = double.tryParse(match.group(1) ?? '0') ?? 0;
      if (count == 0) return '0';
      if (count >= 1e9) return '${(count / 1e9).toStringAsFixed(1)}B';
      if (count >= 1e6) return '${(count / 1e6).toStringAsFixed(1)}M';
      if (count >= 1000) return '${(count / 1000).toStringAsFixed(0)}K';
      return count.toInt().toString();
    }
    return 'Unknown';
  }

  static String _detectScript(String name) {
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(name)) return 'Arabic';
    if (RegExp(r'[\u4E00-\u9FFF]').hasMatch(name)) return 'Han';
    if (RegExp(r'[\u0900-\u097F]').hasMatch(name)) return 'Devanagari';
    if (RegExp(r'[\u0400-\u04FF]').hasMatch(name)) return 'Cyrillic';
    return 'Latin';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final endangermentColor =
        AppTheme.getEndangermentColor(widget.language.endangeredStatus);

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer.withValues(alpha: 0.98),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pull/Drag Handle for visual polish
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.language.name,
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.language.languageFamily} Family',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // TTS Button
                      IconButton(
                        onPressed: _toggleSpeech,
                        icon: Icon(
                          _isSpeaking
                              ? Icons.volume_off_rounded
                              : Icons.volume_up_rounded,
                        ),
                        color: _isSpeaking ? colorScheme.primary : colorScheme.onSurfaceVariant,
                        style: IconButton.styleFrom(
                          backgroundColor: _isSpeaking
                              ? colorScheme.primary.withValues(alpha: 0.1)
                              : colorScheme.surfaceContainerHigh,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Close Button
                      IconButton(
                        onPressed: () {
                          _tts.stop();
                          widget.onClose?.call();
                        },
                        icon: const Icon(Icons.close_rounded),
                        color: colorScheme.onSurfaceVariant,
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.surfaceContainerHigh,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 2x2 Info Grid
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    childAspectRatio: 2.2,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _InfoCard(
                        label: 'Speakers',
                        value: _parseSpeakers(widget.language.description),
                        icon: Icons.people_rounded,
                        iconColor: AppTheme.primaryGreen,
                      ),
                      _InfoCard(
                        label: 'Script',
                        value: _detectScript(widget.language.name),
                        icon: Icons.text_fields_rounded,
                        iconColor: const Color(0xFF6A1B9A),
                      ),
                      _InfoCard(
                        label: 'Region',
                        value: widget.language.countryRegion.length > 15
                            ? '${widget.language.countryRegion.substring(0, 12)}...'
                            : widget.language.countryRegion,
                        icon: Icons.location_on_rounded,
                        iconColor: const Color(0xFF00838F),
                      ),
                      _InfoCard(
                        label: 'Status',
                        value: AppConstants.endangermentLabels[widget.language.endangeredStatus] ??
                            widget.language.endangeredStatus,
                        icon: Icons.warning_amber_rounded,
                        iconColor: endangermentColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Country Chips
                  Text(
                    'Countries / Regions',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.language.countryRegion
                        .split(' ')
                        .where((code) => code.trim().isNotEmpty)
                        .map((code) => _CountryChip(code: code))
                        .toList(),
                  ),

                  const SizedBox(height: 20),

                  // Action Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.push(RoutePaths.languageDetail, extra: widget.language);
                          },
                          icon: const Icon(Icons.info_outline_rounded, size: 18),
                          label: Text(
                            'View Details',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: colorScheme.outlineVariant),
                            foregroundColor: colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: widget.onFlyTo,
                          icon: const Icon(Icons.flight_takeoff_rounded, size: 18),
                          label: Text(
                            'Fly to Location',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CountryChip extends StatelessWidget {
  final String code;

  const _CountryChip({required this.code});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.8)),
      ),
      child: Text(
        code.trim(),
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}

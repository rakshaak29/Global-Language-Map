import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application theme configuration.
///
/// Provides dark and light themes with a consistent dark-green design system
/// matching the Language Map UI/UX design.
class AppTheme {
  AppTheme._();

  // ─── Brand Colors ──────────────────────────────────────────────────────────

  // Primary dark forest green (matching screenshots)
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color primaryGreenDark = Color(0xFF1B5E20);
  static const Color primaryGreenLight = Color(0xFF388E3C);
  static const Color accentGreen = Color(0xFF43A047);

  static const Color _primaryLight = Color(0xFF2E7D32);
  static const Color _primaryDark = Color(0xFF4CAF50);

  static const Color _secondaryLight = Color(0xFFFF6F00);
  static const Color _secondaryDark = Color(0xFFFFB300);

  // Light theme surfaces — clean off-white
  static const Color _surfaceLight = Color(0xFFF4F6F4);
  static const Color _surfaceContainerLight = Color(0xFFFFFFFF);
  static const Color _onSurfaceLight = Color(0xFF1A2118);
  static const Color _onSurfaceVariantLight = Color(0xFF52634F);

  // Dark theme surfaces
  static const Color _surfaceDark = Color(0xFF111411);
  static const Color _surfaceContainerDark = Color(0xFF1C201B);
  static const Color _surfaceContainerHighDark = Color(0xFF252A24);
  static const Color _onSurfaceDark = Color(0xFFE2E8E1);
  static const Color _onSurfaceVariantDark = Color(0xFF9EAA9B);

  // ─── Endangerment Colors ───────────────────────────────────────────────────

  static const Map<String, Color> endangermentColors = {
    'not endangered': Color(0xFF2E7D32),
    'threatened': Color(0xFFF9A825),
    'shifting': Color(0xFFE65100),
    'moribund': Color(0xFFB71C1C),
    'nearly extinct': Color(0xFF880E4F),
    'extinct': Color(0xFF757575),
  };

  static Color getEndangermentColor(String status) {
    return endangermentColors[status] ?? const Color(0xFF757575);
  }

  // Endangered status badge colors (for the Endangered screen)
  static const Map<String, Color> endangeredBadgeColors = {
    'Vulnerable': Color(0xFFF9A825),
    'Definitely': Color(0xFFE65100),
    'Severely': Color(0xFFD32F2F),
    'Critically': Color(0xFFB71C1C),
    'Extinct': Color(0xFF757575),
  };

  // ─── Family Card Colors ────────────────────────────────────────────────────

  static const List<List<Color>> familyCardGradients = [
    [Color(0xFF2E7D32), Color(0xFF43A047)],   // Green - Indo-European
    [Color(0xFFE65100), Color(0xFFFF8F00)],   // Orange - Sino-Tibetan
    [Color(0xFFF9A825), Color(0xFFFDD835)],   // Yellow - Afro-Asiatic
    [Color(0xFFC62828), Color(0xFFEF5350)],   // Red - Niger-Congo
    [Color(0xFF00838F), Color(0xFF26C6DA)],   // Teal - Austronesian
    [Color(0xFF6A1B9A), Color(0xFFAB47BC)],   // Purple - Dravidian
    [Color(0xFFAD1457), Color(0xFFEC407A)],   // Pink - Turkic
    [Color(0xFF1565C0), Color(0xFF42A5F5)],   // Blue - Japonic
    [Color(0xFF37474F), Color(0xFF78909C)],   // Grey-Blue - Other
  ];

  // ─── Light Theme ───────────────────────────────────────────────────────────

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _primaryLight,
        onPrimary: Colors.white,
        secondary: _secondaryLight,
        onSecondary: Colors.white,
        tertiary: Color(0xFF00695C),
        surface: _surfaceLight,
        onSurface: _onSurfaceLight,
        onSurfaceVariant: _onSurfaceVariantLight,
        surfaceContainerLowest: Colors.white,
        surfaceContainerLow: Color(0xFFEEF2EE),
        surfaceContainer: _surfaceContainerLight,
        surfaceContainerHigh: Color(0xFFE8EEE8),
        surfaceContainerHighest: Color(0xFFDDE4DC),
        error: Color(0xFFB71C1C),
        outline: Color(0xFFC8D4C7),
        outlineVariant: Color(0xFFDDE4DC),
      ),
      scaffoldBackgroundColor: _surfaceLight,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ).apply(
        bodyColor: _onSurfaceLight,
        displayColor: _onSurfaceLight,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryLight,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: _surfaceContainerLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE0E8DF), width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFE8F5E9),
        selectedColor: _primaryLight.withValues(alpha: 0.15),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: _onSurfaceVariantLight,
        ),
        side: const BorderSide(color: Color(0xFFC8D4C7)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: GoogleFonts.inter(
          color: _onSurfaceVariantLight,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC8D4C7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC8D4C7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryLight, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _surfaceContainerLight,
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        height: 65,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _primaryLight,
            );
          }
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: _onSurfaceVariantLight,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: _primaryLight, size: 24);
          }
          return const IconThemeData(color: _onSurfaceVariantLight, size: 24);
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _onSurfaceLight,
          side: const BorderSide(color: Color(0xFFC8D4C7)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _primaryLight;
          return _onSurfaceVariantLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryLight.withValues(alpha: 0.3);
          }
          return const Color(0xFFDDE4DC);
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E8DF),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _onSurfaceLight,
        contentTextStyle: GoogleFonts.inter(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ─── Dark Theme ────────────────────────────────────────────────────────────

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _primaryDark,
        onPrimary: Colors.black,
        secondary: _secondaryDark,
        onSecondary: Colors.black,
        surface: _surfaceDark,
        onSurface: _onSurfaceDark,
        onSurfaceVariant: _onSurfaceVariantDark,
        surfaceContainerLowest: Color(0xFF0A0D0A),
        surfaceContainerLow: Color(0xFF141714),
        surfaceContainer: _surfaceContainerDark,
        surfaceContainerHigh: _surfaceContainerHighDark,
        surfaceContainerHighest: Color(0xFF2E332D),
        error: Color(0xFFEF5350),
        outline: Color(0xFF3A4239),
        outlineVariant: Color(0xFF2A3029),
      ),
      scaffoldBackgroundColor: _surfaceDark,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: _onSurfaceDark,
        displayColor: _onSurfaceDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryGreenDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: _surfaceContainerDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF2A3029), width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _surfaceContainerHighDark,
        selectedColor: _primaryDark.withValues(alpha: 0.25),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: _onSurfaceVariantDark,
        ),
        side: const BorderSide(color: Color(0xFF3A4239)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceContainerHighDark,
        hintStyle: GoogleFonts.inter(
          color: _onSurfaceVariantDark,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A4239)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A4239)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryDark, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _surfaceContainerDark,
        height: 65,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _primaryDark,
            );
          }
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: _onSurfaceVariantDark,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: _primaryDark, size: 24);
          }
          return const IconThemeData(color: _onSurfaceVariantDark, size: 24);
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryDark,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _onSurfaceDark,
          side: const BorderSide(color: Color(0xFF3A4239)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _primaryDark;
          return _onSurfaceVariantDark;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryDark.withValues(alpha: 0.3);
          }
          return _surfaceContainerHighDark;
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A3029),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _surfaceContainerHighDark,
        contentTextStyle: GoogleFonts.inter(color: _onSurfaceDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

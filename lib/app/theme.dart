import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application theme configuration.
///
/// Provides dark and light themes with a consistent design system
/// and semantic colors for language endangerment levels.
class AppTheme {
  AppTheme._();

  // ─── Brand Colors ──────────────────────────────────────────────────────────

  // Vibrant teal-blue primary for a fresh, modern feel
  static const Color _primaryLight = Color(0xFF0D7377);
  static const Color _primaryDark = Color(0xFF4ECDC4);

  static const Color _secondaryLight = Color(0xFFFF6B6B);
  static const Color _secondaryDark = Color(0xFF03DAC6);

  // Light theme surfaces — clean whites with warm undertones
  static const Color _surfaceLight = Color(0xFFF5F7FA);
  static const Color _surfaceContainerLight = Color(0xFFFFFFFF);
  static const Color _onSurfaceLight = Color(0xFF1A2137);
  static const Color _onSurfaceVariantLight = Color(0xFF5A6478);

  // Dark theme surfaces
  static const Color _surfaceDark = Color(0xFF121218);
  static const Color _surfaceContainerDark = Color(0xFF1E1E2C);
  static const Color _surfaceContainerHighDark = Color(0xFF282840);
  static const Color _onSurfaceDark = Color(0xFFE8E6F0);
  static const Color _onSurfaceVariantDark = Color(0xFFA09CB0);

  // ─── Endangerment Colors ───────────────────────────────────────────────────

  static const Map<String, Color> endangermentColors = {
    'not endangered': Color(0xFF2ECC71),
    'threatened': Color(0xFFF1C40F),
    'shifting': Color(0xFFE67E22),
    'moribund': Color(0xFFE74C3C),
    'nearly extinct': Color(0xFFC0392B),
    'extinct': Color(0xFF95A5A6),
  };

  static Color getEndangermentColor(String status) {
    return endangermentColors[status] ?? const Color(0xFF95A5A6);
  }

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
        tertiary: Color(0xFF6C5CE7),
        surface: _surfaceLight,
        onSurface: _onSurfaceLight,
        onSurfaceVariant: _onSurfaceVariantLight,
        surfaceContainerLowest: Colors.white,
        surfaceContainerLow: Color(0xFFF0F2F5),
        surfaceContainer: _surfaceContainerLight,
        surfaceContainerHigh: Color(0xFFEDF0F5),
        surfaceContainerHighest: Color(0xFFE4E8EF),
        error: Color(0xFFE74C3C),
        outline: Color(0xFFD1D8E0),
        outlineVariant: Color(0xFFE8ECF1),
      ),
      scaffoldBackgroundColor: _surfaceLight,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ).apply(
        bodyColor: _onSurfaceLight,
        displayColor: _onSurfaceLight,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _surfaceContainerLight,
        foregroundColor: _onSurfaceLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _onSurfaceLight,
        ),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: _surfaceContainerLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE8ECF1), width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFEDF0F5),
        selectedColor: _primaryLight.withValues(alpha: 0.12),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: _onSurfaceVariantLight,
        ),
        side: const BorderSide(color: Color(0xFFD1D8E0)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFEDF0F5),
        hintStyle: GoogleFonts.inter(
          color: _onSurfaceVariantLight,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD1D8E0)),
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
        indicatorColor: _primaryLight.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _primaryLight,
            );
          }
          return GoogleFonts.inter(
            fontSize: 12,
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
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _primaryLight;
          return _onSurfaceVariantLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryLight.withValues(alpha: 0.3);
          }
          return const Color(0xFFE4E8EF);
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE8ECF1),
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
        surfaceContainerLowest: Color(0xFF0D0D12),
        surfaceContainerLow: Color(0xFF16161F),
        surfaceContainer: _surfaceContainerDark,
        surfaceContainerHigh: _surfaceContainerHighDark,
        surfaceContainerHighest: Color(0xFF32324A),
        error: Color(0xFFCF6679),
        outline: Color(0xFF3A3850),
        outlineVariant: Color(0xFF2A2840),
      ),
      scaffoldBackgroundColor: _surfaceDark,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: _onSurfaceDark,
        displayColor: _onSurfaceDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _surfaceContainerDark,
        foregroundColor: _onSurfaceDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _onSurfaceDark,
        ),
      ),
      cardTheme: CardThemeData(
        color: _surfaceContainerDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF2A2840), width: 1),
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
        side: const BorderSide(color: Color(0xFF3A3850)),
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
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3850)),
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
        indicatorColor: _primaryDark.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _primaryDark,
            );
          }
          return GoogleFonts.inter(
            fontSize: 12,
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
        color: Color(0xFF2A2840),
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the social media management application.
/// Implements Contemporary Minimalist Professional design with Dark Professional theme and Purple accents.
class AppTheme {
  AppTheme._();

  // Design System Colors - Dark Professional with Purple Accent
  static const Color primaryBackground =
      Color(0xFF1A1A1A); // Deep charcoal optimized for OLED displays
  static const Color secondaryBackground =
      Color(0xFF2D2D2D); // Subtle elevation for cards and modals
  static const Color accentPrimary =
      Color(0xFF6B46C1); // Purple for primary actions and brand elements
  static const Color accentSecondary = Color(
      0xFF8B5CF6); // Lighter purple for hover states and secondary interactive elements
  static const Color textPrimary =
      Color(0xFFFFFFFF); // Pure white for primary content with maximum contrast
  static const Color textSecondary = Color(
      0xFFB3B3B3); // Muted for supporting text while maintaining readability
  static const Color success =
      Color(0xFF10B981); // Green for positive actions and successful operations
  static const Color warning =
      Color(0xFFF59E0B); // Amber for caution states and pending operations
  static const Color error = Color(
      0xFFEF4444); // Red for errors and destructive actions, softened for dark theme
  static const Color borderSubtle = Color(
      0xFF404040); // Minimal borders only when necessary for content separation

  // Additional semantic colors
  static const Color surfaceElevated = Color(0xFF333333);
  static const Color surfacePressed = Color(0xFF404040);
  static const Color dividerColor = Color(0xFF404040);
  static const Color shadowColor =
      Color(0x33000000); // 20% opacity black for subtle elevation

  // Text emphasis colors
  static const Color textHighEmphasis = Color(0xDEFFFFFF); // 87% opacity
  static const Color textMediumEmphasis = Color(0x99FFFFFF); // 60% opacity
  static const Color textDisabled = Color(0x61FFFFFF); // 38% opacity

  /// Dark theme - Primary theme for the application
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: accentPrimary,
      onPrimary: textPrimary,
      primaryContainer: accentSecondary,
      onPrimaryContainer: textPrimary,
      secondary: accentSecondary,
      onSecondary: primaryBackground,
      secondaryContainer: accentPrimary,
      onSecondaryContainer: textPrimary,
      tertiary: success,
      onTertiary: primaryBackground,
      tertiaryContainer: success,
      onTertiaryContainer: textPrimary,
      error: error,
      onError: textPrimary,
      surface: primaryBackground,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: borderSubtle,
      outlineVariant: dividerColor,
      shadow: shadowColor,
      scrim: Color(0x80000000),
      inverseSurface: textPrimary,
      onInverseSurface: primaryBackground,
      inversePrimary: accentPrimary,
    ),
    scaffoldBackgroundColor: primaryBackground,
    cardColor: secondaryBackground,
    dividerColor: dividerColor,

    // AppBar Theme - Clean professional header
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBackground,
      foregroundColor: textPrimary,
      elevation: 0,
      shadowColor: shadowColor,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.15,
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
    ),

    // Card Theme - Adaptive cards with subtle elevation
    cardTheme: CardTheme(
      color: secondaryBackground,
      elevation: 2.0,
      shadowColor: shadowColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(8.0),
    ),

    // Bottom Navigation Theme - Touch-optimized navigation
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: secondaryBackground,
      selectedItemColor: accentPrimary,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    ),

    // Floating Action Button - Strategic FAB placement for content creation
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentPrimary,
      foregroundColor: textPrimary,
      elevation: 6.0,
      focusElevation: 8.0,
      hoverElevation: 8.0,
      highlightElevation: 12.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: textPrimary,
        backgroundColor: accentPrimary,
        disabledForegroundColor: textDisabled,
        disabledBackgroundColor: surfaceElevated,
        elevation: 2.0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentPrimary,
        disabledForegroundColor: textDisabled,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: accentPrimary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentPrimary,
        disabledForegroundColor: textDisabled,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // Text Theme - Inter font family for consistency and readability
    textTheme: _buildTextTheme(),

    // Input Decoration Theme - Clean form elements with focus states
    inputDecorationTheme: InputDecorationTheme(
      fillColor: secondaryBackground,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderSubtle, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderSubtle, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: accentPrimary, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: error, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: error, width: 2.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: borderSubtle.withAlpha(128), width: 1.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabled,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: error,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Switch Theme - Status-aware indicators
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentPrimary;
        }
        if (states.contains(WidgetState.disabled)) {
          return textDisabled;
        }
        return textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentPrimary.withAlpha(128);
        }
        if (states.contains(WidgetState.disabled)) {
          return borderSubtle;
        }
        return borderSubtle;
      }),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentPrimary;
        }
        if (states.contains(WidgetState.disabled)) {
          return borderSubtle;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(textPrimary),
      side: const BorderSide(color: borderSubtle, width: 2.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentPrimary;
        }
        if (states.contains(WidgetState.disabled)) {
          return borderSubtle;
        }
        return borderSubtle;
      }),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: accentPrimary,
      linearTrackColor: borderSubtle,
      circularTrackColor: borderSubtle,
    ),

    // Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: accentPrimary,
      inactiveTrackColor: borderSubtle,
      thumbColor: accentPrimary,
      overlayColor: accentPrimary.withAlpha(51),
      valueIndicatorColor: accentPrimary,
      valueIndicatorTextStyle: GoogleFonts.jetBrainsMono(
        color: textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Tab Bar Theme - Clean navigation tabs
    tabBarTheme: TabBarTheme(
      labelColor: accentPrimary,
      unselectedLabelColor: textSecondary,
      indicatorColor: accentPrimary,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
    ),

    // Tooltip Theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: surfaceElevated,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      textStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // SnackBar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surfaceElevated,
      contentTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentPrimary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 6.0,
    ),

    // List Tile Theme - Touch-optimized lists
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      selectedTileColor: accentPrimary.withAlpha(26),
      iconColor: textSecondary,
      textColor: textPrimary,
      selectedColor: accentPrimary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      minVerticalPadding: 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      subtitleTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
    ),

    // Drawer Theme
    drawerTheme: DrawerThemeData(
      backgroundColor: secondaryBackground,
      surfaceTintColor: Colors.transparent,
      elevation: 16.0,
      shadowColor: shadowColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
      ),
    ),

    // Dialog Theme - Contextual bottom sheets and modals
    dialogTheme: DialogTheme(
      backgroundColor: secondaryBackground,
      surfaceTintColor: Colors.transparent,
      elevation: 24.0,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: secondaryBackground,
      surfaceTintColor: Colors.transparent,
      elevation: 16.0,
      shadowColor: shadowColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
      ),
    ),

    // Expansion Tile Theme - Progressive disclosure
    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: Colors.transparent,
      collapsedBackgroundColor: Colors.transparent,
      textColor: textPrimary,
      collapsedTextColor: textPrimary,
      iconColor: textSecondary,
      collapsedIconColor: textSecondary,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      expandedAlignment: Alignment.centerLeft,
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  );

  /// Light theme - Fallback theme (application primarily uses dark theme)
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: accentPrimary,
      onPrimary: Colors.white,
      primaryContainer: accentSecondary,
      onPrimaryContainer: Colors.white,
      secondary: accentSecondary,
      onSecondary: Colors.white,
      secondaryContainer: accentPrimary,
      onSecondaryContainer: Colors.white,
      tertiary: success,
      onTertiary: Colors.white,
      tertiaryContainer: success,
      onTertiaryContainer: Colors.white,
      error: error,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black87,
      onSurfaceVariant: Colors.black54,
      outline: Colors.black26,
      outlineVariant: Colors.black12,
      shadow: Colors.black26,
      scrim: Colors.black54,
      inverseSurface: Colors.black87,
      onInverseSurface: Colors.white,
      inversePrimary: accentPrimary,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: _buildTextTheme(isLight: true),
  );

  /// Helper method to build text theme using Inter and JetBrains Mono fonts
  static TextTheme _buildTextTheme({bool isLight = false}) {
    final Color textColor = isLight ? Colors.black87 : textPrimary;
    final Color textColorSecondary = isLight ? Colors.black54 : textSecondary;
    final Color textColorDisabled = isLight ? Colors.black38 : textDisabled;

    return TextTheme(
      // Display styles - Inter Bold for major headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: textColor,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: textColor,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles - Inter SemiBold for section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles - Inter Medium for card titles and important labels
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body styles - Inter Regular for main content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textColorSecondary,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles - Inter Medium for buttons and labels
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textColorDisabled,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Data text style using JetBrains Mono for analytics and timestamps
  static TextStyle dataTextStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    bool isLight = false,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? (isLight ? Colors.black87 : textPrimary),
      letterSpacing: 0,
      height: 1.4,
    );
  }

  /// Helper method to get shadow for elevation effects
  static List<BoxShadow> getElevationShadow(double elevation) {
    return [
      BoxShadow(
        color: shadowColor,
        blurRadius: elevation * 2,
        offset: Offset(0, elevation),
      ),
    ];
  }

  /// Helper method to get border radius for consistent UI
  static BorderRadius getCardBorderRadius() {
    return BorderRadius.circular(12.0);
  }

  /// Helper method to get button border radius
  static BorderRadius getButtonBorderRadius() {
    return BorderRadius.circular(12.0);
  }

  /// Helper method to get input border radius
  static BorderRadius getInputBorderRadius() {
    return BorderRadius.circular(12.0);
  }
}

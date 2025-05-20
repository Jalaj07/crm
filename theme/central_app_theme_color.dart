import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // For platform brightness check
import 'package:shared_preferences/shared_preferences.dart';

// ==========================================================================
// Status Colors Theme Extension Definition
// ==========================================================================
// Place this *outside* the ThemeController class, but often in the same file
// Or, preferably, in its own file e.g., lib/theme/status_colors_extension.dart

@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({
    required this.pending,
    required this.approved,
    required this.inProgress,
    required this.completed,
    required this.defaultStatus,
    required this.pendingBackground,
    required this.approvedBackground,
    required this.inProgressBackground,
    required this.completedBackground,
    required this.defaultStatusBackground,
  });

  // --- Color Definitions ---
  // Define the specific color properties needed
  final Color? pending;
  final Color? approved;
  final Color? inProgress;
  final Color? completed;
  final Color? defaultStatus; // For 'All' or unknown statuses
  final Color? pendingBackground;
  final Color? approvedBackground;
  final Color? inProgressBackground;
  final Color? completedBackground;
  final Color? defaultStatusBackground;

  // --- Static Instances for Light & Dark ---
  // Moved color definitions here for clarity before static instances

  // Light Theme Status Colors
  static const Color _lightPending = Colors.orange; // Use base Color for light
  static const Color _lightApproved = Colors.green;
  static const Color _lightInProgress = Colors.blue;
  static const Color _lightCompleted = Colors.purple;
  static const Color _lightDefault = Colors.grey;
  static const Color _lightPendingBg = Color(
    0x26FF9800,
  ); // Approx .withAlpha(38)
  static const Color _lightApprovedBg = Color(0x264CAF50);
  static const Color _lightInProgressBg = Color(0x262196F3);
  static const Color _lightCompletedBg = Color(0x269C27B0);
  static const Color _lightDefaultBg = Color(
    0x199E9E9E,
  ); // Approx .withAlpha(25)

  // Dark Theme Status Colors (Brighter/Lighter shades for contrast)
  static final Color _darkPending = Colors.orange.shade300;
  static final Color _darkApproved = Colors.green.shade300;
  static final Color _darkInProgress = Colors.blue.shade300;
  static final Color _darkCompleted = Colors.purple.shade300;
  static final Color _darkDefault = Colors.grey.shade500;
  static final Color _darkPendingBg = _darkPending.withAlpha(
    19,
  ); // Use lighter color base w/ opacity
  static final Color _darkApprovedBg = _darkApproved.withAlpha(19);
  static final Color _darkInProgressBg = _darkInProgress.withAlpha(19);
  static final Color _darkCompletedBg = _darkCompleted.withAlpha(19);
  static final Color _darkDefaultBg = _darkDefault.withAlpha(21);

  static const lightStatusColors = StatusColors(
    pending: _lightPending,
    approved: _lightApproved,
    inProgress: _lightInProgress,
    completed: _lightCompleted,
    defaultStatus: _lightDefault,
    pendingBackground: _lightPendingBg,
    approvedBackground: _lightApprovedBg,
    inProgressBackground: _lightInProgressBg,
    completedBackground: _lightCompletedBg,
    defaultStatusBackground: _lightDefaultBg,
  );

  static final darkStatusColors = StatusColors(
    // Use final as Colors are not const
    pending: _darkPending,
    approved: _darkApproved,
    inProgress: _darkInProgress,
    completed: _darkCompleted,
    defaultStatus: _darkDefault,
    pendingBackground: _darkPendingBg,
    approvedBackground: _darkApprovedBg,
    inProgressBackground: _darkInProgressBg,
    completedBackground: _darkCompletedBg,
    defaultStatusBackground: _darkDefaultBg,
  );

  // --- Mandatory Override Methods ---
  @override
  StatusColors copyWith({
    Color? pending,
    Color? approved,
    Color? inProgress,
    Color? completed,
    Color? defaultStatus,
    Color? pendingBackground,
    Color? approvedBackground,
    Color? inProgressBackground,
    Color? completedBackground,
    Color? defaultStatusBackground,
  }) {
    return StatusColors(
      pending: pending ?? this.pending,
      approved: approved ?? this.approved,
      inProgress: inProgress ?? this.inProgress,
      completed: completed ?? this.completed,
      defaultStatus: defaultStatus ?? this.defaultStatus,
      pendingBackground: pendingBackground ?? this.pendingBackground,
      approvedBackground: approvedBackground ?? this.approvedBackground,
      inProgressBackground: inProgressBackground ?? this.inProgressBackground,
      completedBackground: completedBackground ?? this.completedBackground,
      defaultStatusBackground:
          defaultStatusBackground ?? this.defaultStatusBackground,
    );
  }

  @override
  StatusColors lerp(ThemeExtension<StatusColors>? other, double t) {
    if (other is! StatusColors) {
      return this;
    }
    // Helper to lerp or return current if other is null
    Color? lerpColor(Color? a, Color? b, double t) => Color.lerp(a, b, t);

    return StatusColors(
      pending: lerpColor(pending, other.pending, t),
      approved: lerpColor(approved, other.approved, t),
      inProgress: lerpColor(inProgress, other.inProgress, t),
      completed: lerpColor(completed, other.completed, t),
      defaultStatus: lerpColor(defaultStatus, other.defaultStatus, t),
      pendingBackground: lerpColor(
        pendingBackground,
        other.pendingBackground,
        t,
      ),
      approvedBackground: lerpColor(
        approvedBackground,
        other.approvedBackground,
        t,
      ),
      inProgressBackground: lerpColor(
        inProgressBackground,
        other.inProgressBackground,
        t,
      ),
      completedBackground: lerpColor(
        completedBackground,
        other.completedBackground,
        t,
      ),
      defaultStatusBackground: lerpColor(
        defaultStatusBackground,
        other.defaultStatusBackground,
        t,
      ),
    );
  }
}

// ==========================================================================
// Theme Controller Implementation
// ==========================================================================
class ThemeController extends ChangeNotifier {
  // --- Theme Persistence ---
  static const String _themePreferenceKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  // --- Initialization ---
  ThemeController() {
    _loadThemePreference();
  }

  // --- Theme Mode Logic ---
  // (Keep _loadThemePreference, setThemeMode, isDarkMode as they were)
  void _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString(_themePreferenceKey);
    if (savedThemeMode != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedThemeMode,
        orElse: () => ThemeMode.system,
      );
      // Update immediately AFTER loading, so the initial state reflects preference
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePreferenceKey, mode.toString());
  }

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      var brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  // ==========================================================================
  // Centralized Color Definitions (Used internally for Themes)
  // (Keep these as they define the base light/dark theme colors)
  // ==========================================================================

  // --- Primary & Accent Colors ---
  static const Color _primaryLight = Color(0xFF007AFF);
  static const Color _primaryDark = Color(0xFF0A84FF);
  static const Color _secondaryLight = Color(0xFFFF9500);
  static const Color _secondaryDark = Color(0xFFFFB340);
  static const Color _errorLight = Color(0xFFFF3B30);
  static const Color _errorDark = Color(0xFFFF453A);

  // --- Backgrounds & Surfaces ---
  static const Color _lightBackground = Color(0xFFF5F5F5);
  static const Color _lightSurface = Colors.white;
  static const Color _lightSurfaceVariant = Color(0xFFF2F2F7);
  static const Color _lightOutline = Color(0xFFD1D1D6);

  static const Color _darkBackground = Color(0xFF121212);
  static const Color _darkSurface = Color(0xFF1E1E1E);
  static const Color _darkSurfaceVariant = Color(0xFF3A3A3C);
  static const Color _darkOutline = Color(0xFF545458);

  // ==========================================================================
  // ThemeData Definitions
  // ==========================================================================
  static final BorderRadius _defaultBorderRadius = BorderRadius.circular(8);

  static ThemeData get lightTheme {
    final baseTheme = ThemeData.light(useMaterial3: true);
    final textTheme = baseTheme.textTheme;

    return baseTheme.copyWith(
      brightness: Brightness.light,
      primaryColor: _primaryLight,
      scaffoldBackgroundColor: _lightBackground,
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: _primaryLight,
        onPrimary: Colors.white,
        secondary: _secondaryLight,
        onSecondary: Colors.white,
        error: _errorLight,
        onError: Colors.white,
        surface: _lightSurface,
        onSurface: Colors.black87,
        surfaceContainerHighest: _lightSurfaceVariant,
        surfaceContainerLowest: _lightBackground,
        onSurfaceVariant:
            Colors.black, // Kept black for high contrast on light variant
        outline: _lightOutline,
        shadow: Colors.black12,
        tertiary: Color(0xFF1E88E5),
        tertiaryContainer: Color(0xFF64B5F6),
        onTertiaryContainer: Colors.white,
      ),
      textTheme: textTheme.apply(
        bodyColor: Colors.black87,
        displayColor: Colors.black87,
      ),
      // Define Component Themes (Keep your existing component themes)
      iconTheme: IconThemeData(color: Colors.grey[600], size: 24),
      dividerTheme: DividerThemeData(
        color: const Color.fromARGB(255, 233, 233, 233),
        thickness: 1,
        space: 1,
      ),
       drawerTheme: DrawerThemeData(
        backgroundColor: _lightSurface,
       ),
      cardTheme: CardTheme(
        elevation: 1,
        color: _lightSurface,
        shadowColor: Colors.black26,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: _defaultBorderRadius,
          borderSide: BorderSide(color: _lightOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _defaultBorderRadius,
          borderSide: BorderSide(color: _lightOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _defaultBorderRadius,
          borderSide: BorderSide(color: _primaryLight, width: 2),
        ),
        labelStyle: textTheme.bodyLarge?.copyWith(color: Colors.black54),
        hintStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey[400]),
        suffixIconColor: Colors.grey[600],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryLight,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: _defaultBorderRadius),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade500,
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(/* ... keep existing ... */),
      textButtonTheme: TextButtonThemeData(/* ... keep existing ... */),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        /* ... keep existing ... */
      ),
      snackBarTheme: SnackBarThemeData(/* ... keep existing ... */),
      dialogTheme: DialogTheme(/* ... keep existing ... */),
      bottomSheetTheme: BottomSheetThemeData(/* ... keep existing ... */),
      // --- ADD STATUS COLORS EXTENSION FOR LIGHT THEME ---
      extensions: const <ThemeExtension<dynamic>>[
        StatusColors.lightStatusColors, // Add the light version here
      ],
    );
  }

  static ThemeData get darkTheme {
    final baseTheme = ThemeData.dark(useMaterial3: true);
    final textTheme = baseTheme.textTheme;

    return baseTheme.copyWith(
      brightness: Brightness.dark,
      primaryColor: _primaryDark,
      scaffoldBackgroundColor: _darkBackground,
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: _primaryDark,
        onPrimary: Colors.black,
        secondary: _secondaryDark,
        onSecondary: Colors.black,
        error: _errorDark,
        onError: Colors.black,
        surface: _darkSurface,
        onSurface: Colors.white,
        surfaceContainerHighest: _darkSurfaceVariant,
        surfaceContainerLowest: _darkBackground,
        onSurfaceVariant:
            Colors.white70, // Adjusted for better readability on dark variant
        outline: _darkOutline,
        shadow: Colors.black38,
        tertiary: Color(0xFF90CAF9),
        tertiaryContainer: Color(0xFF42A5F5),
        onTertiaryContainer: Colors.black,
      ),
      textTheme: textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      // Define Component Themes (Keep your existing component themes)
      iconTheme: const IconThemeData(color: Colors.white70, size: 24),
      dividerTheme: DividerThemeData(
        color: _darkOutline,
        thickness: 1,
        space: 1,
      ),
           drawerTheme: DrawerThemeData(
        backgroundColor: _darkSurface,
           ),
      cardTheme: CardTheme(
        elevation: 1,
        color: _darkSurface,
        shadowColor: Colors.black54,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: _defaultBorderRadius,
          borderSide: BorderSide(color: _darkOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _defaultBorderRadius,
          borderSide: BorderSide(color: _darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _defaultBorderRadius,
          borderSide: BorderSide(color: _primaryDark, width: 2),
        ),
        labelStyle: textTheme.bodyLarge?.copyWith(color: Colors.white70),
        hintStyle: textTheme.bodyMedium?.copyWith(color: Colors.white54),
        suffixIconColor: Colors.white70,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryDark,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: _defaultBorderRadius),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          disabledBackgroundColor: Colors.white12,
          disabledForegroundColor: Colors.white38,
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(/* ... keep existing ... */),
      textButtonTheme: TextButtonThemeData(/* ... keep existing ... */),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        /* ... keep existing ... */
      ),
      snackBarTheme: SnackBarThemeData(/* ... keep existing ... */),
      dialogTheme: DialogTheme(/* ... keep existing ... */),
      bottomSheetTheme: BottomSheetThemeData(/* ... keep existing ... */),
      // --- ADD STATUS COLORS EXTENSION FOR DARK THEME ---
      extensions: <ThemeExtension<dynamic>>[
        // Use < > because Colors aren't const
        StatusColors.darkStatusColors, // Add the dark version here
      ],
    );
  }
}

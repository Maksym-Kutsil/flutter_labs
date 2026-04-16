import 'package:flutter/material.dart';

/// Shared colors for Smart Pet Bowl UI (no IoT logic).
abstract final class PetBowlTheme {
  static const Color seed = Color(0xFF2A9D8F);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(seedColor: seed);
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: scheme.surfaceContainerLow,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Game color definitions for each block value
class GameColors {
  // Background colors (benchmark exact)
  static const Color background = Color(0xFF1E2432);
  static const Color boardBackground = Color(0xFF161B26);
  static const Color columnDivider = Color(0xFF2A3544);

  // UI colors
  static const Color primary = Color(0xFF2196F3);
  static const Color accent = Color(0xFFFF9800);
  static const Color coinYellow = Color(0xFFFFD700);

  // Block colors by value (matching original game)
  static const Map<int, Color> blockColors = {
    2: Color(0xFFE91E63),    // Pink/Magenta
    4: Color(0xFF4CAF50),    // Green
    8: Color(0xFF26C6DA),    // Cyan/Teal
    16: Color(0xFF2196F3),   // Blue
    32: Color(0xFFFF7043),   // Orange
    64: Color(0xFF9C27B0),   // Purple
    128: Color(0xFF5BA4A4),  // Teal/Cyan (darker)
    256: Color(0xFFEC407A),  // Bright Pink/Red
    512: Color(0xFF8BC34A),  // Light Green (with crown)
    1024: Color(0xFFFFEB3B), // Yellow (with crown)
    2048: Color(0xFFFF9800), // Orange/Gold (with crown)
    4096: Color(0xFF9C27B0), // Purple gradient start
  };

  // Gradient colors for high-value blocks
  static const Color gradient4096End = Color(0xFFE91E63);
  static const Color gradient8192Start = Color(0xFFFF5722);
  static const Color gradient8192End = Color(0xFFFFEB3B);

  // Special effects colors
  static const Color glowYellow = Color(0xFFFFD700);
  static const Color comboRed = Color(0xFFD32F2F);
  static const Color comboGold = Color(0xFFFFD700);

  /// Get color for a specific block value
  static Color getBlockColor(int value) {
    if (blockColors.containsKey(value)) {
      return blockColors[value]!;
    }
    // For values > 4096, return rainbow gradient
    return const Color(0xFFFF5722);
  }

  /// Get gradient for high-value blocks (4096+)
  static LinearGradient? getBlockGradient(int value) {
    if (value >= 4096) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
      );
    }
    return null;
  }

  /// Check if block should have crown icon
  static bool hasCrown(int value) {
    return value >= 512;
  }

  /// Check if block should have glow effect
  static bool hasGlow(int value) {
    return value >= 2048;
  }

  /// Get text color for block (always white for readability)
  static Color getTextColor(int value) {
    return Colors.white;
  }
}

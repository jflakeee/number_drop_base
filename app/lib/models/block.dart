import 'package:flutter/material.dart';
import '../config/colors.dart';

/// Represents a single block in the game
class Block {
  static int _idCounter = 0;

  final int value;
  final int row;
  final int column;
  final String id;

  Block({
    required this.value,
    required this.row,
    required this.column,
    String? id,
  }) : id = id ?? '${DateTime.now().microsecondsSinceEpoch}_${_idCounter++}';

  /// Get the color for this block
  Color get color => GameColors.getBlockColor(value);

  /// Get gradient for high-value blocks
  LinearGradient? get gradient => GameColors.getBlockGradient(value);

  /// Check if this block should have a crown icon
  bool get hasCrown => GameColors.hasCrown(value);

  /// Check if this block should have glow effect
  bool get hasGlow => GameColors.hasGlow(value);

  /// Get text color for this block
  Color get textColor => GameColors.getTextColor(value);

  /// Create a copy with updated position
  Block copyWith({
    int? value,
    int? row,
    int? column,
    String? id,
  }) {
    return Block(
      value: value ?? this.value,
      row: row ?? this.row,
      column: column ?? this.column,
      id: id ?? this.id,
    );
  }

  /// Create a merged block (double the value)
  Block merge(int newRow, int newColumn) {
    return Block(
      value: value * 2,
      row: newRow,
      column: newColumn,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Block && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Block(value: $value, row: $row, col: $column)';
}

import 'package:flutter/material.dart';
import '../models/block.dart';

/// Widget that displays a single block
class BlockWidget extends StatelessWidget {
  final Block block;
  final double size;
  final bool showShadow;
  final bool isHammerTarget;

  const BlockWidget({
    super.key,
    required this.block,
    required this.size,
    this.showShadow = false,
    this.isHammerTarget = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: showShadow ? block.color.withOpacity(0.3) : null,
        gradient: showShadow ? null : block.gradient,
        borderRadius: BorderRadius.circular(8),
        border: isHammerTarget
            ? Border.all(color: Colors.red, width: 2)
            : null,
        boxShadow: isHammerTarget
            ? [
                BoxShadow(
                  color: Colors.red.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : block.hasGlow && !showShadow
                ? [
                    BoxShadow(
                      color: block.color.withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
      ),
      child: showShadow
          ? null
          : Container(
              decoration: BoxDecoration(
                color: block.gradient == null ? block.color : null,
                gradient: block.gradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Crown icon for high-value blocks
                  if (block.hasCrown)
                    Positioned(
                      top: 2,
                      child: Icon(
                        Icons.star,
                        color: Colors.yellow.withOpacity(0.8),
                        size: size * 0.25,
                      ),
                    ),
                  // Hammer icon overlay when in hammer mode
                  if (isHammerTarget)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Icon(
                        Icons.close,
                        color: Colors.red.withOpacity(0.8),
                        size: size * 0.2,
                      ),
                    ),
                  // Block value
                  Text(
                    _formatValue(block.value),
                    style: TextStyle(
                      color: block.textColor,
                      fontSize: _getFontSize(block.value, size),
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _formatValue(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}K';
    }
    return value.toString();
  }

  double _getFontSize(int value, double size) {
    final digits = value.toString().length;
    if (digits <= 2) return size * 0.4;
    if (digits <= 3) return size * 0.35;
    if (digits <= 4) return size * 0.28;
    return size * 0.22;
  }
}

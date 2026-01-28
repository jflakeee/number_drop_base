import 'package:flutter/material.dart';
import '../config/colors.dart';

/// Widget to display opponent's real-time score during battle
class OpponentScoreDisplay extends StatelessWidget {
  final String displayName;
  final String? photoUrl;
  final int score;
  final int highestBlock;
  final bool isFinished;
  final bool isWinning;

  const OpponentScoreDisplay({
    super.key,
    required this.displayName,
    this.photoUrl,
    required this.score,
    required this.highestBlock,
    this.isFinished = false,
    this.isWinning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isWinning
            ? Colors.red.withOpacity(0.3)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: isWinning
            ? Border.all(color: Colors.red.withOpacity(0.5), width: 2)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[700],
            backgroundImage:
                photoUrl != null ? NetworkImage(photoUrl!) : null,
            child: photoUrl == null
                ? const Icon(Icons.person, color: Colors.white, size: 18)
                : null,
          ),
          const SizedBox(width: 8),

          // Name and score
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isFinished) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.flag,
                      color: Colors.green,
                      size: 12,
                    ),
                  ],
                ],
              ),
              Row(
                children: [
                  Text(
                    '$score',
                    style: TextStyle(
                      color: isWinning ? Colors.red : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: GameColors.getBlockColor(highestBlock)
                          .withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$highestBlock',
                      style: TextStyle(
                        color: GameColors.getBlockColor(highestBlock),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Winning indicator
          if (isWinning) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_upward,
              color: Colors.red,
              size: 16,
            ),
          ],
        ],
      ),
    );
  }
}

/// Compact version for smaller spaces
class OpponentScoreCompact extends StatelessWidget {
  final String displayName;
  final int score;
  final bool isFinished;

  const OpponentScoreCompact({
    super.key,
    required this.displayName,
    required this.score,
    this.isFinished = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person, color: Colors.white54, size: 14),
          const SizedBox(width: 4),
          Text(
            displayName.length > 8
                ? '${displayName.substring(0, 8)}...'
                : displayName,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isFinished) ...[
            const SizedBox(width: 4),
            const Icon(Icons.flag, color: Colors.green, size: 12),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';

/// Widget displaying score, high score, coins, and action buttons (benchmark exact style)
class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return Container(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
          child: Row(
            children: [
              // Left: Coins + Undo
              _buildCoinDisplay(gameState.coins),
              const SizedBox(width: 4),
              _buildMiniButton(
                icon: Icons.undo,
                onTap: gameState.canUndo ? () => gameState.undo() : () {},
              ),

              const Spacer(),

              // Center: Score
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('👑', style: TextStyle(fontSize: 10)),
                      const SizedBox(width: 2),
                      Text(
                        _formatNumber(gameState.highScore),
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _formatNumber(gameState.score),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Right: Ranking + Menu
              _buildRankingDisplay(),
              const SizedBox(width: 4),
              _buildMiniButton(
                icon: Icons.menu,
                onTap: () => gameState.pause(),
                showDot: true,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCoinDisplay(int coins) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      decoration: BoxDecoration(
        color: const Color(0xFF4A9FE8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2D6AB3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFB8860B), width: 1),
            ),
            child: const Center(
              child: Text('😊', style: TextStyle(fontSize: 9)),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            _formatNumber(coins),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingDisplay() {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      decoration: BoxDecoration(
        color: const Color(0xFF4A9FE8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2D6AB3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: Color(0xFF90EE90),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.public, color: Colors.white, size: 11),
          ),
          const SizedBox(width: 3),
          const Text(
            '#---',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniButton({
    required IconData icon,
    required VoidCallback onTap,
    bool showDot = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: const Color(0xFF3D5A80),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            if (showDot)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 10000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../config/colors.dart';
import '../models/game_state.dart';

/// Widget displaying score, high score, coins, and action buttons (benchmark exact style)
class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              // Row 1: Coins (left), Score (center), Ranking (right)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Coins - blue pill shape (benchmark: ~100x36)
                  _buildCoinDisplay(gameState.coins),

                  const Spacer(),

                  // Score area (center) - benchmark style
                  Column(
                    children: [
                      // High score with crown
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('👑', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(
                            _formatNumber(gameState.highScore),
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      // Current score (large) - benchmark: 36px bold
                      Text(
                        _formatNumber(gameState.score),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // World ranking (right) - benchmark style
                  _buildRankingDisplay(),
                ],
              ),

              const SizedBox(height: 10),

              // Row 2: Action buttons - benchmark exact layout
              Row(
                children: [
                  // Left: Undo button
                  _buildSquareButton(
                    icon: Icons.undo,
                    onTap: gameState.canUndo ? () => gameState.undo() : () {},
                  ),
                  const SizedBox(width: 8),
                  // Left: Invite button with label
                  _buildLabelButton(
                    icon: Icons.person_add,
                    label: '초대',
                    onTap: () {
                      Share.share('Number Drop 게임에 도전해보세요! 🎮');
                    },
                  ),

                  const Spacer(),

                  // Right: Premium button with label
                  _buildLabelButton(
                    icon: Icons.card_giftcard,
                    label: '프리미엄',
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                  // Right: Menu button with red dot
                  _buildMenuButton(
                    onTap: () => gameState.pause(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCoinDisplay(int coins) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: const Color(0xFF4A9FE8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2D6AB3), width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Yellow coin circle
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFB8860B), width: 1),
            ),
            child: const Center(
              child: Text('😊', style: TextStyle(fontSize: 12)),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            _formatNumber(coins),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          // Plus button
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFF7EC8F8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingDisplay() {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: const Color(0xFF4A9FE8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2D6AB3), width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Color(0xFF90EE90),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.public, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 4),
          const Text(
            '#',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            '4058421',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSquareButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF3D5A80),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildLabelButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF3D5A80),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF3D5A80),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.menu, color: Colors.white, size: 24),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 10,
                height: 10,
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

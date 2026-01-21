import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import 'block_widget.dart';

/// Widget showing current and next block preview (matching original game style)
class NextBlockPreview extends StatelessWidget {
  const NextBlockPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Current block (larger)
              if (gameState.currentBlock != null)
                BlockWidget(
                  block: gameState.currentBlock!,
                  size: 70,
                ),

              const SizedBox(width: 8),

              // Next block (smaller, aligned to bottom)
              if (gameState.nextBlock != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: BlockWidget(
                    block: gameState.nextBlock!,
                    size: 40,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

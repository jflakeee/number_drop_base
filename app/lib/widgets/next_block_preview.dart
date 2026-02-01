import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import 'block_widget.dart';

/// Widget showing current and next block preview (benchmark exact style)
class NextBlockPreview extends StatelessWidget {
  const NextBlockPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return Container(
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Current block (larger) - benchmark: ~80x80
              if (gameState.currentBlock != null)
                BlockWidget(
                  block: gameState.currentBlock!,
                  size: 80,
                ),

              const SizedBox(width: 10),

              // Next block (smaller) - benchmark: ~50x50
              if (gameState.nextBlock != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: BlockWidget(
                    block: gameState.nextBlock!,
                    size: 50,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

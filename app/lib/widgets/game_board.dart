import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/colors.dart';
import '../config/constants.dart';
import '../models/game_state.dart';
import 'block_widget.dart';

/// Main game board widget
class GameBoard extends StatefulWidget {
  final bool hammerMode;
  final void Function(int row, int column)? onHammerUse;

  const GameBoard({
    super.key,
    this.hammerMode = false,
    this.onHammerUse,
  });

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  int? _hoveredColumn;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final boardWidth = constraints.maxWidth;
            final boardHeight = constraints.maxHeight;
            final cellWidth = boardWidth / GameConstants.columns;
            final cellHeight = boardHeight / GameConstants.rows;
            final cellSize = cellWidth < cellHeight ? cellWidth : cellHeight;

            return GestureDetector(
              onTapDown: (details) {
                if (gameState.isGameOver || gameState.isPaused) return;

                final column = (details.localPosition.dx / cellWidth).floor();
                final row = (details.localPosition.dy / cellHeight).floor();

                // Hammer mode - tap on a block to remove it
                if (widget.hammerMode) {
                  if (row >= 0 &&
                      row < GameConstants.rows &&
                      column >= 0 &&
                      column < GameConstants.columns) {
                    widget.onHammerUse?.call(row, column);
                  }
                  return;
                }

                // Normal mode - drop block
                if (column >= 0 && column < GameConstants.columns) {
                  gameState.dropBlock(column);
                }
              },
              onPanUpdate: (details) {
                if (widget.hammerMode) return; // Disable drag in hammer mode

                final column = (details.localPosition.dx / cellWidth).floor();
                if (column >= 0 && column < GameConstants.columns) {
                  setState(() {
                    _hoveredColumn = column;
                  });
                }
              },
              onPanEnd: (_) {
                if (widget.hammerMode) return;

                if (_hoveredColumn != null &&
                    !gameState.isGameOver &&
                    !gameState.isPaused) {
                  gameState.dropBlock(_hoveredColumn!);
                }
                setState(() {
                  _hoveredColumn = null;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: GameColors.boardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: widget.hammerMode
                      ? Border.all(color: Colors.red.withOpacity(0.5), width: 2)
                      : null,
                ),
                child: Stack(
                  children: [
                    // Column dividers
                    _buildColumnDividers(boardWidth, boardHeight, cellWidth),

                    // Drop shadow preview (only when not in hammer mode)
                    if (!widget.hammerMode &&
                        _hoveredColumn != null &&
                        gameState.currentBlock != null)
                      _buildDropShadow(
                        gameState,
                        _hoveredColumn!,
                        cellWidth,
                        cellHeight,
                        cellSize,
                      ),

                    // Placed blocks
                    ...gameState.board.asMap().entries.expand((rowEntry) {
                      return rowEntry.value
                          .asMap()
                          .entries
                          .where((e) => e.value != null)
                          .map((colEntry) {
                        final block = colEntry.value!;
                        return Positioned(
                          left: block.column * cellWidth +
                              (cellWidth - cellSize) / 2,
                          top: block.row * cellHeight +
                              (cellHeight - cellSize) / 2,
                          child: GestureDetector(
                            onTap: widget.hammerMode
                                ? () => widget.onHammerUse
                                    ?.call(block.row, block.column)
                                : null,
                            child: BlockWidget(
                              block: block,
                              size: cellSize - 4,
                              isHammerTarget: widget.hammerMode,
                            ),
                          ),
                        );
                      });
                    }),

                    // Column highlight on hover (only when not in hammer mode)
                    if (!widget.hammerMode && _hoveredColumn != null)
                      Positioned(
                        left: _hoveredColumn! * cellWidth,
                        top: 0,
                        child: Container(
                          width: cellWidth,
                          height: boardHeight,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildColumnDividers(double width, double height, double cellWidth) {
    return Stack(
      children: List.generate(GameConstants.columns - 1, (index) {
        return Positioned(
          left: (index + 1) * cellWidth,
          top: 0,
          child: Container(
            width: 1,
            height: height,
            color: GameColors.columnDivider,
          ),
        );
      }),
    );
  }

  Widget _buildDropShadow(
    GameState gameState,
    int column,
    double cellWidth,
    double cellHeight,
    double cellSize,
  ) {
    // Find landing row
    int landingRow = GameConstants.rows - 1;
    for (int row = GameConstants.rows - 1; row >= 0; row--) {
      if (gameState.board[row][column] == null) {
        landingRow = row;
        break;
      } else if (row == 0) {
        return const SizedBox.shrink();
      }
    }

    final shadowBlock = gameState.currentBlock!.copyWith(
      row: landingRow,
      column: column,
    );

    return Positioned(
      left: column * cellWidth + (cellWidth - cellSize) / 2,
      top: landingRow * cellHeight + (cellHeight - cellSize) / 2,
      child: BlockWidget(
        block: shadowBlock,
        size: cellSize - 4,
        showShadow: true,
      ),
    );
  }
}

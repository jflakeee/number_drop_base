import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/colors.dart';
import '../config/constants.dart';
import '../models/block.dart';
import '../models/game_state.dart';
import 'animated_block_widget.dart';
import 'score_popup.dart';

/// Animated game board with drop, merge, and gravity effects
class AnimatedGameBoard extends StatefulWidget {
  final bool hammerMode;
  final void Function(int row, int column)? onHammerUse;

  const AnimatedGameBoard({
    super.key,
    this.hammerMode = false,
    this.onHammerUse,
  });

  @override
  State<AnimatedGameBoard> createState() => _AnimatedGameBoardState();
}

class _AnimatedGameBoardState extends State<AnimatedGameBoard>
    with TickerProviderStateMixin {
  int? _hoveredColumn;
  int? _droppingColumn;
  double _dropProgress = 1.0;
  AnimationController? _dropController;

  // Score popups
  final List<_ScorePopupData> _scorePopups = [];

  // Track which blocks are newly placed or merging
  final Set<String> _newBlocks = {};
  final Set<String> _mergingBlocks = {};

  // Track previously seen block IDs to detect merges
  final Set<String> _knownBlockIds = {};

  @override
  void initState() {
    super.initState();
    _dropController = AnimationController(
      duration: Duration(milliseconds: GameConstants.dropDuration),
      vsync: this,
    )..addListener(() {
        setState(() {
          _dropProgress = _dropController!.value;
        });
      });
  }

  @override
  void dispose() {
    _dropController?.dispose();
    super.dispose();
  }

  void _handleDrop(GameState gameState, int column) async {
    if (gameState.isGameOver || gameState.isPaused) return;
    if (gameState.currentBlock == null) return;
    if (_droppingColumn != null) return; // 이미 떨어지는 중이면 무시

    setState(() {
      _droppingColumn = column;
    });

    // Drop the block immediately (no animation)
    await gameState.dropBlock(column);

    setState(() {
      _droppingColumn = null;
    });
  }

  // ignore: unused_element
  void _addScorePopup(int score, Offset position) {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    setState(() {
      _scorePopups.add(_ScorePopupData(id: id, score: score, position: position));
    });
  }

  void _removeScorePopup(String id) {
    setState(() {
      _scorePopups.removeWhere((p) => p.id == id);
    });
  }

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
                if (_droppingColumn != null) return; // 떨어지는 중이면 무시

                final column = (details.localPosition.dx / cellWidth).floor();
                final row = (details.localPosition.dy / cellHeight).floor();

                // Hammer mode
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
                  _handleDrop(gameState, column);
                }
              },
              onPanUpdate: (details) {
                if (widget.hammerMode) return;

                final column = (details.localPosition.dx / cellWidth).floor();
                if (column >= 0 && column < GameConstants.columns) {
                  setState(() {
                    _hoveredColumn = column;
                  });
                }
              },
              onPanEnd: (_) {
                if (widget.hammerMode) return;
                if (_droppingColumn != null) return; // 떨어지는 중이면 무시

                if (_hoveredColumn != null &&
                    !gameState.isGameOver &&
                    !gameState.isPaused) {
                  _handleDrop(gameState, _hoveredColumn!);
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

                    // Column highlight
                    if (!widget.hammerMode && _hoveredColumn != null)
                      _buildColumnHighlight(
                          _hoveredColumn!, boardHeight, cellWidth),

                    // Drop shadow preview
                    if (!widget.hammerMode &&
                        _hoveredColumn != null &&
                        gameState.currentBlock != null &&
                        _droppingColumn == null)
                      _buildDropShadow(
                        gameState,
                        _hoveredColumn!,
                        cellWidth,
                        cellHeight,
                        cellSize,
                      ),

                    // Placed blocks
                    ..._buildPlacedBlocks(
                      gameState,
                      cellWidth,
                      cellHeight,
                      cellSize,
                    ),

                    // Merge animations
                    ..._buildMergeAnimations(
                      gameState,
                      cellWidth,
                      cellHeight,
                      cellSize,
                    ),

                    // Score popups
                    ..._scorePopups.map((popup) {
                      return ScorePopup(
                        key: ValueKey(popup.id),
                        score: popup.score,
                        position: popup.position,
                        onComplete: () => _removeScorePopup(popup.id),
                      );
                    }),
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

  Widget _buildColumnHighlight(int column, double height, double cellWidth) {
    return Positioned(
      left: column * cellWidth,
      top: 0,
      child: Container(
        width: cellWidth,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF26C6DA).withOpacity(0.3),
              const Color(0xFF26C6DA).withOpacity(0.15),
              const Color(0xFF26C6DA).withOpacity(0.05),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildDropShadow(
    GameState gameState,
    int column,
    double cellWidth,
    double cellHeight,
    double cellSize,
  ) {
    int landingRow = _findLandingRow(gameState.board, column);
    if (landingRow < 0) return const SizedBox.shrink();

    final shadowBlock = gameState.currentBlock!.copyWith(
      row: landingRow,
      column: column,
    );

    return Positioned(
      left: column * cellWidth + (cellWidth - cellSize) / 2,
      top: landingRow * cellHeight + (cellHeight - cellSize) / 2,
      child: AnimatedBlockWidget(
        block: shadowBlock,
        size: cellSize - 4,
        showShadow: true,
      ),
    );
  }

  Widget _buildDroppingBlock(
    GameState gameState,
    int column,
    double cellWidth,
    double cellHeight,
    double cellSize,
  ) {
    int landingRow = _findLandingRow(gameState.board, column);
    if (landingRow < 0) return const SizedBox.shrink();

    // Calculate current position based on animation progress
    final startY = -cellHeight;
    final endY = landingRow * cellHeight + (cellHeight - cellSize) / 2;
    final currentY = startY + (endY - startY) * _dropProgress;

    return Positioned(
      left: column * cellWidth + (cellWidth - cellSize) / 2,
      top: currentY,
      child: AnimatedBlockWidget(
        block: gameState.currentBlock!.copyWith(
          row: landingRow,
          column: column,
        ),
        size: cellSize - 4,
      ),
    );
  }

  List<Widget> _buildPlacedBlocks(
    GameState gameState,
    double cellWidth,
    double cellHeight,
    double cellSize,
  ) {
    final widgets = <Widget>[];

    for (int row = 0; row < GameConstants.rows; row++) {
      for (int col = 0; col < GameConstants.columns; col++) {
        final block = gameState.board[row][col];
        if (block == null) continue;

        // Track block IDs
        if (!_knownBlockIds.contains(block.id)) {
          _knownBlockIds.add(block.id);
        }

        // Check if this block is currently merging
        final isMergingBlock = gameState.mergingBlockIds.contains(block.id);
        final duration = isMergingBlock
            ? GameConstants.mergeMoveDuration
            : GameConstants.gravityDuration;

        widgets.add(
          AnimatedPositioned(
            key: ValueKey(block.id),
            duration: Duration(milliseconds: duration),
            curve: isMergingBlock ? Curves.easeOutCubic : Curves.easeOut,
            left: block.column * cellWidth + (cellWidth - cellSize) / 2,
            top: block.row * cellHeight + (cellHeight - cellSize) / 2,
            child: GestureDetector(
              onTap: widget.hammerMode
                  ? () => widget.onHammerUse?.call(block.row, block.column)
                  : null,
              child: AnimatedBlockWidget(
                block: block,
                size: cellSize - 4,
                isHammerTarget: widget.hammerMode,
                isNew: false,
                isMerging: isMergingBlock,
              ),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  List<Widget> _buildMergeAnimations(
    GameState gameState,
    double cellWidth,
    double cellHeight,
    double cellSize,
  ) {
    if (!gameState.isMerging || gameState.mergeAnimations.isEmpty) {
      return [];
    }

    return gameState.mergeAnimations.map((anim) {
      // For below merges: move up halfway, then fade out
      if (anim.isBelowMerge) {
        return TweenAnimationBuilder<double>(
          key: ValueKey('merge_below_${anim.id}'),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: GameConstants.mergeMoveDuration),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            final startX = anim.fromColumn * cellWidth + (cellWidth - cellSize) / 2;
            final startY = anim.fromRow * cellHeight + (cellHeight - cellSize) / 2;
            final endX = anim.toColumn * cellWidth + (cellWidth - cellSize) / 2;
            final endY = anim.toRow * cellHeight + (cellHeight - cellSize) / 2;

            // Move only halfway (0 to 0.5 of the distance)
            final moveProgress = value < 0.5 ? value * 2 : 1.0;
            final halfwayY = startY + (endY - startY) * 0.5;
            final currentX = startX;
            final currentY = startY + (halfwayY - startY) * moveProgress;

            // Fade out after 50% of animation
            final opacity = value < 0.5 ? 1.0 : 1.0 - ((value - 0.5) * 2);

            // Scale down when fading
            final scale = value < 0.5 ? 1.0 : 1.0 - ((value - 0.5) * 0.5);

            return Positioned(
              left: currentX,
              top: currentY,
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: scale.clamp(0.5, 1.0),
                  child: AnimatedBlockWidget(
                    block: Block(
                      value: anim.value,
                      row: anim.toRow,
                      column: anim.toColumn,
                      id: anim.id,
                    ),
                    size: cellSize - 4,
                  ),
                ),
              ),
            );
          },
        );
      }

      // Normal merge animation (blocks move toward target)
      return TweenAnimationBuilder<double>(
        key: ValueKey('merge_${anim.id}'),
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: GameConstants.mergeMoveDuration),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          final startX = anim.fromColumn * cellWidth + (cellWidth - cellSize) / 2;
          final startY = anim.fromRow * cellHeight + (cellHeight - cellSize) / 2;
          final endX = anim.toColumn * cellWidth + (cellWidth - cellSize) / 2;
          final endY = anim.toRow * cellHeight + (cellHeight - cellSize) / 2;

          final currentX = startX + (endX - startX) * value;
          final currentY = startY + (endY - startY) * value;

          return Positioned(
            left: currentX,
            top: currentY,
            child: AnimatedBlockWidget(
              block: Block(
                value: anim.value,
                row: anim.toRow,
                column: anim.toColumn,
                id: anim.id,
              ),
              size: cellSize - 4,
            ),
          );
        },
      );
    }).toList();
  }

  int _findLandingRow(List<List<Block?>> board, int column) {
    for (int row = GameConstants.rows - 1; row >= 0; row--) {
      if (board[row][column] == null) {
        return row;
      }
    }
    return -1;
  }
}

class _ScorePopupData {
  final String id;
  final int score;
  final Offset position;

  _ScorePopupData({
    required this.id,
    required this.score,
    required this.position,
  });
}

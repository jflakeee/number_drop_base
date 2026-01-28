import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../models/ranking_entry.dart';
import '../services/auth_service.dart';

/// Ranking list widget displaying ranking entries
class RankingList extends StatelessWidget {
  final List<RankingEntry> rankings;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const RankingList({
    super.key,
    required this.rankings,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: GameColors.primary,
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: GameColors.primary,
                ),
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      );
    }

    if (rankings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.leaderboard_outlined,
              color: Colors.white38,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'No rankings yet',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Be the first to submit your score!',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        final entry = rankings[index];
        final rank = index + 1;
        final isCurrentUser = entry.userId == AuthService.instance.userId;

        return _RankingListItem(
          entry: entry,
          rank: rank,
          isCurrentUser: isCurrentUser,
        );
      },
    );
  }
}

class _RankingListItem extends StatelessWidget {
  final RankingEntry entry;
  final int rank;
  final bool isCurrentUser;

  const _RankingListItem({
    required this.entry,
    required this.rank,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? GameColors.primary.withOpacity(0.3)
            : GameColors.boardBackground,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser
            ? Border.all(color: GameColors.primary, width: 2)
            : Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          // Rank
          _buildRankBadge(),
          const SizedBox(width: 12),

          // Profile photo
          _buildProfilePhoto(),
          const SizedBox(width: 12),

          // Name and highest block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        entry.displayName,
                        style: TextStyle(
                          color: isCurrentUser ? Colors.white : Colors.white,
                          fontSize: 14,
                          fontWeight:
                              isCurrentUser ? FontWeight.bold : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: GameColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'YOU',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Best Block: ${entry.highestBlock}',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Score
          Text(
            _formatNumber(entry.score),
            style: TextStyle(
              color: isCurrentUser ? GameColors.coinYellow : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankBadge() {
    Color badgeColor;
    IconData? icon;

    switch (rank) {
      case 1:
        badgeColor = const Color(0xFFFFD700); // Gold
        icon = Icons.emoji_events;
        break;
      case 2:
        badgeColor = const Color(0xFFC0C0C0); // Silver
        icon = Icons.emoji_events;
        break;
      case 3:
        badgeColor = const Color(0xFFCD7F32); // Bronze
        icon = Icons.emoji_events;
        break;
      default:
        badgeColor = Colors.white38;
        icon = null;
    }

    return SizedBox(
      width: 32,
      child: icon != null
          ? Icon(icon, color: badgeColor, size: 24)
          : Text(
              rank.toString(),
              style: TextStyle(
                color: badgeColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
    );
  }

  Widget _buildProfilePhoto() {
    return CircleAvatar(
      radius: 18,
      backgroundColor: GameColors.primary.withOpacity(0.5),
      backgroundImage:
          entry.photoUrl != null ? NetworkImage(entry.photoUrl!) : null,
      child: entry.photoUrl == null
          ? Text(
              entry.displayName.isNotEmpty
                  ? entry.displayName[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 1)}K';
    }
    return number.toString();
  }
}

import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../models/ranking_entry.dart';
import '../services/auth_service.dart';

/// Card widget showing current user's ranking info
class MyRankCard extends StatelessWidget {
  final RankingEntry? myRanking;
  final int? rankPosition;
  final bool isLoading;
  final VoidCallback? onSignIn;
  final VoidCallback? onProfileEdit;

  const MyRankCard({
    super.key,
    this.myRanking,
    this.rankPosition,
    this.isLoading = false,
    this.onSignIn,
    this.onProfileEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isSignedIn = AuthService.instance.isSignedIn;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            GameColors.primary.withOpacity(0.8),
            GameColors.primary.withOpacity(0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: GameColors.primary,
          width: 2,
        ),
      ),
      child: isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            )
          : isSignedIn
              ? _buildSignedInContent()
              : _buildSignOutContent(),
    );
  }

  Widget _buildSignedInContent() {
    final authService = AuthService.instance;

    if (myRanking == null) {
      return Row(
        children: [
          // Profile photo
          _buildProfilePhoto(authService.photoUrl, authService.displayName),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        authService.displayName ?? 'Player',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (onProfileEdit != null) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onProfileEdit,
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white70,
                          size: 16,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'No ranking yet. Play a game!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        // Rank position
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  rankPosition != null ? '#$rankPosition' : '-',
                  style: TextStyle(
                    color: rankPosition != null && rankPosition! <= 3
                        ? GameColors.coinYellow
                        : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Profile photo
        _buildProfilePhoto(myRanking!.photoUrl, myRanking!.displayName),
        const SizedBox(width: 12),

        // Name and stats
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      myRanking!.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onProfileEdit != null) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onProfileEdit,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white70,
                        size: 16,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Best Block: ${myRanking!.highestBlock}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),

        // Score
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatNumber(myRanking!.score),
              style: const TextStyle(
                color: GameColors.coinYellow,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'HIGH SCORE',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 9,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignOutContent() {
    return InkWell(
      onTap: onSignIn,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.login,
            color: Colors.white,
            size: 24,
          ),
          SizedBox(width: 12),
          Text(
            'Sign in to see your ranking',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePhoto(String? photoUrl, String? displayName) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white.withOpacity(0.3),
      backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
      child: photoUrl == null
          ? Text(
              displayName?.isNotEmpty == true
                  ? displayName![0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
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

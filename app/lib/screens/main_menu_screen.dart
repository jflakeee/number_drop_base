import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../config/constants.dart';
import '../models/user_data.dart';
import '../services/storage_service.dart';
import '../services/offline_queue_service.dart';
import 'game_screen.dart';
import 'settings_screen.dart';
import 'shop_screen.dart';
import 'ranking_screen.dart';

/// Main menu screen
class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  UserData _userData = UserData();
  bool _isLoading = true;
  bool _hasPendingScores = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkPendingScores();
  }

  Future<void> _loadUserData() async {
    final userData = await StorageService.instance.loadUserData();
    setState(() {
      _userData = userData;
      _isLoading = false;
    });
  }

  Future<void> _checkPendingScores() async {
    final hasPending = await OfflineQueueService.instance.hasPendingScores();
    if (mounted) {
      setState(() => _hasPendingScores = hasPending);
    }
  }

  Future<void> _claimDailyBonus() async {
    if (!_userData.canClaimDailyBonus) return;

    final bonus = await StorageService.instance.claimDailyBonus(
      GameConstants.dailyBonusCoins,
    );

    if (bonus > 0) {
      setState(() {
        _userData.coins += bonus;
        _userData.lastDailyBonusAt = DateTime.now();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Daily bonus claimed: +$bonus coins!'),
            backgroundColor: GameColors.primary,
          ),
        );
      }
    }
  }

  void _startGame() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const GameScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GameColors.background,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Top bar
        _buildTopBar(),

        const Spacer(),

        // Game title
        _buildTitle(),

        const SizedBox(height: 40),

        // Stats display
        _buildStatsCard(),

        const SizedBox(height: 40),

        // Play button
        _buildPlayButton(),

        const Spacer(),

        // Bottom buttons
        _buildBottomButtons(),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Coins display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: GameColors.coinYellow,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '\$',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatNumber(_userData.coins),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Settings button
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white70,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        const Text(
          'NUMBER',
          style: TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [GameColors.accent, GameColors.coinYellow],
          ).createShader(bounds),
          child: const Text(
            'DROP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.bold,
              letterSpacing: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: GameColors.boardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // High score
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events,
                color: GameColors.coinYellow,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                _formatNumber(_userData.highScore),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'HIGH SCORE',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          // Highest block and games played
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                'BEST BLOCK',
                _userData.highestBlock.toString(),
                GameColors.accent,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.1),
              ),
              _buildStatItem(
                'GAMES',
                _userData.gamesPlayed.toString(),
                GameColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayButton() {
    return GestureDetector(
      onTap: _startGame,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [GameColors.primary, Color(0xFF1976D2)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: GameColors.primary.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 32,
            ),
            SizedBox(width: 8),
            Text(
              'PLAY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Daily bonus
          _buildBottomButton(
            icon: Icons.card_giftcard,
            label: 'DAILY',
            color: _userData.canClaimDailyBonus
                ? GameColors.accent
                : Colors.white38,
            onTap: _userData.canClaimDailyBonus ? _claimDailyBonus : null,
            badge: _userData.canClaimDailyBonus ? '!' : null,
          ),

          // Leaderboard
          _buildBottomButton(
            icon: Icons.leaderboard,
            label: 'RANK',
            color: Colors.white70,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RankingScreen()),
              ).then((_) => _checkPendingScores());
            },
            badge: _hasPendingScores ? '!' : null,
          ),

          // Shop
          _buildBottomButton(
            icon: Icons.store,
            label: 'SHOP',
            color: Colors.white70,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ShopScreen()),
              ).then((_) => _loadUserData());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (badge != null)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
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

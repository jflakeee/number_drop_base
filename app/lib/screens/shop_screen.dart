import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../services/iap_service.dart';
import '../services/ad_service.dart';
import '../services/storage_service.dart';

/// Shop screen for purchasing coins and premium features
class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupCallbacks();
  }

  void _setupCallbacks() {
    IAPService.instance.onCoinsEarned = (coins) async {
      await StorageService.instance.addCoins(coins);
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('+$coins coins added!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    };

    IAPService.instance.onAdsRemoved = () {
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ads removed!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    };

    IAPService.instance.onError = (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    };
  }

  Future<void> _watchAdForCoins() async {
    if (!AdService.instance.isRewardedAdReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ad not ready. Please try again later.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final coins = await AdService.instance.showRewardedAd();

    if (coins > 0) {
      await StorageService.instance.addCoins(coins);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('+$coins coins earned!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GameColors.background,
      appBar: AppBar(
        backgroundColor: GameColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'SHOP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Free coins section
                  _buildSectionTitle('FREE COINS'),
                  const SizedBox(height: 12),
                  _buildFreeCoinsCard(),

                  const SizedBox(height: 32),

                  // Coin packages
                  _buildSectionTitle('COIN PACKAGES'),
                  const SizedBox(height: 12),
                  ..._buildCoinPackages(),

                  const SizedBox(height: 32),

                  // Premium section
                  _buildSectionTitle('PREMIUM'),
                  const SizedBox(height: 12),
                  ..._buildPremiumOptions(),

                  const SizedBox(height: 20),

                  // Restore purchases button
                  TextButton(
                    onPressed: () => IAPService.instance.restorePurchases(),
                    child: const Text(
                      'Restore Purchases',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildFreeCoinsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            GameColors.primary.withOpacity(0.3),
            GameColors.primary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: GameColors.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: GameColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.play_circle_outline,
                  color: GameColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Watch Ad',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Earn 100-120 coins',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed:
                    AdService.instance.isRewardedAdReady ? _watchAdForCoins : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: GameColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'WATCH',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCoinPackages() {
    final packages = [
      {'id': IAPProducts.coins500, 'coins': 500, 'color': Colors.green},
      {'id': IAPProducts.coins1500, 'coins': 1500, 'color': Colors.blue},
      {'id': IAPProducts.coins5000, 'coins': 5000, 'color': Colors.purple},
    ];

    return packages.map((pkg) {
      final product = IAPService.instance.getProduct(pkg['id'] as String);
      final price = product?.price ?? '\$?.??';

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _buildPurchaseCard(
          icon: Icons.monetization_on,
          iconColor: pkg['color'] as Color,
          title: '${pkg['coins']} Coins',
          subtitle: 'One-time purchase',
          price: price,
          onTap: product != null
              ? () => IAPService.instance.purchase(product)
              : null,
        ),
      );
    }).toList();
  }

  List<Widget> _buildPremiumOptions() {
    final options = [
      {
        'id': IAPProducts.removeAds,
        'icon': Icons.block,
        'title': 'Remove Ads',
        'subtitle': 'No more interruptions',
        'color': Colors.orange,
      },
      {
        'id': IAPProducts.premium,
        'icon': Icons.star,
        'title': 'Premium',
        'subtitle': 'Remove ads + 2000 coins',
        'color': GameColors.coinYellow,
      },
    ];

    return options.map((opt) {
      final product = IAPService.instance.getProduct(opt['id'] as String);
      final price = product?.price ?? '\$?.??';
      final isPurchased = (opt['id'] == IAPProducts.removeAds &&
              IAPService.instance.removeAds) ||
          (opt['id'] == IAPProducts.premium && IAPService.instance.isPremium);

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _buildPurchaseCard(
          icon: opt['icon'] as IconData,
          iconColor: opt['color'] as Color,
          title: opt['title'] as String,
          subtitle: opt['subtitle'] as String,
          price: isPurchased ? 'OWNED' : price,
          onTap: !isPurchased && product != null
              ? () => IAPService.instance.purchase(product)
              : null,
          isPurchased: isPurchased,
        ),
      );
    }).toList();
  }

  Widget _buildPurchaseCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String price,
    VoidCallback? onTap,
    bool isPurchased = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: GameColors.boardBackground,
          borderRadius: BorderRadius.circular(12),
          border: isPurchased
              ? Border.all(color: Colors.green.withOpacity(0.5))
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isPurchased
                    ? Colors.green.withOpacity(0.2)
                    : GameColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                price,
                style: TextStyle(
                  color: isPurchased ? Colors.green : GameColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/constants.dart';

/// Service for handling Google AdMob ads
class AdService {
  static AdService? _instance;
  static AdService get instance {
    _instance ??= AdService._();
    return _instance!;
  }

  AdService._();

  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;

  // Test ad unit IDs (replace with real IDs in production)
  static const String _testRewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';

  // Production ad unit IDs (to be filled)
  static const String _prodRewardedAdUnitId = '';

  String get _rewardedAdUnitId =>
      kDebugMode ? _testRewardedAdUnitId : _prodRewardedAdUnitId;

  bool get isRewardedAdReady => _isRewardedAdReady;

  /// Initialize the ad service
  Future<void> init() async {
    // Skip on web platform - AdMob not supported
    if (kIsWeb) {
      debugPrint('AdService: Skipping on web platform');
      return;
    }

    try {
      await MobileAds.instance.initialize();
      _loadRewardedAd();
    } catch (e) {
      debugPrint('AdService init error: $e');
    }
  }

  /// Load a rewarded ad
  void _loadRewardedAd() {
    if (_rewardedAdUnitId.isEmpty) return;

    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdReady = true;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isRewardedAdReady = false;
              _loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isRewardedAdReady = false;
              _loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isRewardedAdReady = false;
          // Retry loading after delay
          Future.delayed(const Duration(seconds: 30), _loadRewardedAd);
        },
      ),
    );
  }

  /// Show rewarded ad and return coin reward
  Future<int> showRewardedAd() async {
    if (!_isRewardedAdReady || _rewardedAd == null) {
      return 0;
    }

    int earnedCoins = 0;

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        // Random reward between min and max
        earnedCoins = GameConstants.adRewardCoins +
            (DateTime.now().millisecond %
                (GameConstants.adRewardCoinsMax - GameConstants.adRewardCoins));
      },
    );

    return earnedCoins;
  }

  /// Dispose resources
  void dispose() {
    _rewardedAd?.dispose();
  }
}

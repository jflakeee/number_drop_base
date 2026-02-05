import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_data.dart';

/// Service for persisting user data
class StorageService {
  static const String _userDataKey = 'user_data';
  static StorageService? _instance;
  SharedPreferences? _prefs;

  StorageService._();

  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  /// Initialize the storage service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Load user data from storage
  Future<UserData> loadUserData() async {
    if (_prefs == null) await init();

    final jsonString = _prefs!.getString(_userDataKey);
    if (jsonString == null) {
      return UserData();
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserData.fromJson(json);
    } catch (e) {
      return UserData();
    }
  }

  /// Save user data to storage
  Future<void> saveUserData(UserData userData) async {
    if (_prefs == null) await init();

    final jsonString = jsonEncode(userData.toJson());
    await _prefs!.setString(_userDataKey, jsonString);
  }

  /// Update high score if new score is higher
  Future<void> updateHighScore(int score) async {
    final userData = await loadUserData();
    if (score > userData.highScore) {
      userData.highScore = score;
      await saveUserData(userData);
    }
  }

  /// Update coins
  Future<void> updateCoins(int coins) async {
    final userData = await loadUserData();
    userData.coins = coins;
    await saveUserData(userData);
  }

  /// Add coins
  Future<int> addCoins(int amount) async {
    final userData = await loadUserData();
    userData.coins += amount;
    await saveUserData(userData);
    return userData.coins;
  }

  /// Spend coins (returns false if not enough)
  Future<bool> spendCoins(int amount) async {
    final userData = await loadUserData();
    if (userData.coins < amount) return false;
    userData.coins -= amount;
    await saveUserData(userData);
    return true;
  }

  /// Update highest block achieved
  Future<void> updateHighestBlock(int blockValue) async {
    final userData = await loadUserData();
    if (blockValue > userData.highestBlock) {
      userData.highestBlock = blockValue;
      await saveUserData(userData);
    }
  }

  /// Increment games played counter
  Future<void> incrementGamesPlayed() async {
    final userData = await loadUserData();
    userData.gamesPlayed++;
    userData.lastPlayedAt = DateTime.now();
    await saveUserData(userData);
  }

  /// Claim daily bonus
  Future<int> claimDailyBonus(int bonusAmount) async {
    final userData = await loadUserData();
    if (!userData.canClaimDailyBonus) return 0;

    userData.coins += bonusAmount;
    userData.lastDailyBonusAt = DateTime.now();
    await saveUserData(userData);
    return bonusAmount;
  }

  /// Record a daily challenge play and update best score
  Future<bool> recordDailyChallengeScore(int score) async {
    final userData = await loadUserData();
    final todaysSeed = UserData.getTodaysSeed();

    // Check if this is a new day
    if (userData.lastDailyChallengeSeed != todaysSeed) {
      // Reset for new day
      userData.lastDailyChallengeSeed = todaysSeed;
      userData.dailyChallengeHighScore = score;
      userData.dailyChallengePlays = 1;
      await saveUserData(userData);
      return true; // New high score for today
    } else {
      // Same day - update plays count and check high score
      userData.dailyChallengePlays++;
      bool isNewHighScore = false;
      if (score > userData.dailyChallengeHighScore) {
        userData.dailyChallengeHighScore = score;
        isNewHighScore = true;
      }
      await saveUserData(userData);
      return isNewHighScore;
    }
  }

  /// Get today's daily challenge stats
  Future<Map<String, dynamic>> getDailyChallengeStats() async {
    final userData = await loadUserData();
    final todaysSeed = UserData.getTodaysSeed();

    if (userData.lastDailyChallengeSeed != todaysSeed) {
      // New day - no plays yet
      return {
        'played': false,
        'plays': 0,
        'highScore': 0,
        'seed': todaysSeed,
      };
    }

    return {
      'played': userData.dailyChallengePlays > 0,
      'plays': userData.dailyChallengePlays,
      'highScore': userData.dailyChallengeHighScore,
      'seed': todaysSeed,
    };
  }

  /// Clear all data (for testing)
  Future<void> clearAll() async {
    if (_prefs == null) await init();
    await _prefs!.clear();
  }
}

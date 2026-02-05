/// User data model for persistence
class UserData {
  int highScore;
  int coins;
  int gamesPlayed;
  int highestBlock;
  DateTime? lastPlayedAt;
  DateTime? lastDailyBonusAt;

  // Daily Challenge fields
  int? lastDailyChallengeSeed;
  int dailyChallengeHighScore;
  int dailyChallengePlays;

  UserData({
    this.highScore = 0,
    this.coins = 0,
    this.gamesPlayed = 0,
    this.highestBlock = 2,
    this.lastPlayedAt,
    this.lastDailyBonusAt,
    this.lastDailyChallengeSeed,
    this.dailyChallengeHighScore = 0,
    this.dailyChallengePlays = 0,
  });

  /// Create from JSON map
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      highScore: json['highScore'] ?? 0,
      coins: json['coins'] ?? 0,
      gamesPlayed: json['gamesPlayed'] ?? 0,
      highestBlock: json['highestBlock'] ?? 2,
      lastPlayedAt: json['lastPlayedAt'] != null
          ? DateTime.parse(json['lastPlayedAt'])
          : null,
      lastDailyBonusAt: json['lastDailyBonusAt'] != null
          ? DateTime.parse(json['lastDailyBonusAt'])
          : null,
      lastDailyChallengeSeed: json['lastDailyChallengeSeed'],
      dailyChallengeHighScore: json['dailyChallengeHighScore'] ?? 0,
      dailyChallengePlays: json['dailyChallengePlays'] ?? 0,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'highScore': highScore,
      'coins': coins,
      'gamesPlayed': gamesPlayed,
      'highestBlock': highestBlock,
      'lastPlayedAt': lastPlayedAt?.toIso8601String(),
      'lastDailyBonusAt': lastDailyBonusAt?.toIso8601String(),
      'lastDailyChallengeSeed': lastDailyChallengeSeed,
      'dailyChallengeHighScore': dailyChallengeHighScore,
      'dailyChallengePlays': dailyChallengePlays,
    };
  }

  /// Check if daily bonus is available
  bool get canClaimDailyBonus {
    if (lastDailyBonusAt == null) return true;
    final now = DateTime.now();
    final lastBonus = lastDailyBonusAt!;
    return now.year > lastBonus.year ||
        now.month > lastBonus.month ||
        now.day > lastBonus.day;
  }

  /// Get today's daily challenge seed
  static int getTodaysSeed() {
    final now = DateTime.now();
    return now.year * 10000 + now.month * 100 + now.day;
  }

  /// Check if this is a new daily challenge (different day)
  bool get isNewDailyChallenge {
    return lastDailyChallengeSeed != getTodaysSeed();
  }

  /// Check if player has already played today's challenge
  bool get hasPlayedTodaysChallenge {
    return lastDailyChallengeSeed == getTodaysSeed() && dailyChallengePlays > 0;
  }
}

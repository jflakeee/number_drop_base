/// User data model for persistence
class UserData {
  int highScore;
  int coins;
  int gamesPlayed;
  int highestBlock;
  DateTime? lastPlayedAt;
  DateTime? lastDailyBonusAt;

  UserData({
    this.highScore = 0,
    this.coins = 0,
    this.gamesPlayed = 0,
    this.highestBlock = 2,
    this.lastPlayedAt,
    this.lastDailyBonusAt,
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
}

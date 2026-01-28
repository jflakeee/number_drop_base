import 'package:cloud_firestore/cloud_firestore.dart';

/// Ranking entry model for Firestore
class RankingEntry {
  final String userId;
  final String displayName;
  final String? photoUrl;
  final int score;
  final int highestBlock;
  final int? gameSeed; // Seed for reproducible game verification
  final DateTime updatedAt;
  final String platform;

  const RankingEntry({
    required this.userId,
    required this.displayName,
    this.photoUrl,
    required this.score,
    required this.highestBlock,
    this.gameSeed,
    required this.updatedAt,
    required this.platform,
  });

  factory RankingEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RankingEntry(
      userId: doc.id,
      displayName: data['displayName'] ?? 'Unknown',
      photoUrl: data['photoUrl'],
      score: data['score'] ?? 0,
      highestBlock: data['highestBlock'] ?? 0,
      gameSeed: data['gameSeed'],
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      platform: data['platform'] ?? 'unknown',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'score': score,
      'highestBlock': highestBlock,
      'gameSeed': gameSeed,
      'updatedAt': FieldValue.serverTimestamp(),
      'platform': platform,
    };
  }

  RankingEntry copyWith({
    String? userId,
    String? displayName,
    String? photoUrl,
    int? score,
    int? highestBlock,
    int? gameSeed,
    DateTime? updatedAt,
    String? platform,
  }) {
    return RankingEntry(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      score: score ?? this.score,
      highestBlock: highestBlock ?? this.highestBlock,
      gameSeed: gameSeed ?? this.gameSeed,
      updatedAt: updatedAt ?? this.updatedAt,
      platform: platform ?? this.platform,
    );
  }
}

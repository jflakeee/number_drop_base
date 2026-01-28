import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ranking_service.dart';
import 'auth_service.dart';

/// Pending score entry for offline queue
class PendingScore {
  final int score;
  final int highestBlock;
  final int? gameSeed;
  final DateTime timestamp;

  const PendingScore({
    required this.score,
    required this.highestBlock,
    this.gameSeed,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'score': score,
        'highestBlock': highestBlock,
        'gameSeed': gameSeed,
        'timestamp': timestamp.toIso8601String(),
      };

  factory PendingScore.fromJson(Map<String, dynamic> json) => PendingScore(
        score: json['score'] as int,
        highestBlock: json['highestBlock'] as int,
        gameSeed: json['gameSeed'] as int?,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

/// Offline queue service singleton for storing scores when network is unavailable
class OfflineQueueService {
  OfflineQueueService._();
  static final OfflineQueueService instance = OfflineQueueService._();

  static const String _pendingScoresKey = 'pending_scores';
  SharedPreferences? _prefs;

  /// Initialize the service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Queue a score for later submission
  Future<void> queueScore({
    required int score,
    required int highestBlock,
    int? gameSeed,
  }) async {
    if (_prefs == null) await init();

    final pendingScores = await getPendingScores();

    // Only keep the highest score in queue
    final existingHighest = pendingScores.isEmpty
        ? 0
        : pendingScores.map((s) => s.score).reduce((a, b) => a > b ? a : b);

    if (score > existingHighest) {
      // Replace all with new highest
      final newScore = PendingScore(
        score: score,
        highestBlock: highestBlock,
        gameSeed: gameSeed,
        timestamp: DateTime.now(),
      );
      await _savePendingScores([newScore]);
      debugPrint('Score queued for offline submission: $score (seed: $gameSeed)');
    }
  }

  /// Get all pending scores
  Future<List<PendingScore>> getPendingScores() async {
    if (_prefs == null) await init();

    final jsonString = _prefs!.getString(_pendingScoresKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((e) => PendingScore.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error parsing pending scores: $e');
      return [];
    }
  }

  /// Check if there are pending scores
  Future<bool> hasPendingScores() async {
    final scores = await getPendingScores();
    return scores.isNotEmpty;
  }

  /// Get pending score count
  Future<int> getPendingCount() async {
    final scores = await getPendingScores();
    return scores.length;
  }

  /// Try to submit all pending scores
  /// Returns number of successfully submitted scores
  Future<int> submitPendingScores() async {
    if (!AuthService.instance.isSignedIn) {
      debugPrint('Cannot submit pending scores: not signed in');
      return 0;
    }

    final pendingScores = await getPendingScores();
    if (pendingScores.isEmpty) return 0;

    int submitted = 0;
    final remainingScores = <PendingScore>[];

    for (final pending in pendingScores) {
      try {
        final success = await RankingService.instance.submitScore(
          score: pending.score,
          highestBlock: pending.highestBlock,
          gameSeed: pending.gameSeed,
        );
        if (success) {
          submitted++;
        } else {
          // Keep in queue if submission failed (but not because of lower score)
          remainingScores.add(pending);
        }
      } catch (e) {
        debugPrint('Error submitting pending score: $e');
        remainingScores.add(pending);
      }
    }

    await _savePendingScores(remainingScores);
    debugPrint('Submitted $submitted pending scores');
    return submitted;
  }

  /// Clear all pending scores
  Future<void> clearPendingScores() async {
    if (_prefs == null) await init();
    await _prefs!.remove(_pendingScoresKey);
  }

  /// Save pending scores to SharedPreferences
  Future<void> _savePendingScores(List<PendingScore> scores) async {
    if (_prefs == null) await init();

    if (scores.isEmpty) {
      await _prefs!.remove(_pendingScoresKey);
    } else {
      final jsonString = json.encode(scores.map((s) => s.toJson()).toList());
      await _prefs!.setString(_pendingScoresKey, jsonString);
    }
  }
}

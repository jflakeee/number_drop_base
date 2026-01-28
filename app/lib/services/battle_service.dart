import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../models/battle.dart';
import 'auth_service.dart';

/// Battle service singleton for managing 1v1 battles
class BattleService {
  BattleService._();
  static final BattleService instance = BattleService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  /// Get battles collection reference
  CollectionReference<Map<String, dynamic>> get _battlesRef =>
      _firestore.collection('battles');

  /// Get realtime database reference for live scores
  DatabaseReference get _liveScoresRef => _database.ref('live_battles');

  /// Create a new battle room
  Future<Battle?> createBattle() async {
    final auth = AuthService.instance;
    if (!auth.isSignedIn) {
      debugPrint('Cannot create battle: not signed in');
      return null;
    }

    try {
      final odiserId = auth.userId!;
      final displayName = await auth.getCurrentDisplayName();
      final photoUrl = auth.photoUrl;

      // Generate random seed for this battle
      final seed = DateTime.now().millisecondsSinceEpoch % 100000000;

      final player = BattlePlayer(
        odiserId: odiserId,
        displayName: displayName,
        photoUrl: photoUrl,
      );

      final battleData = {
        'seed': seed,
        'status': BattleStatus.waiting.name,
        'players': {odiserId: player.toJson()},
        'winnerId': null,
        'createdAt': FieldValue.serverTimestamp(),
        'startedAt': null,
        'finishedAt': null,
      };

      final docRef = await _battlesRef.add(battleData);
      final doc = await docRef.get();

      // Initialize live scores in Realtime Database
      await _liveScoresRef.child(docRef.id).set({
        odiserId: {'score': 0, 'highestBlock': 0, 'isFinished': false},
      });

      debugPrint('Battle created: ${docRef.id}');
      return Battle.fromFirestore(doc);
    } catch (e) {
      debugPrint('Create battle error: $e');
      return null;
    }
  }

  /// Join an existing battle
  Future<Battle?> joinBattle(String battleId) async {
    final auth = AuthService.instance;
    if (!auth.isSignedIn) {
      debugPrint('Cannot join battle: not signed in');
      return null;
    }

    try {
      final odiserId = auth.userId!;
      final displayName = await auth.getCurrentDisplayName();
      final photoUrl = auth.photoUrl;

      final docRef = _battlesRef.doc(battleId);

      return await _firestore.runTransaction<Battle?>((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          debugPrint('Battle not found');
          return null;
        }

        final battle = Battle.fromFirestore(doc);

        // Check if already in battle
        if (battle.players.containsKey(odiserId)) {
          debugPrint('Already in this battle');
          return battle;
        }

        // Check if battle is full
        if (battle.isFull) {
          debugPrint('Battle is full');
          return null;
        }

        // Check if battle is still waiting
        if (battle.status != BattleStatus.waiting) {
          debugPrint('Battle is not accepting players');
          return null;
        }

        final player = BattlePlayer(
          odiserId: odiserId,
          displayName: displayName,
          photoUrl: photoUrl,
        );

        // Add player to battle
        transaction.update(docRef, {
          'players.$odiserId': player.toJson(),
        });

        // Initialize live score for this player
        await _liveScoresRef.child(battleId).child(odiserId).set({
          'score': 0,
          'highestBlock': 0,
          'isFinished': false,
        });

        debugPrint('Joined battle: $battleId');

        // Return updated battle
        final updatedPlayers = Map<String, BattlePlayer>.from(battle.players);
        updatedPlayers[odiserId] = player;
        return battle.copyWith(players: updatedPlayers);
      });
    } catch (e) {
      debugPrint('Join battle error: $e');
      return null;
    }
  }

  /// Find an available battle to join (matchmaking)
  Future<Battle?> findOrCreateBattle() async {
    final auth = AuthService.instance;
    if (!auth.isSignedIn) return null;

    try {
      // Find waiting battles
      final query = await _battlesRef
          .where('status', isEqualTo: BattleStatus.waiting.name)
          .orderBy('createdAt', descending: false)
          .limit(10)
          .get();

      final odiserId = auth.userId!;

      // Find a battle that isn't our own
      for (final doc in query.docs) {
        final battle = Battle.fromFirestore(doc);
        if (!battle.players.containsKey(odiserId) && !battle.isFull) {
          // Try to join this battle
          final joined = await joinBattle(battle.id);
          if (joined != null) return joined;
        }
      }

      // No available battle found, create new one
      return await createBattle();
    } catch (e) {
      debugPrint('Find or create battle error: $e');
      return null;
    }
  }

  /// Set player ready status
  Future<bool> setPlayerReady(String battleId, bool ready) async {
    final auth = AuthService.instance;
    if (!auth.isSignedIn) return false;

    try {
      final odiserId = auth.userId!;
      await _battlesRef.doc(battleId).update({
        'players.$odiserId.isReady': ready,
      });
      return true;
    } catch (e) {
      debugPrint('Set player ready error: $e');
      return false;
    }
  }

  /// Start the battle (when both players are ready)
  Future<bool> startBattle(String battleId) async {
    try {
      await _battlesRef.doc(battleId).update({
        'status': BattleStatus.playing.name,
        'startedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      debugPrint('Start battle error: $e');
      return false;
    }
  }

  /// Update live score (using Realtime Database for low latency)
  Future<void> updateLiveScore({
    required String battleId,
    required int score,
    required int highestBlock,
  }) async {
    final auth = AuthService.instance;
    if (!auth.isSignedIn) return;

    try {
      final odiserId = auth.userId!;
      await _liveScoresRef.child(battleId).child(odiserId).update({
        'score': score,
        'highestBlock': highestBlock,
      });
    } catch (e) {
      debugPrint('Update live score error: $e');
    }
  }

  /// Finish game for current player
  Future<void> finishGame({
    required String battleId,
    required int finalScore,
    required int highestBlock,
  }) async {
    final auth = AuthService.instance;
    if (!auth.isSignedIn) return;

    try {
      final odiserId = auth.userId!;

      // Update Firestore with final score
      await _battlesRef.doc(battleId).update({
        'players.$odiserId.score': finalScore,
        'players.$odiserId.highestBlock': highestBlock,
        'players.$odiserId.isFinished': true,
        'players.$odiserId.finishedAt': DateTime.now().toIso8601String(),
      });

      // Update Realtime Database
      await _liveScoresRef.child(battleId).child(odiserId).update({
        'score': finalScore,
        'highestBlock': highestBlock,
        'isFinished': true,
      });

      // Check if both players finished
      final doc = await _battlesRef.doc(battleId).get();
      final battle = Battle.fromFirestore(doc);

      if (battle.allPlayersFinished) {
        // Determine winner and update battle
        String? odiserId;
        final playerList = battle.players.values.toList();
        if (playerList[0].score > playerList[1].score) {
          odiserId = playerList[0].odiserId;
        } else if (playerList[1].score > playerList[0].score) {
          odiserId = playerList[1].odiserId;
        }

        await _battlesRef.doc(battleId).update({
          'status': BattleStatus.finished.name,
          'winnerId': odiserId,
          'finishedAt': FieldValue.serverTimestamp(),
        });

        // Clean up Realtime Database after a delay
        Future.delayed(const Duration(minutes: 5), () {
          _liveScoresRef.child(battleId).remove();
        });
      }
    } catch (e) {
      debugPrint('Finish game error: $e');
    }
  }

  /// Listen to battle updates (Firestore)
  Stream<Battle?> watchBattle(String battleId) {
    return _battlesRef.doc(battleId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Battle.fromFirestore(doc);
    });
  }

  /// Listen to live scores (Realtime Database)
  Stream<Map<String, dynamic>> watchLiveScores(String battleId) {
    return _liveScoresRef.child(battleId).onValue.map((event) {
      if (event.snapshot.value == null) return {};
      return Map<String, dynamic>.from(event.snapshot.value as Map);
    });
  }

  /// Leave a battle (before it starts)
  Future<bool> leaveBattle(String battleId) async {
    final auth = AuthService.instance;
    if (!auth.isSignedIn) return false;

    try {
      final odiserId = auth.userId!;
      final doc = await _battlesRef.doc(battleId).get();

      if (!doc.exists) return false;

      final battle = Battle.fromFirestore(doc);

      // Can only leave if battle hasn't started
      if (battle.status != BattleStatus.waiting &&
          battle.status != BattleStatus.ready) {
        debugPrint('Cannot leave battle: already started');
        return false;
      }

      // If only one player (creator), delete the battle
      if (battle.playerCount == 1) {
        await _battlesRef.doc(battleId).delete();
        await _liveScoresRef.child(battleId).remove();
      } else {
        // Remove player from battle
        await _battlesRef.doc(battleId).update({
          'players.$odiserId': FieldValue.delete(),
          'status': BattleStatus.waiting.name,
        });
        await _liveScoresRef.child(battleId).child(odiserId).remove();
      }

      return true;
    } catch (e) {
      debugPrint('Leave battle error: $e');
      return false;
    }
  }

  /// Get battle by ID
  Future<Battle?> getBattle(String battleId) async {
    try {
      final doc = await _battlesRef.doc(battleId).get();
      if (!doc.exists) return null;
      return Battle.fromFirestore(doc);
    } catch (e) {
      debugPrint('Get battle error: $e');
      return null;
    }
  }

  /// Get recent battles for current user
  Future<List<Battle>> getMyBattles({int limit = 20}) async {
    final auth = AuthService.instance;
    if (!auth.isSignedIn) return [];

    try {
      final odiserId = auth.userId!;

      // Note: This requires a composite index in Firestore
      final query = await _battlesRef
          .where('players.$odiserId.odiserId', isEqualTo: odiserId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return query.docs.map((doc) => Battle.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('Get my battles error: $e');
      return [];
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

/// User profile model for Firestore (custom nickname storage)
class UserProfile {
  final String userId;
  final String displayName;
  final String? photoUrl;
  final DateTime createdAt;

  const UserProfile({
    required this.userId,
    required this.displayName,
    this.photoUrl,
    required this.createdAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      userId: doc.id,
      displayName: data['displayName'] ?? 'Unknown',
      photoUrl: data['photoUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toFirestoreUpdate() {
    return {
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }

  UserProfile copyWith({
    String? userId,
    String? displayName,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

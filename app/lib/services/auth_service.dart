import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';

/// Authentication service singleton for Google Sign-In
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => currentUser != null;
  String? get userId => currentUser?.uid;
  String? get displayName => currentUser?.displayName;
  String? get photoUrl => currentUser?.photoURL;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await _createOrUpdateProfile(user);
      }

      return user;
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      return null;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }

  /// Create or update user profile on first sign-in
  Future<void> _createOrUpdateProfile(User user) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      // Create new profile with Google display name
      final profile = UserProfile(
        userId: user.uid,
        displayName: user.displayName ?? 'Player',
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
      );
      await docRef.set(profile.toFirestore());
    }
  }

  /// Get user profile from Firestore
  Future<UserProfile?> getUserProfile() async {
    if (!isSignedIn) return null;

    try {
      final doc =
          await _firestore.collection('users').doc(currentUser!.uid).get();
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      debugPrint('Get user profile error: $e');
      return null;
    }
  }

  /// Update display name (custom nickname)
  Future<bool> updateDisplayName(String newName) async {
    if (!isSignedIn) return false;

    try {
      await _firestore.collection('users').doc(currentUser!.uid).update({
        'displayName': newName,
      });

      // Also update rankings displayName if exists
      final rankingDoc =
          await _firestore.collection('rankings').doc(currentUser!.uid).get();
      if (rankingDoc.exists) {
        await _firestore.collection('rankings').doc(currentUser!.uid).update({
          'displayName': newName,
        });
      }

      return true;
    } catch (e) {
      debugPrint('Update display name error: $e');
      return false;
    }
  }

  /// Get current display name (from profile or Google)
  Future<String> getCurrentDisplayName() async {
    final profile = await getUserProfile();
    return profile?.displayName ?? displayName ?? 'Player';
  }
}

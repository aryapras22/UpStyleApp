import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthServices extends StateNotifier<Map<String, String>> {
  AuthServices() : super({});
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register user
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phone,
    String? address,
    String? imageUrl,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Save additional data to Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'name': name,
          'role': role,
          'phone': phone ?? '',
          'address': address ?? '',
          'imageUrl': imageUrl ?? 'assets',
        });
        await user.updateDisplayName(name);
        await user.updatePhotoURL(imageUrl);

        // Update state
        state = {
          'uid': user.uid,
          'email': email,
          'name': name,
          'role': role,
          'phone': phone ?? '',
          'address': address ?? '',
          'imageUrl': imageUrl ?? 'assets',
        };
      }
    } on FirebaseAuthException catch (e) {
      print('Error registering user: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error registering user: $e');
      rethrow;
    }
  }

  // Login user
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Get additional data from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Update state
        state = {
          'uid': user.uid,
          'email': user.email!,
          'name': userData['name'],
          'role': userData['role'],
          'phone': userData['phone'],
          'address': userData['address'],
          'imageUrl': userData['imageUrl'],
        };
      }
    } on FirebaseAuthException catch (e) {
      print('Error logging in user: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error logging in user: $e');
      rethrow;
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      // Clear state
      state = {};
    } catch (e) {
      print('Error logging out: $e');
      rethrow;
    }
  }

  // Get current user
  Map<String, String>? getCurrentUser() {
    return state.isNotEmpty ? state : null;
  }

  // Update profile
  Future<void> updateProfile({
    required String uid,
    required String name,
    required String phone,
    required String address,
    String? imageUrl,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'name': name,
        'phone': phone,
        'address': address,
        if (imageUrl != null) 'imageUrl': imageUrl,
      });

      // Update state
      state = {
        ...state,
        'name': name,
        'phone': phone,
        'address': address,
        if (imageUrl != null) 'imageUrl': imageUrl,
      };
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }
}

final authServicesProvider =
    StateNotifierProvider<AuthServices, Map<String, String>>((ref) {
  return AuthServices();
});

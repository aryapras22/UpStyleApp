import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upstyleapp/model/user_model.dart';

class AuthServices extends StateNotifier<UserModel?> {
  AuthServices() : super(null);
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
      UserModel customer = UserModel(
        name: name,
        email: email,
        role: role,
        phone: phone,
        address: address,
        imageUrl: imageUrl,
      );

      if (user != null) {
        // Save additional data to Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'name': name,
          'role': role,
          'phone': phone ?? '',
          'address': address ?? '',
          'imageUrl': imageUrl ?? 'assets/images/photo.png',
        });

        // Update state
        state = customer;
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
        UserModel userModel = UserModel(
            email: email,
            name: userData['name'],
            role: userData['role'],
            phone: userData['phone'],
            address: userData['address'],
            imageUrl: userData['imageUrl']);

        // Update state
        state = userModel;
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
      state = null;
    } catch (e) {
      print('Error logging out: $e');
      rethrow;
    }
  }

  // Get current user
  Future<void> setCurrentUser() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        // Get additional data from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        UserModel userModel = UserModel.fromJson(userData);

        // Update state
        state = userModel;
      }
    } catch (e) {
      print('Error getting current user: $e');
      rethrow;
    }
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
      state = UserModel(
        name: name,
        email: state!.email,
        role: state!.role,
        phone: phone,
        address: address,
        imageUrl: imageUrl,
      );
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }
}

final authServicesProvider =
    StateNotifierProvider<AuthServices, UserModel?>((ref) {
  return AuthServices();
});

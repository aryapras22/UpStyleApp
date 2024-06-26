import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:upstyleapp/screen/auth_screen.dart';

class AuthServices {
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
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
      if (user!.emailVerified) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'name': name,
          'role': role,
          'phone': phone ?? '',
          'address': address ?? '',
          'imageUrl': imageUrl ?? '',
        });
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
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
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
      await GoogleSignIn().signOut();
    } catch (e) {
      print('Error logging out: $e');
      rethrow;
    }
  }

  Future<void> logoutWithContext(BuildContext context) async {
    try {
      await _firebaseAuth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen()),
      );
    } catch (e) {
      print('Error logging out: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
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
        'imageUrl': imageUrl ?? '',
      });
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }
}

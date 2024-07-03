import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upstyleapp/screen/auth_screen.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendEmailVerificationLink() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } catch (e) {
      print('Error sending email verification link: $e');
      rethrow;
    }
  }

  // Register user
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('Error registering user: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error registering user: $e');
      rethrow;
    }
  }

  Future<void> addUserToFirestore({
    required String uid,
    required String email,
    required String name,
    required String role,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'name': name,
        'role': role, // Example role
        'phone': '',
        'address': '',
        'imageUrl': '',
      });
    } catch (e) {
      print('Error adding user to Firestore: $e');
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

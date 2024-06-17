// auth_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upstyleapp/providers/auth_providers.dart';
import 'package:upstyleapp/screen/dashboard_screen.dart';
import 'package:upstyleapp/screen/welcome_screen.dart';

class AuthScreen extends ConsumerWidget {
  AuthScreen({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            // User not logged in, send them to LoginScreen
            return const WelcomeScreen();
          } else {
            // User is logged in, get user data from Firestore and update state
            final userCredential = snapshot.data;
            FirebaseFirestore.instance
                .collection('users')
                .doc(userCredential!.uid)
                .get()
                .then((userData) {
              if (userData.exists) {
                final data = userData.data()!;
                ref.watch(userProfileProvider.notifier).setUser(
                      name: data['name'],
                      email: data['email'],
                      role: data['role'],
                      phone: data['phone'],
                      address: data['address'],
                      imageUrl: data['imageUrl'],
                    );
              }
            });
            // User is logged in, send them to DashboardScreen
            return  DashboardScreen();
          }
        }
        // While connection state is not active, show loading spinner
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

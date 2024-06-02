import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upstyleapp/screen/dashboard_screen.dart';
import 'package:upstyleapp/screen/welcome_screen.dart';
import 'package:upstyleapp/services/auth_services.dart';

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
            final userCredential = snapshot.data;
            FirebaseFirestore.instance
                .collection('users')
                .doc(userCredential!.uid)
                .get()
                .then((userData) {
              var userData =
                  ref.read(authServicesProvider.notifier).setCurrentUser();
            });
            // User is logged in, send them to DashboardScreen
            return const DashboardScreen();
          }
        }
        // While connection state is not active, show loading spinner
        return const CircularProgressIndicator();
      },
    );
  }
}

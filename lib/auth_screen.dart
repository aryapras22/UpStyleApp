import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:upstyle/dashboard_screen.dart';
import 'package:upstyle/login_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            // User not logged in, send them to LoginScreen
            return LoginScreen();
          } else {
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

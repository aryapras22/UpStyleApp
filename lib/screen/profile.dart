import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upstyleapp/services/auth_services.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  AuthServices _authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Profile'),
            // logout button
            ElevatedButton(
              onPressed: () {
                _authServices.logout();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

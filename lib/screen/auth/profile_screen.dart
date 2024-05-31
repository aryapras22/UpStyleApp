// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:upstyleapp/screen/auth/edit_profile_screen.dart';
import 'package:upstyleapp/services/auth_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upstyleapp/widgets/profile_option.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authServices = ref.read(authServicesProvider.notifier);
    final user = ref.watch(authServicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: user['imageUrl'] != null
                            ? NetworkImage(user['imageUrl']!)
                            : const AssetImage('assets/images/photo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'] ?? 'Name not set',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        user['email'] ?? 'user@example.com',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          );
                        },
                        child: const Text('Edit Profile'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ProfileOption(
              icon: Icons.favorite_border,
              text: 'Favorites',
              onTap: () {},
            ),
            ProfileOption(
              icon: Icons.notifications_outlined,
              text: 'Notification',
              onTap: () {},
            ),
            ProfileOption(
              icon: Icons.security,
              text: 'Security Policy',
              onTap: () {},
            ),
            ProfileOption(
              icon: Icons.help_outline,
              text: 'Help Center',
              onTap: () {},
            ),
            ProfileOption(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () {
                authServices.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}

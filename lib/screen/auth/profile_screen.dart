import 'package:flutter/material.dart';
import 'package:upstyleapp/providers/auth_providers.dart';
import 'package:upstyleapp/screen/auth/edit_profile_screen.dart';
import 'package:upstyleapp/screen/auth/favorites_screen.dart';
import 'package:upstyleapp/screen/auth/my_gallery_screen.dart';
import 'package:upstyleapp/services/auth_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upstyleapp/widgets/profile_option.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authServices = AuthServices();
    final user = ref.watch(userProfileProvider);
    final size = MediaQuery.of(context).size;
    final padding = EdgeInsets.symmetric(
      horizontal: size.width * 0.05,
      vertical: size.height * 0.05,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: padding,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: user.imageUrl != ''
                            ? NetworkImage(user.imageUrl!)
                            : const AssetImage('assets/images/photo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ProfileOption(
              icon: Icons.filter,
              text: 'My Gallery',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyGalleryScreen(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ProfileOption(
              icon: Icons.favorite_border,
              text: 'Favorites',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              ),
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
                authServices.logoutWithContext(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:upstyleapp/services/post_service.dart';
import 'package:upstyleapp/widgets/post_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PostService postService = PostService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: postService.getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No Favorites',
                style: TextStyle(
                  fontFamily: "ProductSansMedium",
                  fontSize: 20.0,
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
              child: ListView(
                children: [
                  for (var post in snapshot.data!.docs)
                    PostCard(
                      isHome: false,
                      post: post.data(),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

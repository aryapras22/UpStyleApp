import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upstyleapp/model/post.dart';
import 'package:upstyleapp/services/post_service.dart';
import 'package:upstyleapp/widgets/post_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final PostService postService = PostService();
  final List<Post> posts = [];
  bool isLoading = true;

  Future<void> fetchData() async {
    var allPost = await postService.getFavorites();
    String name = '';
    String avatar = '';

    for (var doc in allPost.docs) {
      var value = await postService.getUserData(doc['user_id']);
      name = value['name'] ?? 'Anonymous';
      avatar = value['imageUrl'] ?? '';
      posts.add(
        Post(
          id: doc.id,
          name: name,
          userAvatar: avatar,
          postImage: doc['image_url'],
          caption: doc['text'],
          time: doc['created_at'].toString(),
          userId: doc['user_id'],
          favorites: doc['favorites'],
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (posts.isEmpty) {
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
                  for (var post in posts)
                    PostCard(
                      isClickable: true,
                      post: post,
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

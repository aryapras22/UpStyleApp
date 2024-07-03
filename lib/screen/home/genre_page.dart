// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:upstyleapp/model/post.dart';
import 'package:upstyleapp/services/post_service.dart';
import 'package:upstyleapp/widgets/post_card.dart';

class GenrePage extends StatefulWidget {
  final String genre;
  const GenrePage({super.key, required this.genre});

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  bool isLoading = true;
  final _postService = PostService();
  List<Post> posts = [];
  List<Post> searchPosts = [];

  String name = '';
  String avatar = '';

  void fetchPosts() async {
    setState(() {
      posts.clear();
    });
    final allPost =
        await _postService.searchByGenre(widget.genre.toLowerCase());
    setState(() {
      isLoading = false;
    });

    for (var doc in allPost) {
      var value = await _postService.getUserData(doc['user_id']);
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
    fetchPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Genre'),
      ),
      body: ListView(
        children: [
          isLoading
              ? Container(
                  alignment: Alignment.center,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      for (var post in posts)
                        PostCard(
                          isClickable: true,
                          post: post,
                        ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

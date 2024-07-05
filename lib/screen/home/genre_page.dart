// ignore_for_file: prefer_const_constructors
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/material.dart';
import 'package:upstyleapp/model/post.dart';
import 'package:upstyleapp/services/post_service.dart';
import 'package:upstyleapp/widgets/post_card.dart';
import 'package:upstyleapp/services/algolia_search.dart' as algolia;

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
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    algolia.postsSearcher.query(widget.genre);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Genre: ${widget.genre}'),
      ),
      body: ListView(
        children: [
          StreamBuilder<SearchResponse>(
              stream: algolia.postsSearcher.responses,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final posts = snapshot.data!.hits;
                  if (posts.isEmpty) {
                    return Container(
                      alignment: Alignment.center,
                      child: Center(
                        child: Text('No posts found'),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      var value =
                          _postService.getUserData(posts[index]['user_id']);
                      value.then((value) {
                        name = value['name'];
                        avatar = value['avatar'];
                      });
                      final post = Post(
                        id: posts[index]['objectID'],
                        caption: posts[index]['text'],
                        postImage: posts[index]['image_url'],
                        time: posts[index]['created_at'].toString(),
                        favorites: posts[index]['favorites'],
                        userAvatar: avatar,
                        name: name,
                        userId: posts[index]['user_id'],
                      );

                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: PostCard(
                          post: post,
                          isClickable: true,
                        ),
                      );
                    },
                  );
                }
                return Container();
              }),
        ],
      ),
    );
  }
}

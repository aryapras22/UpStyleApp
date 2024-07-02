import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upstyleapp/model/post.dart';
import 'package:upstyleapp/providers/auth_providers.dart';
import 'package:upstyleapp/services/post_service.dart';
import 'package:upstyleapp/widgets/post_card.dart';

class MyGalleryScreen extends ConsumerStatefulWidget {
  const MyGalleryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyGalleryScreenState();
}

class _MyGalleryScreenState extends ConsumerState<MyGalleryScreen> {
  final PostService postService = PostService();
  final List<Post> posts = [];
  bool isLoading = true;

  Future<void> fetchData() async {
    var allPost = await postService.getUserPosts();
    for (var doc in allPost.docs) {
      posts.add(
        Post(
          id: doc.id,
          name: ref.read(userProfileProvider).name,
          userAvatar: ref.read(userProfileProvider).imageUrl ?? '',
          postImage: doc.data()['image_url'],
          caption: doc.data()['text'],
          time: doc.data()['created_at'].toString(),
          userId: FirebaseAuth.instance.currentUser!.uid,
          favorites: doc.data()['favorites'],
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
        title: const Text('My Gallery'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Center(
                child: Consumer(
                  builder: (context, ref, child) {
                    final user = ref.watch(userProfileProvider);
                    return Container(
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
                    );
                  },
                ),
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Center(
                    child: Text(
                      ref.watch(userProfileProvider).name,
                      style: const TextStyle(
                        fontFamily: "ProductSansMedium",
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "My Post",
                  style: TextStyle(
                    fontFamily: "ProductSansMedium",
                    fontSize: 25.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Builder(
              builder: (context) {
                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (posts.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Post',
                      style: TextStyle(
                        fontFamily: "ProductSansMedium",
                        fontSize: 20.0,
                      ),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      for (var post in posts)
                        PostCard(
                          post: post,
                          isClickable: false,
                        ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

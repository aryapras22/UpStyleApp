import 'package:flutter/material.dart';
import 'package:upstyleapp/services/post_service.dart';
import 'package:upstyleapp/widgets/post_card.dart';

class MyGalleryScreen extends StatelessWidget {
  const MyGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();

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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    'assets/images/photo.png',
                    height: 110,
                    width: 110,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Center(
                child: Text(
                  "Ali Ahmad Fahrezy",
                  style: TextStyle(
                    fontFamily: "ProductSansMedium",
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Text('Edit Profile'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: RichText(
                text: const TextSpan(
                  text:
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontFamily: "ProductSansMedium",
                  ),
                ),
              ),
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
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: _postService.getUserPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
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
                      for (var post in snapshot.data!.docs)
                        PostCard(
                          post: post.data(),
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

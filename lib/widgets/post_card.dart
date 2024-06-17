// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:upstyleapp/model/post.dart';
import 'package:upstyleapp/screen/home/profile_detail.dart';

class PostCard extends StatelessWidget {
  final Post post;
  bool isFavorite = true;

  PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shadowColor: Theme.of(context).shadowColor,
      margin: EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              post.postImage,
              fit: BoxFit.fill,
              width: double.infinity,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // replace with your profile screen

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileDetail(userId: post.userId),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(post.userAvatar),
                        // replace with your avatar URL
                      ),
                      SizedBox(width: 10),
                      Text(
                        post.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              post.caption,
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 10),
            // replace with your post image URL
          ],
        ),
      ),
    );
  }
}

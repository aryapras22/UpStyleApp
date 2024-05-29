// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
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
            Image.asset(
              'assets/images/post_photo.png',
              fit: BoxFit.fill,
              width: double.infinity,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: Image.asset('assets/images/post_avatar.png')
                      .image, // replace with your avatar URL
                ),
                SizedBox(width: 10),
                Text('Dante Pratama'),
                Spacer(),
                Icon(Icons.favorite_border),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
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

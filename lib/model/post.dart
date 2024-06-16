import 'package:flutter/material.dart';

class Post with ChangeNotifier {
  String id;
  String name;
  String userAvatar;
  String postImage;
  String caption;
  String time;
  String userId;

  

  Post({
    required this.id,
    required this.name,
    required this.userAvatar,
    required this.postImage,
    required this.caption,
    required this.time,
    required this.userId,
  });

  factory Post.fromMap(Map<String, dynamic> data) {
    return Post(
      id: data['id'],
      name: data['name'],
      userAvatar: data['userAvatar'],
      postImage: data['postImage'],
      caption: data['caption'],
      time: data['time'],
      userId: data['userId'],
    );
  }

  // get posts
}

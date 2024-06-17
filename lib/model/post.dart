import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

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

  factory Post.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> data,
    SnapshotOptions? options,
  ) {
    return Post(
      id: data.id,
      name: '',
      userAvatar: '',
      postImage: data.data()!['image_url'],
      caption: data.data()!['text'],
      time: data.data()!['created_at'].toString(),
      userId: FirebaseAuth.instance.currentUser!.uid,
    );
  }

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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userAvatar': userAvatar,
      'postImage': postImage,
      'caption': caption,
      'time': time,
      'userId': userId,
    };
  }
}

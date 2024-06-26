import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Post with ChangeNotifier {
  final String id;
  final String name;
  final String userAvatar;
  final String postImage;
  final String caption;
  final String time;
  final String userId;
  List favorites;

  Post({
    required this.id,
    required this.name,
    required this.userAvatar,
    required this.postImage,
    required this.caption,
    required this.time,
    required this.userId,
    this.favorites = const [],
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
      favorites: data.data()!['favorites'] ?? [],
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
      favorites: data['favorites'] ?? [],
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
      'favorites': favorites,
    };
  }
}

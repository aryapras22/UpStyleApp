import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  static fromDocument(DocumentSnapshot<Object?> doc) {
    return Post(
      id: doc['id'],
      name: doc['name'],
      userAvatar: doc['userAvatar'],
      postImage: doc['postImage'],
      caption: doc['caption'],
      time: doc['time'],
      userId: doc['userId'],
      favorites: doc['favorites'],
    );
  }

}

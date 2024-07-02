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
}

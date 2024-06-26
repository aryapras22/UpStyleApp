// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upstyleapp/model/post.dart';
import 'package:upstyleapp/screen/home/profile_detail.dart';
import 'package:upstyleapp/services/post_service.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final bool isHome;

  PostCard({required this.post, required this.isHome});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  bool isFavorite = false;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 80, end: 120).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  void _animate() {
    _animationController.reset();
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 1000), () {
      _animationController.reverse();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  PostService postService = PostService();

  @override
  Widget build(BuildContext context) {
    isFavorite = widget.post.favorites.contains(postService.getCurrentUserId());
    print(isFavorite);
    return Card(
      color: Colors.white,
      shadowColor: Theme.of(context).shadowColor,
      margin: EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onDoubleTap: () {
                _animate();
                if (isFavorite) {
                  setState(() {
                    isFavorite = false;
                  });
                  // remove from favorites lists
                  widget.post.favorites.remove(postService.getCurrentUserId());
                  postService.unfavoritePost(widget.post.id);
                } else if (!isFavorite) {
                  setState(() {
                    isFavorite = true;
                  });
                  widget.post.favorites.add(postService.getCurrentUserId());
                  postService.favoritePost(widget.post.id);
                }
              },
              child: Stack(alignment: Alignment.center, children: [
                Image.network(
                  widget.post.postImage,
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: Icon(
                        CupertinoIcons.heart_fill,
                        size: _scaleAnimation.value,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                ),
              ]),
            ),

            SizedBox(height: 10),
            widget.isHome
                ? Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileDetail(userId: widget.post.userId),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage(widget.post.userAvatar),
                              // replace with your avatar URL
                            ),
                            SizedBox(width: 10),
                            Text(
                              widget.post.name,
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
                  )
                : Container(),
            SizedBox(height: 10),
            widget.isHome
                ? Text(
                    widget.post.caption,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  )
                : Row(
                    children: [
                      Text(
                        widget.post.caption,
                        style: TextStyle(
                          color: Colors.grey[700],
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
            // replace with your post image URL
          ],
        ),
      ),
    );
  }
}

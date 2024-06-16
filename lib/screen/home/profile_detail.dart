// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:upstyleapp/screen/chat/chat_page.dart';
import 'package:upstyleapp/services/auth_services.dart';
import 'package:upstyleapp/services/chat_service.dart';
import 'package:upstyleapp/services/post_service.dart';
import 'package:upstyleapp/widgets/post_card.dart';

class ProfileDetail extends StatefulWidget {
  final String userId;

  const ProfileDetail({super.key, required this.userId});

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  ChatService chatService = ChatService();
  AuthServices authServices = AuthServices();
  PostService postService = PostService();

  String name = '';
  types.User? otherUser;

  void getUser() async {
    await postService.getUserData(widget.userId).then((value) {
      setState(() {
        name = value['name'];
        otherUser = types.User(id: widget.userId, firstName: name);
      });
    });
  }

  void createChat() async {
    types.Room room = await chatService.createChat(otherUser!, context);
    // route to chat page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(room: room),
      ),
    );
  }

  Widget statusBox(String status, String value, double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary,
              spreadRadius: 0,
              blurRadius: 0,
              offset: Offset(-3, 0),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(status),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Profile Designer'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    'assets/images/post_photo.png',
                    height: 176.0 * 1.25,
                    width: 300.0 * 1.25,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  statusBox("Orders", "34.2k", 80, 60),
                  statusBox("Photos", "851", 80, 60),
                  statusBox("Likes", "947", 80, 60),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/post_avatar.png'),
                    // replace with your avatar URL
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Ali Ahmad Fahrezy",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
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
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "Review",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: Row(
                children: [
                  RatingStars(
                    value: 5.0,
                    starCount: 5,
                    starSize: 12,
                    valueLabelColor: Theme.of(context).colorScheme.surface,
                    valueLabelTextStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 24.0),
                    valueLabelRadius: 0,
                    maxValue: 5,
                    starSpacing: 2,
                    maxValueVisibility: false,
                    valueLabelVisibility: true,
                    animationDuration: Duration(milliseconds: 1000),
                    valueLabelPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    valueLabelMargin: const EdgeInsets.only(right: 8),
                    starOffColor: const Color(0xffe7e8ea),
                    starColor: Theme.of(context).colorScheme.primary,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "(1 ulasan)",
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "Portofolio",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
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

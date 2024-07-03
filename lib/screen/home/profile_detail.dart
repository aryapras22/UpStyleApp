// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upstyleapp/model/post.dart';
import 'package:upstyleapp/model/user_model.dart';
import 'package:upstyleapp/providers/auth_providers.dart';
import 'package:upstyleapp/screen/chat/chat_page.dart';
import 'package:upstyleapp/services/auth_services.dart';
import 'package:upstyleapp/services/chat_service.dart';
import 'package:upstyleapp/services/post_service.dart';
import 'package:upstyleapp/widgets/post_card.dart';

class ProfileDetail extends ConsumerStatefulWidget {
  final String userId;

  const ProfileDetail({super.key, required this.userId});

  @override
  ConsumerState<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends ConsumerState<ProfileDetail> {
  ChatService chatService = ChatService();
  AuthServices authServices = AuthServices();
  PostService postService = PostService();
  final List<Post> posts = [];
  bool isLoadingChat = false;
  bool isLoadingPosts = true;

  String otherName = '';
  UserModel? user;
  types.User? otherUser;
  String otherRole = '';

  void getUser() async {
    await postService.getUserData(widget.userId).then((value) {
      setState(() {
        otherName = value['name'];
        otherUser = types.User(id: widget.userId, firstName: otherName);
        otherRole = value['role'];
      });
    });
  }

  void createChat() async {
    setState(() {
      isLoadingChat = true;
    });
    types.Room room = await chatService.createChat(otherUser!, context);
    // route to chat page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(room: room),
      ),
    );
    setState(() {
      isLoadingChat = false;
    });
  }

  Future<void> fetchData() async {
    var allPost = await postService.getUserPosts();
    String name = '';
    String avatar = '';

    for (var doc in allPost.docs) {
      var value = await postService.getUserData(widget.userId);
      name = value['name'] ?? 'Anonymous';
      avatar = value['imageUrl'] ?? '';
      posts.add(
        Post(
          id: doc.id,
          name: name,
          userAvatar: avatar,
          postImage: doc['image_url'],
          caption: doc['text'],
          time: doc['created_at'].toString(),
          userId: widget.userId,
          favorites: doc['favorites'],
        ),
      );
    }
    setState(() {
      isLoadingPosts = false;
    });
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
                color: Colors.black,
              ),
            ),
            Text(
              status,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getUser();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    user = ref.watch(userProfileProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Profile Designer'),
        centerTitle: true,
      ),
      bottomSheet: user!.role != otherRole
          ? Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.file_upload_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: ElevatedButton(
                      onPressed: !isLoadingChat
                          ? () {
                              createChat();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !isLoadingChat
                            ? const Color.fromARGB(255, 238, 99, 56)
                            : Colors.grey,
                        minimumSize: Size(double.infinity, 50.0),
                        maximumSize: Size(double.infinity, 50.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: !isLoadingChat
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    Icons.chat,
                                    color: Colors.white,
                                    size: 18.0,
                                  ),
                                ),
                                Text(
                                  "Chat to Order",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                )
                              ],
                            )
                          : Center(
                              child: SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            )
          : null,
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
            /*
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
            */
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
                    otherName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            /*
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "Review",
                style: TextStyle(
                  color: Colors.black,
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
            */
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "Portofolio",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Builder(
              builder: (context) {
                if (isLoadingPosts) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (posts.isEmpty) {
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
                      for (var post in posts)
                        PostCard(
                          post: post,
                          isClickable: false,
                        ),
                      SizedBox(height: 50.0)
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

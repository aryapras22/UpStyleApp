// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:upstyleapp/model/user.dart';
import 'package:upstyleapp/screen/chat/chat_page.dart';
import 'package:upstyleapp/services/auth_services.dart';
import 'package:upstyleapp/services/chat_service.dart';
import 'package:upstyleapp/services/post_service.dart';

class ProfileDetail extends StatefulWidget {
  final String userId;

  ProfileDetail({super.key, required this.userId});

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

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://via.placeholder.com/300', // replace with your image URL
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            '34.2k',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Text('Orders'),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '851',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Text('Photos'),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '947',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Text('Likes'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name == '' ? 'loading...' : name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Text('Norway'),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          createChat();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child:
                            Text('Chat', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Photos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        5,
                        (index) => Container(
                          margin: EdgeInsets.only(right: 10),
                          width: 100,
                          height: 100,
                          color: Colors.grey[300],
                          child: Image.network(
                            'https://via.placeholder.com/100', // replace with your image URL
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'About',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                    'Vestibulum luctus nulla eget volutpat sollicitudin. Nullam vel orci nisl.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

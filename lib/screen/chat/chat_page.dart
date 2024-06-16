// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upstyleapp/screen/order/order_form.dart';
import 'package:upstyleapp/services/chat_service.dart';
import 'package:upstyleapp/services/post_service.dart';

class ChatPage extends StatefulWidget {
  final types.Room room;
  ChatPage({super.key, required this.room});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  var _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  File? _image;
  final ImagePicker _picker = ImagePicker();

  final ChatService chatService = ChatService();

  // ger current user
  final User? user = FirebaseAuth.instance.currentUser;
  types.PartialImage imageMessage = types.PartialImage(
    name: 'image',
    uri: 'image',
    size: 0,
  );
  types.User? otherUser;

  PostService postService = PostService();
  String name = '';
  String imgUrl = '';
  String latestChat = '';
  String latestChatTime = '';
  Map<String, dynamic> latestChatAndTime = {};
  String otherUserId = '';

  void getUser() async {
    await chatService.getOtherUsername(widget.room.id).then((value) {
      postService.getUserData(value).then((value) {
        setState(() {
          name = value['name'];
          imgUrl = value['imageUrl'];
          otherUserId = value.id;
        });
      });
    });
  }

  // _user = types.User(id: user!.uid, firstName: user!.displayName!);
  @override
  void initState() {
    _user = types.User(id: user!.uid, firstName: user!.displayName!);
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                // Add your back button action here
                Navigator.pop(context);
              },
            ),
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage: imgUrl == ''
                      ? AssetImage('assets/images/post_avatar.png')
                      : NetworkImage(imgUrl), // Replace with your image URL
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name == '' ? 'User' : name,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 12),
                        SizedBox(width: 4),
                        Text(
                          'Online',
                          style: TextStyle(color: Colors.green, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.file_copy, color: Colors.black),
                onPressed: () {
                  // send an order to user
                  // send an chat form
                  
                },
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.black),
                onPressed: () {
                  // Add your more options button action here
                },
              ),
            ],
          ),
          body: StreamBuilder<List<types.Message>>(
              stream: chatService.getMessages(widget.room),
              initialData: [],
              builder: (context, snapshot) {
                _messages = snapshot.data ?? [];
                return Chat(
                  theme: DefaultChatTheme(
                      inputBackgroundColor: Colors.white,
                      inputTextColor: Colors.black,
                      primaryColor: Theme.of(context).colorScheme.primary,
                      secondaryColor: Theme.of(context).colorScheme.secondary,
                      sendButtonIcon: Icon(Icons.send,
                          color: Theme.of(context).colorScheme.primary),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      attachmentButtonIcon:
                          Image.asset('assets/icons/document.png'),
                      inputPadding: EdgeInsets.all(4),
                      inputMargin: EdgeInsets.only(top: 2, right: 4, left: 4),
                      inputBorderRadius: BorderRadius.zero,
                      inputTextDecoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type a message',
                        hintStyle: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.bodySmall!.fontFamily,
                          color: Colors.grey,
                        ),
                      ),
                      inputTextStyle: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.bodySmall!.fontFamily,
                          fontSize: 16,
                          color: Colors.black)),
                  messages: _messages,
                  onSendPressed: _handleSendPressed,
                  user: _user,
                  onAttachmentPressed: _handleImageSelection,
                );
              }),
        ),
      );

  void _handleSendPressed(message) {
    chatService.sendMessage(message, widget.room);
  }

  void _handleImageSelection() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Center(
              child: Row(
                children: [
                  Text('Upload your image ',
                      style: Theme.of(context).textTheme.titleLarge!),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    onTap: () async {
                      final pickedFile = await _picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 70,
                        maxWidth: 1440,
                      );

                      if (pickedFile != null) {
                        // final bytes = await pickedFile.readAsBytes();
                        // final _image = File(pickedFile.path);

                        // imageMessage = types.PartialImage(
                        //   name: pickedFile.name,
                        //   size: bytes.length,
                        //   uri: pickedFile.path,
                        // );
                      }
                      setState(() {
                        if (pickedFile != null) {
                          _image = File(pickedFile.path);
                        } else {
                          SnackBar(
                            content: Text('No image selected.'),
                          );
                        }
                      });
                    },
                    child: _image == null
                        ? DottedBorder(
                            borderType: BorderType.RRect,
                            color: Theme.of(context).colorScheme.primary,
                            dashPattern: [6, 3],
                            strokeWidth: 2,
                            radius: Radius.circular(10),
                            child: SizedBox(
                              width: 500,
                              height: 300,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                        'assets/icons/upload_active.png'),
                                    Text(
                                      "Upload your image here",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: SizedBox(
                              width: 500,
                              height: 300,
                              child: Center(
                                child: Ink.image(
                                  image: Image.file(_image!).image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_image == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please select an image.'),
                      ));
                      return;
                    }

                    bool isLoading = true;
                    chatService.sendImage(widget.room, _image!).then(
                      (value) {
                        isLoading = value;
                      },
                    );
                    if (isLoading == true) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Uploading image...'),
                      ));
                    }
                    // clear
                    _image = null;
                    Navigator.of(context).pop();
                    // pop up success message with picture
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                      child: Text('Upload',
                          style: TextStyle(color: Colors.white))),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

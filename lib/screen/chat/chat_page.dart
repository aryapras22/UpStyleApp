// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');

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
                  backgroundImage: NetworkImage(
                      'https://example.com/profile.jpg'), // Replace with your image URL
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dante Pratama',
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
                icon: Icon(Icons.call, color: Colors.black),
                onPressed: () {
                  // Add your call button action here
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
          body: Chat(
            theme: DefaultChatTheme(
                inputBackgroundColor: Colors.white,
                inputTextColor: Colors.black,
                primaryColor: Theme.of(context).colorScheme.primary,
                secondaryColor: Theme.of(context).colorScheme.secondary,
                sendButtonIcon: Icon(Icons.send,
                    color: Theme.of(context).colorScheme.primary),
                backgroundColor: Theme.of(context).colorScheme.surface,
                attachmentButtonIcon: Image.asset('assets/icons/document.png'),
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
          ),
        ),
      );

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  // Widget _buildImageMessage(types.ImageMessage message,
  //     {required int messageWidth}) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       border: Border.all(
  //         color: Colors.red, // Set your desired border color here
  //         width: 2.0, // Set your desired border width here
  //       ),
  //       borderRadius:
  //           BorderRadius.circular(10.0), // Set your desired border radius here
  //     ),
  //     child: Image.network(
  //       message.uri,
  //       width: message.width,
  //       height: message.height,
  //       fit: BoxFit.cover,
  //     ),
  //   );
  // }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );
    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4.toString(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }
}

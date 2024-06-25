// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:upstyleapp/screen/chat/chat_page.dart';
import 'package:upstyleapp/services/chat_service.dart';
import 'package:upstyleapp/services/post_service.dart';

class ChatRoomTile extends StatefulWidget {
  final types.Room room;
  const ChatRoomTile({super.key, required this.room});

  @override
  State<ChatRoomTile> createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
  ChatService chatService = ChatService();
  PostService postService = PostService();
  String name = '';
  String imgUrl = '';
  String latestChat = '';
  String latestChatTime = '';
  Map<String, dynamic> latestChatAndTime = {};
  final AssetImage defaultImage = AssetImage('assets/images/post_avatar.png');

  void getUser() async {
    if (widget.room.users[0].id == await chatService.getCurrentUser()) {
      postService.getUserData(widget.room.users[1].id).then((value) {
        setState(() {
          name = value['name'];
          imgUrl = value['imageUrl'];
        });
      });
    } else {
      postService.getUserData(widget.room.users[0].id).then((value) {
        setState(() {
          name = value['name'];
          imgUrl = value['imageUrl'];
        });
      });
    }

    DateTime time = DateTime.fromMillisecondsSinceEpoch(widget.room.updatedAt!);
    await chatService.getLatestChat(widget.room).then(
      (value) {
        setState(() {
          
          latestChat = value;
          // if time is more than 12 hours, show date
          if (DateTime.now().difference(time).inHours > 12) {
            latestChatTime = '${time.day}/${time.month}';
          } else {
            latestChatTime = '${time.hour}:${time.minute}';
          }
        });
      },
    );
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, top: 10, right: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          ),
        ),
      ),
      child: ListTile(
        title: Row(
          children: [
            Text(
              name == ''
                  ? 'Username'
                  : (name.length > 15 ? '${name.substring(0, 15)}...' : name),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Spacer(),
            Text(
              latestChatTime == '' ? 'Time' : latestChatTime,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Text(latestChat == '' ? '' : latestChat,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                    )),
            Spacer(),
            // CircleAvatar(
            //   radius: 10,
            //   backgroundColor: Theme.of(context).colorScheme.primary,
            //   child: Text(
            //     '',
            //     style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            //           color: Colors.white,
            //           fontWeight: FontWeight.w500,
            //         ),
            //   ),
            // ),
          ],
        ),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: imgUrl == '' ? defaultImage : NetworkImage(imgUrl),
        ),
        onTap: () {
          // open chat
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                room: widget.room,
              ),
            ),
          );
        },
      ),
    );
  }
}

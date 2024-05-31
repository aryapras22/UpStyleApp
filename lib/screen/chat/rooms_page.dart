// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:upstyleapp/services/chat_service.dart';
import 'package:upstyleapp/widgets/chat_room_tile.dart';

class RoomsPage extends StatelessWidget {
  RoomsPage({super.key});

  ChatService chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(child: Text('Chats')),
      ),
      body: StreamBuilder(
        stream: ChatService().getRooms(),
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final rooms = snapshot.data;
          return ListView.builder(
            itemCount: rooms!.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              return ChatRoomTile(room: room);
            },
          );
        },
      ),
    );
  }
}

// Column(
//         children: [
//           ChatRoomTile(),
//           ChatRoomTile(),
//           ChatRoomTile(),
//           ChatRoomTile(),
//         ],
//       ),
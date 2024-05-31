// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:upstyleapp/widgets/chat_room_tile.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(child: Text('Chats')),
      ),
      body: Column(
        children: [
          ChatRoomTile(),
          ChatRoomTile(),
          ChatRoomTile(),
          ChatRoomTile(),
        ],
      ),
    );
  }
}

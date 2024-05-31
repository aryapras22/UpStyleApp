// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:upstyleapp/screen/chat/chat_page.dart';

class ChatRoomTile extends StatelessWidget {
  const ChatRoomTile({super.key});

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
              'Dante Pratama',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Spacer(),
            Text(
              '10:00',
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
            Text('done sir',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                    )),
            Spacer(),
            CircleAvatar(
              radius: 10,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                '2',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('assets/images/post_avatar.png'),
        ),
        onTap: () {
          // open chat
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(),
            ),
          );
        },
      ),
    );
  }
}

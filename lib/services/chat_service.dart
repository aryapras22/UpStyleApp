// ignore_for_file: use_rethrow_when_possible

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  var uuid = const Uuid();

  // create a chat
  void createChat(types.User otherUser, BuildContext context) async {
    final room = await FirebaseChatCore.instance.createRoom(otherUser);
  }

  // get user rooms
  Stream<List<types.Room>> getRooms() {
    try {
      return FirebaseChatCore.instance.rooms();
    } on Exception catch (e) {
      throw e;
    }
  }

  // get messages of a room
  Stream<List<types.Message>> getMessages(types.Room roomId) {
    try {
      return FirebaseChatCore.instance.messages(roomId);
    } on Exception catch (e) {
      throw e;
    }
  }

  // send message
  void sendMessage(types.Room room, types.PartialText message) {
    try {
      FirebaseChatCore.instance.sendMessage(room, message.text);
    } on Exception catch (e) {
      throw e;
    }
  }

  // upload image
  Future<void> sendImage(File file, types.Room room) async {
    String url = '';
    try {
      final storageRef = _storage.ref();
      final imageRef = storageRef
          .child('chatrooms')
          .child(room.id)
          .child('${uuid.v4()}.png');
      final imageBytes = await file.readAsBytes();
      await imageRef.putData(imageBytes);
      await imageRef.getDownloadURL().then((value) => url = value);
    } on Exception catch (e) {
      throw e;
    }
  }

  // get chat room id
  // String getChatRoomId(String uidUser, String uidDesigner) {
  //   if (uidUser.compareTo(uidDesigner) == 1) {
  //     return '$uidUser-$uidDesigner';
  //   } else {
  //     return '$uidDesigner-$uidUser';
  //   }
  // }

  // // make a chat room id chat between two users using id of two uses
  // void createChatRoom(String uidUser, String uidDesigner) {
  //   String chatRoomId = getChatRoomId(uidUser, uidDesigner);
  //   Map<String, dynamic> chatRoom = {
  //     'user': uidUser,
  //     'designer': uidDesigner,
  //     'chatRoomId': chatRoomId,
  //   };
  //   _firestore.collection('chatRooms').doc(chatRoomId).set(chatRoom);
  // }

  // // send message to chat room
  // void sendMessage(String chatRoomId, String message) {
  //   Map<String, dynamic> messageMap = {
  //     'message': message,
  //     'sendBy': _auth.currentUser!.uid,
  //     'time': DateTime.now().millisecondsSinceEpoch,
  //   };
  //   _firestore
  //       .collection('chatRooms')
  //       .doc(chatRoomId)
  //       .collection('chats')
  //       .add(messageMap);
  // }
}

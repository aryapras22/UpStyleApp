// ignore_for_file: use_rethrow_when_possible
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
  Future<types.Room> createChat(
      types.User otherUser, BuildContext context) async {
    final room = await FirebaseChatCore.instance.createRoom(otherUser);
    _firestore.collection('chatRooms').doc(room.id).set({
      'user': _auth.currentUser!.uid,
      'designer': otherUser.id,
      'chatRoomId': room.id,
    });
    return room;
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
  void sendMessage(message, types.Room room) async {
    try {
      FirebaseChatCore.instance.sendMessage(message, room.id);
    } on Exception catch (e) {
      throw e;
    }
  }

  // upload image
  Future<void> sendImage(message, types.Room room) async {
    print("uploading image");
    FirebaseChatCore.instance.sendMessage(message, room.id);

    FirebaseChatCore.instance.sendMessage(message, room.id);
    // update image uri in firestore
    _firestore
        .collection('rooms')
        .doc(room.id)
        .collection('messages')
        .doc(message.id)
        .update({'imageUri': message.imageUri});
  }

  // get otherUsername from chatRooms collection with input of chatroom id
  Future<String> getOtherUsername(String chatRoomId) async {
    String otherUsername = '';
    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .get()
        .then((value) {
      if (value.data() != null) {
        if (value.data()!['user'] == _auth.currentUser!.uid) {
          otherUsername = value.data()!['designer'];
        } else {
          otherUsername = value.data()!['user'];
        }
      }
    });
    return otherUsername;
  }

  // get latest chat and time
  Future<Map<String, dynamic>> getLatestChat(String chatRoomId) async {
    Map<String, dynamic> latestChatAndTime = {};
    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        latestChatAndTime = {
          'latestChat': value.docs[0].data()['text'],
          'latestChatTime': value.docs[0].data()['timestamp'],
        };
      }
    });
    return latestChatAndTime;
  }
}

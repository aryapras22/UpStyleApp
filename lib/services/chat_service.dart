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
  Future<types.Room> createChat(
      types.User otherUser, BuildContext context) async {
    final room = await FirebaseChatCore.instance.createRoom(otherUser);
    _firestore.collection('chatRooms').doc(room.id).set(
      {
        'user': _auth.currentUser!.uid,
        'designer': otherUser.id,
        'chatRoomId': room.id,
      },
    );
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

  types.PartialImage imageMessage = const types.PartialImage(
    name: 'image',
    uri: 'image',
    size: 0,
  );
  Future<String> getRoomId(desId, custId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("chatRooms")
          .where("designerId", isEqualTo: desId)
          .where("custId", isEqualTo: custId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      }
      return "";
    } catch (e) {
      return e.toString();
    }
  }

  // upload image

  Future<bool> sendImage(types.Room room, File image) async {
    final bytes = await image.readAsBytes();
    final image0 = File(image.path);
    final ref = _storage.ref().child('chatrooms/${room.id}/${uuid.v4()}');
    await ref.putFile(image0);
    final uri = await ref.getDownloadURL();
    imageMessage = types.PartialImage(
      name: image.path.split('/').last,
      size: bytes.length,
      uri: uri.toString(),
    );
    FirebaseChatCore.instance.sendMessage(imageMessage, room.id);
    return false;
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

  // get current user
  Future<String> getCurrentUser() async {
    return _auth.currentUser!.uid;
  }

  // find latest chat from rooms collection usiing room id
  Future<String> getLatestChat(types.Room room) async {
    try {
      final snapshot = await _firestore
          .collection('rooms')
          .doc(room.id)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        if (snapshot.docs[0].data()['type'] == 'image') {
          return 'user send an image';
        }
        if (snapshot.docs[0].data()['type'] == 'custom') {
          return 'user send an order';
        }
        return snapshot.docs[0].data()['text'];
      } else {
        return '';
      }
    } catch (e) {
      throw e;
    }
  }

  // send custom message order to chat
  void sendOrderMessage(
    types.Room room,
    String orderId,
    String orderTitle,
    String orderPrice,
    String orderImageUrl,
  ) async {
    final message = types.PartialCustom(
      metadata: {
        'orderId': orderId,
        'orderTitle': orderTitle,
        'orderPrice': orderPrice,
        'orderImageUrl': orderImageUrl,
      },
    );
    FirebaseChatCore.instance.sendMessage(message, room.id);
  }
}

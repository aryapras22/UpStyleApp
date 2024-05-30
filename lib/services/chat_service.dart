import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  // get chat room id
  String getChatRoomId(String uidUser, String uidDesigner) {
    if (uidUser.compareTo(uidDesigner) == 1) {
      return '$uidUser-$uidDesigner';
    } else {
      return '$uidDesigner-$uidUser';
    }
  }

  // make a chat room id chat between two users using id of two uses
  void createChatRoom(String uidUser, String uidDesigner) {
    String chatRoomId = getChatRoomId(uidUser, uidDesigner);
    Map<String, dynamic> chatRoom = {
      'user': uidUser,
      'designer': uidDesigner,
      'chatRoomId': chatRoomId,
    };
    _firestore.collection('chatRooms').doc(chatRoomId).set(chatRoom);
  }

  // send message to chat room
  void sendMessage(String chatRoomId, String message) {
    Map<String, dynamic> messageMap = {
      'message': message,
      'sendBy': _auth.currentUser!.uid,
      'time': DateTime.now().millisecondsSinceEpoch,
    };
    _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap);
  }
}

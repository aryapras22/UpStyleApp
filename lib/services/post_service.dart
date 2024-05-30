import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  var uuid = const Uuid();

  Future<void> createPost(String text, File file) async {
    String uid = _auth.currentUser!.uid;
    String url = '';
    // String postId = uuid.v4();

    try {
      final storageRef = _storage.ref();
      final imageRef =
          storageRef.child('posts').child(uid).child('${uuid.v4()}.png');
      final imageBytes = await file.readAsBytes();
      await imageRef.putData(imageBytes);
      await imageRef.getDownloadURL().then((value) => url = value);

      DocumentReference ref = await _firestore.collection('posts').add({
        'text': text,
        'image_url': url,
        'user_id': uid,
        'created_at': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('users').doc(uid).collection('posts').add({
        'post_id': ref.id,
        'text': text,
        'image_url': url,
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // read all posts
  Future<List<DocumentSnapshot>> readAllPosts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('posts')
          .orderBy('created_at', descending: true)
          .get();
      return querySnapshot.docs;
    } catch (e) {
      rethrow;
    }
  }

  // get user name and avatar by user id
  Future<DocumentSnapshot> getUserData(String userId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(userId).get();
      return documentSnapshot;
    } catch (e) {
      rethrow;
    }
  }
}

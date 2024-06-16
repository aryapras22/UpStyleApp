import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class PostService {

  // collection group query
  // Future<List<DocumentSnapshot>> readAllPosts() async {
  //   try {
  //     QuerySnapshot querySnapshot = await _firestore
  //         .collectionGroup('posts')
  //         .orderBy('created_at', descending: true)
  //         .get();
  //     if (querySnapshot.docs.isNotEmpty) {
  //       return querySnapshot.docs;
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  var uuid = const Uuid();

  Future<void> createPost(String text, File file, String userRole) async {
    String uid = _auth.currentUser!.uid;
    String url = '';
    // String postId = uuid.v4();
    // get user role

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
        'user_role': userRole,
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

  // get user role
  Future<String> getUserRole() async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      return documentSnapshot['role'];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DocumentSnapshot>> filteredPost(String filter) async {
    try {
      switch (filter) {
        case "All":
          return await readAllPosts();
        case "Admin":
          return await readAllPosts();
        case "Users":
          return await readPostsByRoles("customer");
        case "Designers":
          return await readPostsByRoles("designer");
        case "Trends":
          return await readAllPosts();
        default:
          return await readAllPosts();
      }
    } on Exception catch (e) {
      throw e;
    }
  }

  // read all posts
  Future<List<DocumentSnapshot>> readAllPosts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('posts')
          .orderBy('created_at', descending: true)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DocumentSnapshot>> readPostsByRoles(String role) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('posts')
          .orderBy('created_at', descending: true)
          .where('user_role', isNotEqualTo: role)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs;
      } else {
        return [];
      }
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

  // search by posts text or user name
  Future<List<DocumentSnapshot>> searchPosts(String query) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('posts')
          .orderBy('created_at', descending: true)
          .where('text', isGreaterThanOrEqualTo: query)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  // search by posts text or user name
  Future<List<DocumentSnapshot>> searchUsers(String query) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .orderBy('name')
          .where('name', isGreaterThanOrEqualTo: query)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }
}

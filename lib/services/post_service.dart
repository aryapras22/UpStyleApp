import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:upstyleapp/model/post.dart';
import 'package:uuid/uuid.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  var uuid = const Uuid();

  Future<void> createPost(String text, File file, String userRole) async {
    String uid = _auth.currentUser!.uid;
    String url = '';

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
        'favorites': [],
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
    } on Exception {
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
          .where('user_role', isEqualTo: role)
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

  Future<QuerySnapshot<Post>> getUserPosts() async {
    try {
      return await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('posts')
          .withConverter(
              fromFirestore: Post.fromFirestore,
              toFirestore: (post, options) => post.toMap())
          .get();
    } catch (e) {
      rethrow;
    }
  }

  // get user posts by id
  Future<QuerySnapshot<Post>> getUserPostsById(String userId) async {
    try {
      return await _firestore
          .collection('users')
          .doc(userId)
          .collection('posts')
          .withConverter(
              fromFirestore: Post.fromFirestore,
              toFirestore: (post, options) => post.toMap())
          .get();
    } catch (e) {
      rethrow;
    }
  }

  // search that post have certain genre on their text
  Future<List<DocumentSnapshot>> searchByGenre(String genre) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('posts')
          .orderBy('created_at', descending: true)
          .where('text', isGreaterThanOrEqualTo: genre)
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

  // users collection favorites posts
  Future<void> favoritePost(String postId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('favorites')
          .where('post_id', isEqualTo: postId)
          .get();
      if (querySnapshot.docs.isEmpty) {
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({
          'favorites': FieldValue.arrayUnion([postId])
        });
        await _firestore.collection('posts').doc(postId).update({
          'favorites': FieldValue.arrayUnion([_auth.currentUser!.uid])
        });
      }
    } on Exception catch (e) {
      throw e;
    }
  }

  // users collection unfavorites posts
  Future<void> unfavoritePost(String postId) async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'favorites': FieldValue.arrayRemove([postId])
      });
      await _firestore.collection('posts').doc(postId).update({
        'favorites': FieldValue.arrayRemove([_auth.currentUser!.uid])
      });
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<QuerySnapshot<Post>> getFavorites() async {
    try {
      return await _firestore
          .collection('posts')
          .where('favorites', arrayContains: _auth.currentUser!.uid)
          .withConverter(
              fromFirestore: Post.fromFirestore,
              toFirestore: (post, options) => post.toMap())
          .get();
    } catch (e) {
      rethrow;
    }
  }

  // get current user id
  String getCurrentUserId() {
    return _auth.currentUser!.uid;
  }
}

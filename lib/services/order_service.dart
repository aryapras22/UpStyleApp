import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:upstyleapp/model/order.dart';
import 'package:upstyleapp/services/chat_service.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ChatService chatService = ChatService();

  Future<void> createOrder(OrderModel order, types.Room room) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('order_images')
          .child("${order.orderId}.jpg");
      await storageRef.putFile(File(order.imageUrl));
      final imageUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(order.orderId)
          .set(
        {
          'custId': order.customerId,
          'designerId': order.designerId,
          'title': order.title,
          'price': order.price,
          'orderDetail': order.orderDetail,
          'image_url': imageUrl,
          'date': order.date.toString(),
          'status': order.status.name,
          'paymentMethod': "",
          'payment_url': order.paymentUrl,
          'payment_token': order.paymentToken,
        },
      );
      chatService.sendOrderMessage(
        room,
        order.orderId,
        order.title,
        order.price,
        imageUrl,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getOrderById(String id) async {
    try {
      var queryDocumentSnapshot =
          await FirebaseFirestore.instance.collection('orders').doc(id).get();
      var data = queryDocumentSnapshot.data() ?? {};
      data['id'] = queryDocumentSnapshot.id;
      return data;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> changeStatus(String id, OrderStatus status) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(id)
          .update({'status': status.name});
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot>> getAllCustOrder(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('custId', isEqualTo: userId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.toList();
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot>> getAllDesOrder(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('designerId', isEqualTo: userId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.toList();
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot>> getFilteredCustOrder(
      String userId, String status) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('custId', isEqualTo: userId)
          .where('status', isEqualTo: status)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.toList();
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot>> getFilteredDesOrder(
      String userId, String status) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('designerId', isEqualTo: userId)
          .where('status', isEqualTo: status)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.toList();
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  // get order status by id
  Future<String> getOrderStatus(String id) async {
    try {
      var queryDocumentSnapshot =
          await FirebaseFirestore.instance.collection('orders').doc(id).get();
      var data = queryDocumentSnapshot.data() ?? {};
      return data['status'];
    } catch (error) {
      rethrow;
    }
  }
}

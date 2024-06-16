import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:upstyleapp/model/order.dart';
import 'package:uuid/uuid.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  var uuid = const Uuid();

  Future<void> createOrder(OrderModel order) async {
    final orderId = uuid.v4();
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('order_images')
          .child("$orderId.jpg");
      await storageRef.putFile(File(order.imageUrl));
      final imageUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance.collection('orders').doc(orderId).set(
        {
          'custId': order.customerId,
          'designerId': order.designerId,
          'title': order.title,
          'price': order.price,
          'orderDetail': order.orderDetail,
          'image_url': imageUrl,
          'date': order.date.toString(),
          'status': order.status.name,
          'paymentMethod': ""
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}

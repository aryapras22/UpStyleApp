import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum OrderStatus { waiting, onProgress, delivered, completed, canceled }

class OrderModel {
  String orderId;
  String designerId;
  String customerId;
  String imageUrl;
  String title;
  String price;
  String orderDetail;
  String paymentUrl;
  String paymentToken;

  OrderStatus status;
  DateTime date;
  String? paymentMethod;
  OrderModel(
      {required this.orderId,
      required this.designerId,
      required this.customerId,
      required this.imageUrl,
      required this.price,
      required this.title,
      required this.orderDetail,
      required this.status,
      required this.date,
      required this.paymentUrl,
      required this.paymentToken,
      this.paymentMethod});
  String get formattedDate {
    return DateFormat.yMMMMd().format(date);
  }

  String get textStatus {
    switch (status) {
      case OrderStatus.waiting:
        return 'Waiting';
      case OrderStatus.onProgress:
        return 'On Progress';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.canceled:
        return 'Canceled';
      default:
        return '';
    }
  }

  Color get statusColor {
    switch (status) {
      case OrderStatus.waiting:
        return const Color.fromARGB(255, 250, 225, 0);
      case OrderStatus.onProgress:
        return const Color.fromARGB(255, 0, 153, 255);
      case OrderStatus.delivered:
        return Color.fromARGB(255, 0, 247, 255);
      case OrderStatus.completed:
        return const Color.fromARGB(255, 41, 204, 106);
      case OrderStatus.canceled:
        return const Color.fromARGB(255, 244, 58, 34);
      default:
        return Colors.black;
    }
  }
}

OrderStatus getStatusFromString(String str) {
  try {
    return OrderStatus.values.firstWhere((e) => e.name == str);
  } catch (e) {
    throw Exception("Invalid status string: $str");
  }
}

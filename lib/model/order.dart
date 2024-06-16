import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum OrderStatus { waiting, inProgress, completed, canceled }

class OrderModel {
  String designerId;
  String customerId;
  String imageUrl;
  String title;
  String price;
  String orderDetail;
  OrderStatus status;
  DateTime date;
  String? paymentMethod;
  OrderModel(
      {required this.designerId,
      required this.customerId,
      required this.imageUrl,
      required this.price,
      required this.title,
      required this.orderDetail,
      required this.status,
      required this.date,
      this.paymentMethod});
  String get formattedDate {
    return DateFormat.yMMMMd().format(date);
  }

  String get textStatus {
    switch (status) {
      case OrderStatus.waiting:
        return 'Waiting';
      case OrderStatus.inProgress:
        return 'In Progress';
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
        return Color.fromARGB(255, 250, 225, 0);
      case OrderStatus.inProgress:
        return Color.fromARGB(255, 0, 153, 255);
      case OrderStatus.completed:
        return Color.fromARGB(255, 41, 204, 106);
      case OrderStatus.canceled:
        return Color.fromARGB(255, 244, 58, 34);
      default:
        return Colors.black;
    }
  }
}

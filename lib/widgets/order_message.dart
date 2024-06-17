// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upstyleapp/providers/auth_providers.dart';
import 'package:upstyleapp/screen/orders/order_checkout.dart';


class OrderMessage extends ConsumerStatefulWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String orderId;

  const OrderMessage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.orderId,
  });

  @override
  ConsumerState<OrderMessage> createState() => _OrderMessageState();
}

class _OrderMessageState extends ConsumerState<OrderMessage> {
  @override
  Widget build(BuildContext context) {
    final _userData = ref.watch(userProfileProvider);
    return Container(
      padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.imageUrl, // Replace with the URL of the dress image
                  height: 80.0,
                  width: 80.0,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Rp.${widget.price.toString()}',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.0),
          _userData.role == 'customer'
              ?
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderCheckout(
                          orderId: widget.orderId,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.symmetric(horizontal: 55.0, vertical: 5.0),
            ),
            child: Text(
                    'Proceed to Payment',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
                )
              : Text(
                  'On Process',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
          ),
        ],
      ),
    );
  }
}

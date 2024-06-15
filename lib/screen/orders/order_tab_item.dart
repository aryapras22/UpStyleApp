import 'package:flutter/material.dart';

class OrderTabItem extends StatelessWidget {
  final String title;


  const OrderTabItem({
    super.key,
    required this.title,

  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        title,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

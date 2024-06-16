import 'package:flutter/material.dart';

class PostFilter extends StatelessWidget {
  bool state;
  final String label;
  final ValueChanged<bool> onChanged;

  PostFilter({
    super.key,
    required this.label,
    required this.state,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
    );
  }
}

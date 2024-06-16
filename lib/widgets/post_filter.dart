import 'package:flutter/material.dart';

class PostFilter extends StatelessWidget {
  final bool state;
  final String label;
  final ValueChanged<bool> onChanged;

  const PostFilter({
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

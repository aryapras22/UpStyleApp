import 'package:flutter/material.dart';

class InputEditProfile extends StatelessWidget {
  final String? initialValue;
  final IconData prefixIcon;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final bool isReadOnly;

  const InputEditProfile({
    super.key,
    this.initialValue,
    required this.prefixIcon,
    this.validator,
    this.onSaved,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        initialValue: initialValue,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(16), // Adjust the padding here
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Icon(prefixIcon, color: Colors.white, size: 24),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 60, // Ensure the minimum width is enough
            minHeight: 60, // Ensure the minimum height is enough
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          border: InputBorder.none,
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}

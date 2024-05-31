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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          prefixIcon: Container(
            // margin: EdgeInsets.only(right: 8), // Remove padding and add margin
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Icon(prefixIcon, color: Colors.white),
          ),
          border: InputBorder.none, // Remove border to fit the design
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}

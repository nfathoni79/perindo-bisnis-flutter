import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.prefixIcon,
    this.prefixText,
    this.suffixText,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.obscureText = false,
    this.smallPadding = false,
    this.enabled,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String? labelText;
  final Icon? prefixIcon;
  final String? prefixText;
  final String? suffixText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool smallPadding;
  final bool? enabled;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        labelText: labelText,
        prefixIcon: prefixIcon,
        prefixText: prefixText,
        suffixText: suffixText,
        contentPadding: smallPadding
            ? const EdgeInsets.symmetric(vertical: 12, horizontal: 8)
            : const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      ),
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      validator: validator,
      enabled: enabled,
      onChanged: onChanged,
    );
  }
}

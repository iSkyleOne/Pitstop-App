import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool isEnabled;
  final int maxLines;
  final Widget? suffix;
  final Widget? prefix;
  final bool readOnly;
  final bool obscureText;
  final Function()? onTap;

  const TextInput({
    super.key,
    required this.label,
    this.hint = '',
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.isEnabled = true,
    this.maxLines = 1,
    this.suffix,
    this.prefix,
    this.readOnly = false,
    this.obscureText = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          enabled: isEnabled,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: suffix,
            prefixIcon: prefix,
          ),
        ),
      ],
    );
  }
}

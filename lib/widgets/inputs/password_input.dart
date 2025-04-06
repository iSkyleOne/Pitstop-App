// widgets/password_input.dart
import 'package:flutter/material.dart';
import 'text_input.dart';

class PasswordInput extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isEnabled;

  const PasswordInput({
    super.key,
    required this.label,
    this.hint = 'Introduceți parola',
    required this.controller,
    this.validator,
    this.isEnabled = true,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextInput(
      label: widget.label,
      hint: widget.hint,
      controller: widget.controller,
      validator: widget.validator,
      isEnabled: widget.isEnabled,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _obscureText,
      suffix: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}

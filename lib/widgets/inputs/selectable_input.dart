// widgets/selectable_input.dart
import 'package:flutter/material.dart';
import 'text_input.dart';

class SelectableInput<T> extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final List<T> options;
  final String Function(T) optionLabel;
  final Function(T) onSelected;
  final String? Function(String?)? validator;

  const SelectableInput({
    super.key,
    required this.label,
    this.hint = 'Selectați o opțiune',
    required this.controller,
    required this.options,
    required this.optionLabel,
    required this.onSelected,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextInput(
      label: label,
      hint: hint,
      controller: controller,
      validator: validator,
      readOnly: true,
      suffix: const Icon(Icons.arrow_drop_down),
      onTap: () {
        _showOptions(context);
      },
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return ListTile(
                      title: Text(optionLabel(option)),
                      onTap: () {
                        controller.text = optionLabel(option);
                        onSelected(option);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

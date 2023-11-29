import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final bool obscure;
  final TextInputType keyboardType;

  const MyTextField(
      {super.key,
      required this.textController,
      required this.hintText,
      this.obscure = false,
      required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));

    return TextField(
      controller: textController,
      decoration: InputDecoration(
        hintText: hintText,
        focusedBorder: inputBorder,
        border: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(12),
      ),
      keyboardType: keyboardType,
      obscureText: obscure,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}

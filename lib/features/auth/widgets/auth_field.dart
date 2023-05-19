import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class AuthField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final bool hideText;

  const AuthField({
    Key? key,
    required this.textEditingController,
    required this.hintText,
    this.hideText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      obscureText: hideText,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            5.0,
          ),
          borderSide: const BorderSide(
            color: Pallete.blueColor,
            width: 3.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            5.0,
          ),
          borderSide: const BorderSide(
            color: Pallete.greyColor,
            width: 3.0,
          ),
        ),
        contentPadding: const EdgeInsets.all(
          22.0,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }
}

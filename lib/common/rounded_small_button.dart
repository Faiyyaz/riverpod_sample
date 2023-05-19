import 'package:flutter/material.dart';

import '../theme/theme.dart';

class RoundedSmallButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const RoundedSmallButton({
    Key? key,
    required this.onTap,
    required this.label,
    this.backgroundColor = Pallete.whiteColor,
    this.textColor = Pallete.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onTap();
      },
      child: Chip(
        backgroundColor: backgroundColor,
        label: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16.0,
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 5.0,
        ),
      ),
    );
  }
}

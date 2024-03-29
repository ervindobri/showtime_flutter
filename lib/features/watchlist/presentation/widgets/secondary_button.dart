import 'package:flutter/material.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/styles.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final Widget? suffixIcon;
  final VoidCallback onPressed;
  const SecondaryButton(
      {Key? key, required this.text, required this.onPressed, this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 50,
      child: TextButton(
        style: GlobalStyles.whiteButtonStyle(),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: GlobalColors.primaryGreen,
                fontSize: 16,
              ),
            ),
            suffixIcon != null ? suffixIcon! : const SizedBox()
          ],
        ),
      ),
    );
  }
}

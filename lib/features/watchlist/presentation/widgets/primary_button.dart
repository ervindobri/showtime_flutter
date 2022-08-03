import 'package:flutter/material.dart';
import 'package:show_time/components/custom_elevation.dart';
import 'package:show_time/core/constants/custom_variables.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final String text;
  final Widget? icon;
  const PrimaryButton(
      {Key? key,
      this.onPressed,
      this.onLongPress,
      required this.text,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 50,
      child: CustomElevation(
        color: GlobalColors.greenColor.withOpacity(.3),
        spreadRadius: 2,
        blurRadius: 15,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(GlobalColors.greenColor),
            overlayColor:
                MaterialStateProperty.all(GlobalColors.darkGreenColor),
            shape: MaterialStateProperty.all(new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(12.0))),
          ),
          onLongPress: onLongPress,
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              icon != null ? icon! : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

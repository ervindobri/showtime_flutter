import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:show_time/core/constants/custom_variables.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  // final ItemCallback onSelectItemChanged;
  final Color itemColor;
  final Color backgroundColor;
  final String title;
  final IconData icon;

  const CustomButton(
      {Key? key,
      required this.onTap,
      // required this.onSelectItemChanged,
      this.itemColor = GlobalColors.white,
      this.backgroundColor = GlobalColors.primaryBlue,
      required this.title,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: backgroundColor.withOpacity(.3),
                  spreadRadius: 1,
                  blurRadius: 25)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (MediaQuery.of(context).size.width > 600)
                Text(
                  title,
                  style: TextStyle(
                    color: itemColor,
                    fontFamily: 'Raleway',
                    fontSize: MediaQuery.of(context).size.width > 600 ? 20 : 15,
                  ),
                ),
              FaIcon(
                icon,
                color: GlobalColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

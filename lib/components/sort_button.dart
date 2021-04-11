import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:show_time/constants/custom_variables.dart';
import 'package:show_time/ui/sort_bottom_sheet.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  // final ItemCallback onSelectItemChanged;
  final Color itemColor;
  final Color backgroundColor;
  final String title;
  final IconData icon;


  const CustomButton({Key? key,
    required this.onTap,
    // required this.onSelectItemChanged,
    this.itemColor = GlobalColors.white,
    this.backgroundColor = GlobalColors.blueColor,
    required this.title,
    required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(
                color: backgroundColor.withOpacity(.3),
                spreadRadius: 1,
                blurRadius: 25
            )]
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: itemColor,
                  fontFamily: 'Raleway',
                  fontSize: 20,
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

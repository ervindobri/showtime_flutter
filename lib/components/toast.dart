import 'package:eWoke/constants/custom_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomToast extends StatefulWidget {
  final Color color;
  final IconData icon;
  final String text;

  const CustomToast({Key key, this.color, this.icon, this.text}) : super(key: key);
  @override
  _CustomToastState createState() => _CustomToastState();
}

class _CustomToastState extends State<CustomToast> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: widget.color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, color: Colors.white,),
          SizedBox(
            width: 12.0,
          ),
          Text(widget.text, style: TextStyle(
            color: Colors.white,
            fontFamily: FONTFAMILY,
            fontWeight: FontWeight.w500
          ),),
        ],
      ),
    );
  }
}

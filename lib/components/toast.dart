import 'package:auto_size_text/auto_size_text.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: widget.color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if( widget.icon != null) Icon(widget.icon, color: Colors.white,),
          SizedBox(
            width: 12.0,
          ),
          AutoSizeText(
            widget.text,
            maxLines: 2,
            maxFontSize: 25,
            minFontSize: 10,
            style: GoogleFonts.lato(
            color: Colors.white,
            // fontFamily: FONTFAMILY,
            fontWeight: FontWeight.w500
          ),),
        ],
      ),
    );
  }
}

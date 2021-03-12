import 'package:show_time/constants/custom_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpandableText extends StatefulWidget {

  final VoidCallback onTap;
  final String text;
  final Widget textLabel;

  ExpandableText({required this.text,
    required this.textLabel,
    required this.onTap});

  bool isExpanded = false;

  @override
  _ExpandableTextState createState() => new _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  @override
  Widget build(BuildContext context) {
    return new Column(children: <Widget>[
      new AnimatedSize(
          vsync: this,
          duration: const Duration(milliseconds: 150),
          child: new ConstrainedBox(
              constraints: widget.isExpanded
                  ? new BoxConstraints()
                  : new BoxConstraints(maxHeight: 50.0),
              child: new Text(
                widget.text,
                style: GoogleFonts.roboto(
                    color: GlobalColors.greyTextColor,
                ),
                softWrap: true,
                overflow: TextOverflow.fade,
              ))),
      widget.isExpanded
          ? new FlatButton(
          child: widget.textLabel,
          onPressed: () {
            setState(() => widget.isExpanded = false);
          })
          : new FlatButton(
          child: widget.textLabel,
          onPressed: () {
            setState(() => widget.isExpanded = true);
          })
    ]);
  }
}
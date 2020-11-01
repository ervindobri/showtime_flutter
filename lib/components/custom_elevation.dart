import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomElevation extends StatelessWidget {
  final Widget child;
  final Color color;

  CustomElevation({@required this.child, this.color}) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: this.child,
    );
  }
}
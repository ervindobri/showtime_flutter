import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomElevation extends StatelessWidget {
  final Widget child;
  final Color color;
  final double? blurRadius;
  final double? spreadRadius;

  CustomElevation({required this.child,
    required this.color,
    this.blurRadius,
    this.spreadRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color,
            blurRadius: blurRadius ?? 10,
            spreadRadius: spreadRadius ?? 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: this.child,
    );
  }
}
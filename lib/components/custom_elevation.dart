import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomElevation extends StatelessWidget {
  final Widget child;
  final Color color;
  final double? blurRadius;
  final double? spreadRadius;

  const CustomElevation({Key? key, required this.child,
    required this.color,
    this.blurRadius,
    this.spreadRadius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(25.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color,
            blurRadius: blurRadius ?? 10,
            spreadRadius: spreadRadius ?? 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
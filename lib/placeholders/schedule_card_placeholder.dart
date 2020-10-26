
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleCardPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    const BorderRadius _radius = BorderRadius.all(Radius.circular(25.0));
    const BorderRadius _leftRadius = BorderRadius.only(
      topLeft:  Radius.circular(75.0),
      bottomRight: Radius.circular(25.0),
      bottomLeft: Radius.circular(25.0),
      topRight: Radius.circular(25.0),
    );

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Container(
          width: _height / 3,
          height: _height / 2.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: _leftRadius,
            boxShadow: [ new BoxShadow(
                color: Colors.black.withOpacity(.3),
                blurRadius: 15.0,
                spreadRadius:-4,
                offset: Offset(0, 5)),
            ],
          ),
        ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Badge extends StatelessWidget {
  final IconData icon;
  final List<Color> colors;

  const Badge({Key key, this.icon, this.colors}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              stops: [.33, 1],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                colors[0],
                colors[1],
              ]),
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        child: ClipOval(
          child: Container(
            width: MediaQuery.of(context).size.height/10,
            height: MediaQuery.of(context).size.height/10,
            padding: EdgeInsets.all(5),

            child: Center(
              child: FaIcon(
                icon,
                size: 35,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

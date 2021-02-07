import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget back(BuildContext context){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              // color: CupertinoColors.black
              child: Row(
                children: [
                  FaIcon(
                    Icons.arrow_back_ios,
                    size: 25,
                    color: Colors.white,
                  ),
                  Text(
                    "Home",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontFamily: 'Raleway',
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:show_time/constants/custom_variables.dart';
import 'package:show_time/screens/discover/discover.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ColorfulCard extends StatelessWidget {
  final int index;
  final List<dynamic> data;
  final double maxWidth;
  final double maxHeight;

  const ColorfulCard({Key? key, required this.index, required this.data, required this.maxWidth, required this.maxHeight}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => DiscoverRoute(list: data),),
      child: Padding(
        padding: index != GlobalVariables.DISCOVER_DATA.length - 1
            ? const EdgeInsets.only(left: 25.0)
            : const EdgeInsets.symmetric(horizontal: 25.0),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: Get.size.height / 4.5,
            height: Get.size.height * .18,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    new Color(data[1]),
                    new Color(data[2]),
                  ]),
              borderRadius: const BorderRadius.all(Radius.circular(25.0)),
              boxShadow: [
                new BoxShadow(
                    color: new Color(data[1]).withOpacity(.3),
                    blurRadius: 5.0,
                    spreadRadius: -1,
                    offset: Offset(0, 3)),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      // color: Colors.black,
                      height: 10,
                      child: FaIcon(
                        data[3],
                        color: Colors.white,
                        size: maxWidth / 4,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 15),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      data[0],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        shadows: [
                          new BoxShadow(
                              color: Colors.black.withOpacity(.15),
                              spreadRadius: 1.2,
                              blurRadius: 5,
                              offset: Offset(0, 3.0))
                        ],
                        color: Colors.white,
                        fontSize: maxWidth / 10,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

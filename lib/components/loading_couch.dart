import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

Widget loadingCouch() {
  return Center(
    child: Container(
      width: Get.width * .5,
      height: Get.height * .2,
      // color: Colors.black,
      child: SizedBox(
        child: Center(
          child: FlareActor(
              "assets/loadingcouch.flr",
              alignment: Alignment.bottomCenter,
              fit: BoxFit.contain,
              animation: "load"),
        ),
      ),
    ),
  );
}
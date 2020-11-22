import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:status_alert/status_alert.dart';

import '../main.dart';

Widget unwatchDialog(BuildContext context, String showName, String showID) {
  return CustomDialogWidget(
    backgroundColor: Colors.grey.shade100,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(25)),
    ),
    title: Center(
      child: Text(
        'Sure you want to unwatch $showName?',
      ),
    ),
    content: Text('Show content will be lost.'),
    contentTextStyle: TextStyle(
        fontFamily: 'Raleway',
        fontSize: 15,
        fontWeight: FontWeight.w200,
        color: GlobalColors.greyTextColor),
    contentPadding: EdgeInsets.only(top: 5.0, bottom: 1.0, left: 25.0, right: 25.0),
    titleTextStyle: TextStyle(
        fontFamily: 'Raleway',
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: GlobalColors.greyTextColor),
    titlePadding:
        EdgeInsets.only(top: 5.0, bottom: 25.0, left: 25.0, right: 25.0),
    elevation: 5,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 5),
        child: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 60,
            height: 30,
            // color: Colors.grey,
            child: Center(
              child: Text(
                'Close',
                style: TextStyle(
                    color: GlobalColors.greenColor, fontSize: 20, fontWeight: FontWeight.w300),
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 25.0, bottom: 5),
        child: InkWell(
          onTap: () {
            FirebaseFirestore.instance
                .collection("${auth.currentUser.email}/shows/watched_shows")
                .doc(showID)
                .delete();
            StatusAlert.show(
              context,
              duration: Duration(seconds: 2),
              blurPower: 15.0,
              title: 'Show unwatched!',
              configuration: IconConfiguration(icon: Icons.error),
            );
            //removed
            GlobalVariables.watchedShowList.removeWhere((element) => element.name == showName);
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Container(
            width: 100,
            height: 30,
            // color: Colors.grey,
            child: Center(
              child: Text(
                'Unwatch',
                style: TextStyle(
                    color: GlobalColors.greenColor, fontSize: 20, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
      )
    ],
  );
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:show_time/core/constants/custom_variables.dart';

class ProfileDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomDialogWidget(
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      title: Center(
        child: Text(
          'Profile',
        ),
      ),
      titleTextStyle: TextStyle(
          fontFamily: 'Raleway',
          fontSize: 25,
          fontWeight: FontWeight.w700,
          color: GlobalColors.greyTextColor),
      titlePadding: EdgeInsets.only(
          top: 5.0,
          // bottom: 10.0,
          left: 25.0,
          right: 25.0),
      content: Container(
        height: 260,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: GlobalColors.greyTextColor,
                minRadius: 40,
                maxRadius: 40,
                backgroundImage: AssetImage("assets/showtime-avatar.png"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "First Name : ",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: GlobalColors.greyTextColor),
                  ),
                  Text(
                    // "${authController.sessionUser.value.firstName}",
                    "firstname",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 20,
                        fontWeight: FontWeight.w100,
                        color: GlobalColors.greyTextColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Last Name : ",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: GlobalColors.greyTextColor),
                  ),
                  Text(
                    // "${authController.sessionUser.value.lastName}",
                    "lastName",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 20,
                        fontWeight: FontWeight.w100,
                        color: GlobalColors.greyTextColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Age : ",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: GlobalColors.greyTextColor),
                  ),
                  Text(
                    // "${authController.sessionUser.value.age}",
                    "age",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 20,
                        fontWeight: FontWeight.w100,
                        color: GlobalColors.greyTextColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Sex : ",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: GlobalColors.greyTextColor),
                  ),
                  Text(
                    "sex",
                    // "${authController.sessionUser.value.sex}",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 20,
                        fontWeight: FontWeight.w100,
                        color: GlobalColors.greyTextColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      elevation: 5,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 10),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Edit',
                  style: TextStyle(
                      color: GlobalColors.greenColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: TextStyle(
                      color: GlobalColors.greenColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

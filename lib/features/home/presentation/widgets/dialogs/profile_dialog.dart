import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:show_time/core/constants/custom_variables.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return CustomDialogWidget(
      backgroundColor: Colors.grey.shade100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      title: const Center(
        child: Text(
          'Profile',
        ),
      ),
      titleTextStyle: const TextStyle(
        fontFamily: 'Raleway',
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: GlobalColors.greyTextColor,
      ),
      titlePadding: const EdgeInsets.only(
        top: 8.0,
        left: 24.0,
        right: 24.0,
      ),
      content: SizedBox(
        height: height * .4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "First Name : ",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: GlobalColors.greyTextColor),
                  ),
                  Text(
                    // "${authController.sessionUser.value.firstName}",
                    "firstname",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 16,
                        fontWeight: FontWeight.w100,
                        color: GlobalColors.greyTextColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Last Name : ",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: GlobalColors.greyTextColor),
                  ),
                  Text(
                    // "${authController.sessionUser.value.lastName}",
                    "lastName",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 16,
                        fontWeight: FontWeight.w100,
                        color: GlobalColors.greyTextColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Age : ",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: GlobalColors.greyTextColor),
                  ),
                  Text(
                    // "${authController.sessionUser.value.age}",
                    "age",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 16,
                        fontWeight: FontWeight.w100,
                        color: GlobalColors.greyTextColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Sex : ",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: GlobalColors.greyTextColor),
                  ),
                  Text(
                    "sex",
                    // "${authController.sessionUser.value.sex}",
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 16,
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
                child: const Text(
                  'Edit',
                  style: TextStyle(
                      color: GlobalColors.primaryGreen,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(
                      color: GlobalColors.primaryGreen,
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

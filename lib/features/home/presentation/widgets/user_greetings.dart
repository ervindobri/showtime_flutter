import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:show_time/core/constants/custom_variables.dart';

class UserGreetings extends StatelessWidget {
  const UserGreetings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Shimmer.fromColors(
            highlightColor: GlobalColors.primaryGreen,
            baseColor: GlobalColors.primaryBlue,
            direction: ShimmerDirection.ltr,
            period: const Duration(seconds: 10),
            child: Container(
              height: 56,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      GlobalColors.primaryGreen,
                      GlobalColors.primaryBlue,
                    ]),
              ),
            ),
          ),
          Center(
            child: Text(
              showGreetings(),
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Raleway',
                  fontSize: 22,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  String showGreetings() {
    var timeNow = DateTime.now().hour;
    String greetings = "";
    if (timeNow <= 12) {
      greetings = 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      greetings = 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      greetings = 'Good Evening';
    } else {
      greetings = 'Good Night';
    }
    // print(firstName);
    return greetings + ", Ervin!";
  }
}
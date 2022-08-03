import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/constants/styles.dart';
import 'package:show_time/features/home/presentation/widgets/dialogs/profile_dialog.dart';
import 'package:show_time/features/home/presentation/widgets/dialogs/sign_out_dialog.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: InkWell(
              onTap: () => showProfileDialog(context),
              child: Container(
                // color: CupertinoColors.black,
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.userCircle,
                    color: GlobalColors.greenColor,
                    // size: 40,
                  ),
                ),
              ),
            ),
          ),
          Container(
              // color: GlobalColors.greenColor,
              child: Image(image: AssetImage('showTIME.png'), height: 40)),
          InkWell(
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (context) => Dialog(
                      elevation: 24,
                      shape: RoundedRectangleBorder(
                          borderRadius: GlobalStyles.radius24),
                      child: SignOutDialog()),
                  barrierColor: Colors.white.withOpacity(.4));
            },
            child: Container(
              // color: CupertinoColors.black,
              // width: 100,
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.signOutAlt,
                  color: GlobalColors.greenColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showProfileDialog(context) {
    showAnimatedDialog(
      context: context,
      animationType: DialogTransitionType.slideFromLeftFade,
      barrierDismissible: true,
      duration: Duration(milliseconds: 100),
      builder: (BuildContext context) {
        return ProfileDialog();
      },
    );
  }
}

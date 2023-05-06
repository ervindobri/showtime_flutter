import 'dart:ui';

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
    final topPadding = MediaQuery.of(context).viewPadding.top;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: width,
          // decoration: BoxDecoration(color: Colors.white.withOpacity(.7)),
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: Column(
            children: [
              SizedBox(height: topPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => showProfileDialog(context),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.userCircle,
                        color: GlobalColors.primaryGreen,
                        // size: 40,
                      ),
                    ),
                  ),
                  const Image(
                      image: AssetImage('assets/images/showTIME.png'),
                      height: 40),
                  InkWell(
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                              elevation: 24,
                              shape: RoundedRectangleBorder(
                                  borderRadius: GlobalStyles.radius24),
                              child: const SignOutDialog()),
                          barrierColor: Colors.white.withOpacity(.4));
                    },
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.signOutAlt,
                        color: GlobalColors.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showProfileDialog(context) {
    showAnimatedDialog(
      context: context,
      animationType: DialogTransitionType.slideFromLeftFade,
      barrierDismissible: true,
      duration: const Duration(milliseconds: 100),
      builder: (BuildContext context) {
        return const ProfileDialog();
      },
    );
  }
}

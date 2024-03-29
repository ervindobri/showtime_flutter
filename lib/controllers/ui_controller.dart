import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:show_time/components/toast.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/core/utils/navigation.dart';
import 'package:show_time/features/home/data/models/watched.dart';
import 'package:show_time/network/firebase_utils.dart';

/// This widget helps manage the state of re appearing UI elements
/// like Alert Dialogs, Snackbars, Toasts
///
class UiController {
  late FToast fToast;

  int hoverTimeout = 0;

  unwatchDialog(context, {required String showName, required String showID}) {
    return CustomDialogWidget(
      backgroundColor: Colors.grey.shade100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      title: Center(
        child: Text(
          'Sure you want to unwatch $showName?',
        ),
      ),
      content: const Text('Show content will be lost.'),
      contentTextStyle: const TextStyle(
          fontFamily: 'Raleway',
          fontSize: 15,
          fontWeight: FontWeight.w300,
          color: GlobalColors.greyTextColor),
      contentPadding:
          const EdgeInsets.only(top: 5.0, bottom: 1.0, left: 25.0, right: 25.0),
      titleTextStyle: const TextStyle(
          fontFamily: 'Raleway',
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: GlobalColors.greyTextColor),
      titlePadding: const EdgeInsets.only(
          top: 5.0, bottom: 25.0, left: 25.0, right: 25.0),
      elevation: 5,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10, bottom: 5),
          child: InkWell(
            onTap: () => {
              // Get.back();
            },
            child: const SizedBox(
              width: 60,
              height: 30,
              // color: Colors.grey,
              child: Center(
                child: Text(
                  'Close',
                  style: TextStyle(
                      color: GlobalColors.primaryGreen,
                      fontSize: 20,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 25.0, bottom: 5),
          child: InkWell(
            onTap: () {
              try {
                FirestoreUtils().watchedShows.doc(showID).delete();
                showToast(
                  text: 'Show unwatched!',
                  icon: Icons.done,
                  color: GlobalColors.primaryGreen,
                  context: context,
                );
                //removed
                GlobalVariables.watchedShowList
                    .removeWhere((element) => element.name == showName);
                NavUtils.back(context);
                NavUtils.back(context);
              } catch (exception) {
                showToast(
                    text: "Couldn'\t unwatch show!",
                    icon: Icons.error,
                    context: context,
                    color: GlobalColors.fireColor);
                // Get.back();
              }
            },
            child: const SizedBox(
              width: 100,
              height: 30,
              // color: Colors.grey,
              child: Center(
                child: Text(
                  'Unwatch',
                  style: TextStyle(
                      color: GlobalColors.primaryGreen,
                      fontSize: 20,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  showToast(
      {required BuildContext context,
      required String text,
      IconData? icon,
      Color color = GlobalColors.primaryGreen,
      ToastGravity gravity = ToastGravity.TOP}) {
    fToast = FToast();
    fToast.init(context);

    Widget toast = CustomToast(color: color, icon: icon, text: text);
    fToast.showToast(
      child: toast,
      gravity: gravity,
      toastDuration: const Duration(seconds: 2),
    );
  }

  detailDialog(WatchedTVShow show) {
    // Get.defaultDialog(
    //     title: show.name!,
    //     titleStyle: TextStyle(
    //         fontFamily: ShowTheme.defaultFontFamily,
    //         fontSize: 30,
    //         fontWeight: FontWeight.w500),
    //     content: WatchlistDetailDialog(show: show));
  }
}

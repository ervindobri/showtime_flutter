import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:show_time/components/toast.dart';
import 'package:show_time/constants/custom_variables.dart';
import 'package:show_time/network/firebase_utils.dart';

/// This widget helps manage the state of re appearing UI elements
/// like Alert Dialogs, Snackbars, Toasts
///
class UIController extends GetxController{

  late FToast fToast;

  @override
  void onInit() {

    print("Toast: $fToast");
    super.onInit();
  }
  void showAlert({required String title, required int seconds, required double blurPower, required IconData icon}) {
    //TODO: statusAlert
    // StatusAlert.show(context,
    //   duration:
    //   Duration(
    //       seconds:
    //       seconds),
    //   blurPower: blurPower,
    //   title: title,
    //   configuration:
    //   IconConfiguration(
    //       icon: icon),
    // );
  }
  unwatchDialog({required String showName, required String showID}) {
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
          fontWeight: FontWeight.w300,
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
            onTap: () => Get.back(),
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
              try{
                FirestoreUtils().watchedShows
                    .doc(showID)
                    .delete();
                showAlert(title: 'Show unwatched!', seconds: 2, blurPower:  15, icon: Icons.done);
                //removed
                GlobalVariables.watchedShowList.removeWhere((element) => element.name == showName);
                Get.back();
                Get.back();
              }
              catch(exception){
                showAlert(title: "Couldn'\t unwatch show!", seconds: 2, blurPower:  15, icon: Icons.error);
                Get.back();
              }

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

  showToast({required BuildContext context, required Color color,required IconData icon,required String text, ToastGravity gravity = ToastGravity.TOP}){
    fToast = FToast();
    fToast.init(context);

    Widget toast = CustomToast(color: color, icon: icon, text: text);
    fToast.showToast(
      child: toast,
      gravity: gravity,
      toastDuration: Duration(seconds: 2),
    );
  }
}
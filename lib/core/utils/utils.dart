import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:show_time/core/constants/custom_variables.dart';

class Utils {
  static showToast({required String text, IconData? icon}) {
    Fluttertoast.showToast(
        msg: text, backgroundColor: GlobalColors.primaryGreen);
  }
}

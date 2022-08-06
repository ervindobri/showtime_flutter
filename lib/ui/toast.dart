import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:show_time/components/toast.dart';

late FToast fToast;

showToast(
    {required BuildContext context,
    required String text,
    required IconData icon,
    required Color color,
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

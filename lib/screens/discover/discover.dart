import 'package:show_time/core/constants/custom_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DiscoverRoute extends StatelessWidget {
  final List? list = 
  // Get.arguments
  null
   ?? [];

  DiscoverRoute({Key? key}) : super(key: key);

  _selectDiscoverContent(data) {
    return GlobalVariables.discoverMap[data];
  }

  @override
  Widget build(BuildContext context) {
    if (list!.isNotEmpty) {
      return _selectDiscoverContent(list![0]); //pass title, and get content
    } else {
      return Container();
    }
  }
}

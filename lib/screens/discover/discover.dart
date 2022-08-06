import 'package:get/get.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:show_time/get_controllers/show_controller.dart';

class DiscoverBinding extends Bindings{
    @override
    void dependencies() {
      Get.lazyPut<ShowController>(() => ShowController());
    }
}
class DiscoverRoute extends StatelessWidget {
  final List? list = Get.arguments ?? [];

  DiscoverRoute({Key? key}) : super(key: key);

  _selectDiscoverContent(data) {
    return GlobalVariables.discoverMap[data];
  }

  @override
  Widget build(BuildContext context) {
    print("Discover");
    if ( list!.isNotEmpty){
      return _selectDiscoverContent(list![0]); //pass title, and get content
    }
    else{
      return Container();
    }
  }
}

import 'package:show_time/get_controllers/auth_controller.dart';
import 'package:get/get.dart';

class InstanceBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
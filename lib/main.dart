import 'package:show_time/get_controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'components/route_generator.dart';
import 'constants/custom_variables.dart';
import 'package:show_time/pages/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:show_time/pages/login.dart';
import 'get_bindings/instance_binding.dart';



TextTheme buildAppTextTheme( TextTheme base){
  return base.copyWith(
      headline1: base.headline1!.copyWith(
        fontWeight: FontWeight.w500,
        color: GlobalColors.greyTextColor,

      ),
      headline6: base.headline6!.copyWith(
        fontSize: 18,
        color: GlobalColors.greyTextColor,

      ),
      caption: base.caption!.copyWith(
        fontWeight: FontWeight.w400,
        color: GlobalColors.greyTextColor,

      ),
      bodyText1: base.bodyText1!.copyWith(
        fontSize: 17,
        color: GlobalColors.greyTextColor,


      ),
      button: base.button!.copyWith(
        letterSpacing: 3.0,
        color: GlobalColors.greyTextColor,

      ),
      bodyText2: base.bodyText2!.copyWith(
        color: GlobalColors.greyTextColor,

      )
  ).apply(
    fontFamily: "Raleway",
  );
}


FirebaseAuth auth = FirebaseAuth.instance;


ThemeData buildAppTheme(){
  final ThemeData base = ThemeData.dark();


  return base.copyWith(
    brightness: Brightness.light,
    accentColor: GlobalColors.greenColor,
    primaryColor: GlobalColors.greenColor,
    scaffoldBackgroundColor: Colors.blueGrey.shade300,
    backgroundColor: Colors.white70,
    textTheme: buildAppTextTheme(base.textTheme),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //TODO: integrate GETX to EVERY screen/page
  runApp(
      GetMaterialApp(
        initialBinding: InstanceBinding(),
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black.withOpacity(0)),
        ),
        title: 'showTIME',
        home: Router(),
      )
  );
}

class Router extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Get.find<AuthController>().user?.firstName != null ? SplashScreen() : LoginScreen();
    });
  }
}
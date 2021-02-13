import 'package:eWoke/get_controllers/auth_controller.dart';
import 'package:eWoke/models/watched.dart';
import 'package:eWoke/providers/connectivity_service.dart';
import 'package:eWoke/providers/show_provider.dart';
import 'package:eWoke/providers/timer_service.dart';
import 'package:eWoke/providers/user_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'components/route_generator.dart';
import 'constants/custom_variables.dart';
import 'package:eWoke/pages/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:eWoke/pages/login.dart';
import 'database/database.dart';
import 'database/user_data_dao.dart';
import 'package:get/get.dart';

import 'get_bindings/instance_binding.dart';



TextTheme buildAppTextTheme( TextTheme base){
  return base.copyWith(
      headline1: base.headline1.copyWith(
        fontWeight: FontWeight.w500,
        color: GlobalColors.greyTextColor,

      ),
      headline6: base.headline6.copyWith(
        fontSize: 18,
        color: GlobalColors.greyTextColor,

      ),
      caption: base.caption.copyWith(
        fontWeight: FontWeight.w400,
        color: GlobalColors.greyTextColor,

      ),
      bodyText1: base.bodyText1.copyWith(
        fontSize: 17,
        color: GlobalColors.greyTextColor,


      ),
      button: base.button.copyWith(
        letterSpacing: 3.0,
        color: GlobalColors.greyTextColor,

      ),
      bodyText2: base.bodyText2.copyWith(
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
  AuthController authController = Get.put(AuthController());

  final database = await $FloorAppDatabase
      .databaseBuilder('user_database.db')
      .build();

  authController.setDao(database.userDao);

  UserProvider.instance().initUserProvider();
  print("starting");
  //TODO: integrate PROVIDER to EVERY screen/page
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
  final UserDao dao;

  const Router({Key key, this.dao}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Get.find<AuthController>().user?.firstName != null ? SplashScreen() : LoginScreen();
    });
  }
}
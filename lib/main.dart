import 'constants/custom_variables.dart';
import 'package:eWoke/home/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home/home.dart';
import 'home/login.dart';
import 'network/firebase_utils.dart';



final ThemeData _appTheme = buildAppTheme();


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

  final _storage = FlutterSecureStorage();

  String email = await _storage.read(key: 'email');
  String password = await _storage.read(key: 'password');

  if ( email != null){
    await FirestoreUtils().authUser(email,password);
  }

  //TODO: check if user data saved and start page accordingly

  runApp(
      MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          title: 'showTIME',
          home: email == null ? LoginScreen()
                              : SplashScreen()
      )
  );
}

//void main() => runApp(new MaterialApp(
//  theme: _appTheme,
//  home: HomeView(),
//));

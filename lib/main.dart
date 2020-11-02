import 'file:///C:/Users/Winter/IdeaProjects/eWoke/lib/constants/custom_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home/home.dart';
import 'home/login.dart';



final ThemeData _appTheme = buildAppTheme();


TextTheme buildAppTextTheme( TextTheme base){
  return base.copyWith(
      headline1: base.headline1.copyWith(
        fontWeight: FontWeight.w500,
        color: greyTextColor,

      ),
      headline6: base.headline6.copyWith(
        fontSize: 18,
        color: greyTextColor,

      ),
      caption: base.caption.copyWith(
        fontWeight: FontWeight.w400,
        color: greyTextColor,

      ),
      bodyText1: base.bodyText1.copyWith(
        fontSize: 17,
        color: greyTextColor,


      ),
      button: base.button.copyWith(
        letterSpacing: 3.0,
        color: greyTextColor,

      ),
      bodyText2: base.bodyText2.copyWith(
        color: greyTextColor,

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
    accentColor: greenColor,
    primaryColor: greenColor,
    scaffoldBackgroundColor: Colors.blueGrey.shade300,
    backgroundColor: Colors.white70,
    textTheme: buildAppTextTheme(base.textTheme),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      title: 'showTIME', home: LoginScreen()));
}

//void main() => runApp(new MaterialApp(
//  theme: _appTheme,
//  home: HomeView(),
//));
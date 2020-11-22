import 'package:eWoke/providers/show_provider.dart';
import 'package:eWoke/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'constants/custom_variables.dart';
import 'package:eWoke/home/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home/login.dart';



// final ThemeData _appTheme = buildAppTheme();


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

  UserProvider.instance().initUserProvider();
  print("starting");
  //TODO: integrate PROVIDER to EVERY screen/page
  runApp(
      MultiProvider(
        providers: [
            ChangeNotifierProvider<UserProvider>(
                create: (_) => UserProvider.instance(),
                builder: (context,child){
                  return child;
                }
            ),
            FutureProvider(create:(context) async => UserProvider.instance().getUserData()),
            StreamProvider(create: (context) => ShowProvider().getWatchedShows()),
          ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          title: 'showTIME',
          home: Router(),
        ),
      )
  );
}

class Router extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Builder(
        builder: (newContext) {
          switch (newContext
              .watch<UserProvider>()
              .status) {
            case Status.Authenticated:
              return SplashScreen();
            default:
              return LoginScreen();
          }
        }
      );

  }
}
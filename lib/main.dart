import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:google_fonts/google_fonts.dart';
import 'package:show_time/core/constants/theme_utils.dart';
import 'package:show_time/features/splash/bloc/splash_bloc.dart';
import 'core/utils/route_generator.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:show_time/features/splash/presentation/pages/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'injection_container.dart' as di;
import 'firebase_options.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();

  runApp(
    MaterialApp(
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
      theme: appTheme(), //TODO: extract & define theme
      title: 'showTIME',
      home: bloc.BlocProvider<SplashBloc>(
        create: (BuildContext context) =>
            SplashBloc()..add(GetSplashEvent(true)),
        child: const SplashScreen(),
      ),
    ),
  );
}

appTheme() {
  return ThemeData(
    primaryColor: GlobalColors.primaryGreen,
    fontFamily: ShowTheme.defaultFontFamily,
    textTheme: TextTheme(
        bodyText1: GoogleFonts.raleway(
          color: GlobalColors.greyTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        bodyText2: GoogleFonts.raleway(color: GlobalColors.greyTextColor)),
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
  );
}

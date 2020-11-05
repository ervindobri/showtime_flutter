import 'package:eWoke/constants/custom_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
          color: bgColor,
          child: Column(
            children: [
              //ANIMATE IN LOGO
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  width: _width / 2,
                  height: _height / 5.5,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/showTIMEsmall.png"),
                          fit: BoxFit.cover)),
                ),
              ),
              // PROGRESS BAR TO LOAD HOME STUFF
              Container(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(greenColor),
                  ),
                ),
              )
            ],
          ),
      ),
    );
  }
}

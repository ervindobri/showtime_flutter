// import 'dart:html';
import 'dart:ui';

import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/main.dart';
import 'package:eWoke/network/firebase_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool selected = false; // remember me
  bool logging = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();

  bool _showPassword = true;

  FaIcon eye = FaIcon(FontAwesomeIcons.eye, color: greenColor);
  int _state = 0;


  final _storage = FlutterSecureStorage();




  // /password validator possible structure
  passwordValidator(String password) {
    if (password.isEmpty) {
      return 'Password empty';
    } else if (password.length < 3) {
      return 'PasswordShort';
    }
    return null;
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSavedData();
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(20.0),
    );
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final textFieldHeight = 45.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: _height+170,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  end: Alignment.bottomRight,
                  begin: Alignment.topLeft,
                  colors: [greenColor, blueColor])),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 5.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "E-mail address",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Raleway',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Container(
                                  // height: textFieldHeight,
                                  child: TextFormField(
                                    validator: (value) =>
                                        EmailValidator.validate(value)
                                            ? null
                                            : "E-mail address is not valid",
                                    controller: nameController,
                                    keyboardType: TextInputType.emailAddress,
                                    autofocus: false,
                                    style: new TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'Raleway',
                                        color: greyTextColor),
                                    decoration: const InputDecoration(
                                        errorStyle: TextStyle(
                                            fontFamily: 'Raleway',
                                            color: orangeColor
                                        ),
                                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'johndoe@example.com',
                                        focusColor: greenColor,
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: blueColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                        ),
                                        border: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: blueColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: greenColor, width: 2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                        ),
                                        errorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: orangeColor, width: 2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                        ),
                                      ),

                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 5.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Password",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Raleway',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      // height: textFieldHeight,
                                      child: TextFormField(
                                        validator: (value) {
                                          debugPrint(value);
                                          return passwordValidator(value);
                                        },
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        controller: passwordController,
                                        obscureText: _showPassword,
                                        style: new TextStyle(
                                            fontSize: 15.0,
                                            fontFamily: 'Raleway',
                                            color: greyTextColor),
                                        decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                                            errorStyle: TextStyle(
                                              fontFamily: 'Raleway',
                                              color: orangeColor
                                            ),
                                            errorText: null,
                                            errorMaxLines: 1,
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'password1234',
                                            focusColor: greenColor,
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: greenColor),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(50.0)),
                                            ),
                                            border: const OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: greenColor),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(50.0)),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: greenColor, width: 1.5),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(50.0)),
                                            ),
                                            errorBorder: const OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: orangeColor, width: 1.5),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(50.0)),
                                            )),
                                      ),
                                    ),
                                    Container(
                                      height: textFieldHeight,
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0),
                                            child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _showPassword =
                                                        !_showPassword;
                                                    eye = _showPassword
                                                        ? FaIcon(
                                                            FontAwesomeIcons.eye,
                                                            color: greenColor,
                                                          )
                                                        : FaIcon(
                                                            FontAwesomeIcons
                                                                .eyeSlash,
                                                            color: greenColor,
                                                          );
                                                  });
                                                },
                                                child: eye),
                                          )),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          AnimatedSizeAndFade(
                            vsync: this,
                            child: logging
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25.0, vertical: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Remember me",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Raleway',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25.0),
                                        child: CircularCheckBox(
                                          value: this.selected,
                                          activeColor: greenColor,
                                          inactiveColor: Colors.white,
                                          hoverColor: Colors.white,
                                          checkColor: Colors.white,
                                          focusColor: Colors.white,
                                          onChanged: (value) => this.setState(() {
                                            this.selected = value;
                                          }),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25.0, vertical: 5.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Password again",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Raleway',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: Stack(
                                          children: [
                                            Container(
                                              // height: textFieldHeight,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if ( value != passwordController.text){
                                                    return "Passwords do not match!";
                                                  }
                                                  return null;
                                                },
                                                keyboardType:
                                                TextInputType.visiblePassword,
                                                controller: passwordController,
                                                obscureText: _showPassword,
                                                style: new TextStyle(
                                                    fontSize: 15.0,
                                                    fontFamily: 'Raleway',
                                                    color: greyTextColor),
                                                decoration: const InputDecoration(
                                                    contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                                                    errorStyle: TextStyle(
                                                        fontFamily: 'Raleway',
                                                        color: orangeColor
                                                    ),
                                                    errorText: null,
                                                    errorMaxLines: 1,
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    hintText: 'password1234',
                                                    focusColor: greenColor,
                                                    enabledBorder:
                                                    const OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: greenColor),
                                                      borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(50.0)),
                                                    ),
                                                    border: const OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: greenColor),
                                                      borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(50.0)),
                                                    ),
                                                    focusedBorder:
                                                    const OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: greenColor, width: 1.5),
                                                      borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(50.0)),
                                                    ),
                                                    errorBorder: const OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: orangeColor, width: 1.5),
                                                      borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(50.0)),
                                                    )),
                                              ),
                                            ),
                                            Container(
                                              height: textFieldHeight,
                                              child: Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                    child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            _showPassword =
                                                            !_showPassword;
                                                            eye = _showPassword
                                                                ? FaIcon(
                                                              FontAwesomeIcons.eye,
                                                              color: greenColor,
                                                            )
                                                                : FaIcon(
                                                              FontAwesomeIcons
                                                                  .eyeSlash,
                                                              color: greenColor,
                                                            );
                                                          });
                                                        },
                                                        child: eye),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                            fadeDuration: const Duration(milliseconds: 300),
                            sizeDuration: const Duration(milliseconds: 600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
                            child: RaisedButton(
                              color: greenColor,
                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
                                elevation: 10,
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      _state = 1;
                                    });
                                    if (logging) {
                                      Future.delayed(const Duration(milliseconds: 300), () async{
                                        String auth = await FirestoreUtils().authUser(nameController.text, passwordController.text);
                                        if (auth == null){
                                            setState(() {
                                              _state = 2;
                                            });
                                            Future.delayed(
                                                const Duration(milliseconds: 300), () {
                                                  //Save login data
                                                  if (selected){
                                                      _storage.write(key: 'email', value: nameController.text);
                                                      _storage.write(key: 'password', value: passwordController.text);
                                                      // print("saved");
                                                  }
                                                  final home = HomeView();
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(CupertinoPageRoute(
                                                      builder: (context) => home,
                                                    ),(route) => false);
                                                });
                                        }
                                        else{
                                          // print(auth);
                                          setState(() {
                                            _state = 0;
                                          });
                                          Fluttertoast.showToast(
                                              msg: "$auth",
                                              toastLength: Toast.LENGTH_LONG,
                                              backgroundColor: orangeColor,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 2
                                          );
                                        }
                                      });
                                    }
                                    else {
                                      if ( passwordController.text != repasswordController.text){
                                        Fluttertoast.showToast(msg: "Passwords do not match!");
                                      }
                                      else{
                                        Future.delayed(const Duration(milliseconds: 300), () async{
                                          String auth = await FirestoreUtils().registerUser(nameController.text,passwordController.text);
                                          if (auth == null){
                                            setState(() {
                                              _state = 2;
                                            });
                                            Future.delayed(
                                                const Duration(milliseconds: 300), () {
                                              setState(() {
                                                logging = true;
                                                _state = 1;
                                              });
                                            });
                                          }
                                          else{
                                            // print(auth);
                                            setState(() {
                                              _state = 0;
                                            });
                                            Fluttertoast.showToast(
                                                msg: "$auth",
                                                toastLength: Toast.LENGTH_LONG,
                                                backgroundColor: orangeColor,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 2
                                            );
                                          }

                                        });
                                      }


                                    }
                                  }
                                },
                                child: Center(
                                    child: buttonChild(),
                                  ),
                                )
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    logging = !logging;
                                  });
                                },
                                child: Container(
                                  width: _width * .8,
                                  height: textFieldHeight,
                                  decoration: BoxDecoration(
                                      color: lightGreenColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0))),
                                  child: Center(
                                    child: Text(
                                      logging ? "Register" : "Back to login",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Raleway',
                                          color: greenColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonChild() {
    if (_state == 0) {
      return Text(
        logging ? "Log in" : "Register",
        style: TextStyle(
            fontSize: 15,
            fontFamily: 'Raleway',
            color: Colors.white,
            fontWeight: FontWeight.w600),
      );
    } else if (_state == 1) {
      return Container(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      //TODO: display checked icon
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void getSavedData() async{
    try {
      nameController.text = await _storage.read(key: 'email');
      passwordController.text = await _storage.read(key: 'password');
    }
    catch(e){
      //
    }
  }
}

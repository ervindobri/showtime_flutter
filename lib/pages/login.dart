import 'dart:ui';
import 'package:eWoke/components/custom_elevation.dart';
import 'package:eWoke/components/toast.dart';
import 'package:eWoke/constants/custom_variables.dart';
import 'package:eWoke/database/user_data.dart';
import 'package:eWoke/database/user_data_dao.dart';
import 'package:eWoke/pages/splash.dart';
import 'package:eWoke/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simple_animations/simple_animations.dart';

class LoginScreen extends StatefulWidget {
  final UserDao dao;

  const LoginScreen({Key key, this.dao}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with AnimationMixin {
  bool selected = false; // remember me
  bool logging = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();

  bool _showPassword = true;

  FaIcon eye = FaIcon(FontAwesomeIcons.eye, color: GlobalColors.greenColor);
  int _state = 0;
  final _storage = FlutterSecureStorage();
  var animationName = 'Shrink';
  FToast fToast;

  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool _fingerprintAnimStopped;

  Animation<double> animation;
  AnimationController _controller;

  bool _isBgAnimStopped = true;

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<String> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return '';

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
    return _authorized;
  }

  void _cancelAuthentication() {
    auth.stopAuthentication();
  }

  // /password validator possible structure
  passwordValidator(String password) {
    if (password.isEmpty) {
      return 'Password empty';
    } else if (password.length < 3) {
      return 'PasswordShort';
    }
    return null;
  }

  List<UserData> list = [];

  @override
  void initState() {
    _canCheckBiometrics = false;
    _fingerprintAnimStopped = true;
    super.initState();
    getSavedData();
    fToast = FToast();
    fToast.init(context);
    if (widget.dao == null)
      print("DAO is null!");
    //get accounts with biometric - true
    fetchAccounts();
    _checkBiometrics();
    print(_canCheckBiometrics);
    _getAvailableBiometrics();
    initialTimer();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    );

    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    );
  }

  var startAnimation = false;

  initialTimer() async {
    await new Future.delayed(const Duration(milliseconds: 2000));
    setState(() {
      startAnimation = true;
      _isBgAnimStopped = false;
    });
    await new Future.delayed(const Duration(milliseconds: 300));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: !startAnimation
                ? _height/3
                : 30,
            curve: Curves.decelerate,
            left: _width/4,
            right: _width/4,
            child: Container(
              width: _width / 2,
              height: _height * .1,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/showTIMEsmall.png"),
                      fit: BoxFit.cover)),
            ),
          ),
          Container(
            width: _width,
            height: _height,
            child: FlareActor("assets/flowingbg.flr",
                isPaused: _isBgAnimStopped,
                fit: BoxFit.cover,
                animation: "in"),
          ),
          SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                        child: Container(
                          height: _height * .7,
                          width: _width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: GlobalColors.bgColor.withOpacity(.2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FlatButton(
                                      textColor: GlobalColors.greyTextColor,
                                      highlightColor: GlobalColors.greenColor,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(color: GlobalColors.greyTextColor, width: .3),
                                          borderRadius: BorderRadius.circular(15)),
                                      child: Container(
                                        width: 150,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                    'assets/google_logo.png'),
                                                height: 30,
                                              ),
                                              Text('Google Sign-In'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        print("google sign in!");
                                        context
                                            .read<UserProvider>()
                                            .signInWithGoogle()
                                            .then((result) {
                                          print("result:$result");
                                          if (result != null) {
                                            final home = SplashScreen();
                                            Navigator.of(context).pushAndRemoveUntil(
                                                CupertinoPageRoute(
                                                  builder: (context) => home,
                                                ),
                                                    (route) => false);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "or"
                                    ),
                                  ),
                                  if ( _canCheckBiometrics
                                  // && list.isNotEmpty
                                  ) InkWell(
                                    highlightColor: GlobalColors.greenColor,
                                    onTap: () {

                                      _authenticate().then((value) async {
                                        if (_authorized == 'Authorized') {
                                          _fingerprintAnimStopped = false;
                                          if (list.length > 1) {
                                            showCupertinoModalPopup(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return CupertinoActionSheet(
                                                    title: const Text('Account'),
                                                    message: const Text(
                                                        'Choose in which account would you like to sign-in'),
                                                    cancelButton:
                                                    CupertinoActionSheetAction(
                                                      child: const Text('Cancel'),
                                                      isDefaultAction: true,
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, 'Cancel');
                                                      },
                                                    ),
                                                    actions: List.generate(
                                                        list.length, (index) {
                                                      return CupertinoActionSheetAction(
                                                          child: Text(
                                                              list[index].email),
                                                          onPressed: () {
                                                            //log-in with the account
                                                            Navigator.pop(context,
                                                                'Cancel');
                                                          });
                                                    }),
                                                  );
                                                });
                                          }
                                          else {
                                            print(
                                                "logging in! ${list.first.password}");
                                            String auth = await context
                                                .read<UserProvider>()
                                                .login(list.first.email,
                                                list.first.password);
                                            if (auth == '') {
                                              final home = SplashScreen(
                                                dao: widget.dao,
                                              );
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                    home,
                                                  ),
                                                      (route) => false);
                                            }
                                          }
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FlareActor("assets/fingerprint.flr",
                                              isPaused: _fingerprintAnimStopped,
                                              fit: BoxFit.contain,
                                              animation: "Untitled"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: FractionalOffset.bottomCenter,
                                      child: InkWell(
                                        onTap: openBottomSheet,
                                        child: Container(
                                          child: Text(
                                            "Login with Email and Password instead",
                                            style: TextStyle(
                                                fontFamily: 'Raleway',
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void getSavedData() async {
    try {
      nameController.text = await _storage.read(key: 'email');
      passwordController.text = await _storage.read(key: 'password');
    } catch (e) {
      //
    }
  }

  @override
  void dispose() {
    _state = null;
    super.dispose();
  }

  Future<void> fetchAccounts() async {

     var users = await widget.dao.fetchEnabledBiometricUsers();
     list.addAll(users);
     print("Accounts with biometric: ${users.length}");
  }

  void openBottomSheet() {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final textFieldHeight = 45.0;
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
        ),
        context: context,
        builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: _height*.8,
              decoration: BoxDecoration(
              color: Colors.white,
                borderRadius: BorderRadius.circular(25)
            ),
              child: Stack(
                children: [
                  Container(
                  height: _height,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 5,
                            width: 50,
                            decoration: BoxDecoration(
                                color: GlobalColors.greyTextColor.withOpacity(.3),
                              borderRadius: BorderRadius.circular(25)
                            ),
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: Container(
                                          // height: textFieldHeight,
                                          child: TextFormField(
                                            validator: (value) =>
                                                EmailValidator.validate(value)
                                                    ? null
                                                    : "E-mail address is not valid",
                                            controller: nameController,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            autofocus: false,
                                            style: new TextStyle(
                                                fontSize: 15.0,
                                                fontFamily: 'Raleway',
                                                color: GlobalColors.greyTextColor),
                                            decoration: const InputDecoration(
                                              errorStyle: TextStyle(
                                                  fontFamily: 'Raleway',
                                                  color: GlobalColors.orangeColor),
                                              contentPadding: EdgeInsets.symmetric(
                                                  vertical: 10.0, horizontal: 10.0),
                                              filled: true,
                                              fillColor: Colors.white,
                                              hintText: 'johndoe@example.com',
                                              focusColor: GlobalColors.greenColor,
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: GlobalColors.blueColor),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0)),
                                              ),
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: GlobalColors.blueColor),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0)),
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: GlobalColors.greenColor,
                                                    width: 2),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0)),
                                              ),
                                              errorBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: GlobalColors.orangeColor,
                                                    width: 2),
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
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
                                                    color:
                                                        GlobalColors.greyTextColor),
                                                decoration: const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 1.0,
                                                            horizontal: 10.0),
                                                    errorStyle: TextStyle(
                                                        fontFamily: 'Raleway',
                                                        color: GlobalColors
                                                            .orangeColor),
                                                    errorText: null,
                                                    errorMaxLines: 1,
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    hintText: 'password1234',
                                                    focusColor:
                                                        GlobalColors.greenColor,
                                                    enabledBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: GlobalColors
                                                              .greenColor),
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                              Radius.circular(
                                                                  50.0)),
                                                    ),
                                                    border:
                                                        const OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: GlobalColors
                                                              .greenColor),
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                              Radius.circular(
                                                                  50.0)),
                                                    ),
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: GlobalColors
                                                              .greenColor,
                                                          width: 1.5),
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                              Radius.circular(
                                                                  50.0)),
                                                    ),
                                                    errorBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: GlobalColors
                                                              .orangeColor,
                                                          width: 1.5),
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                              Radius.circular(
                                                                  50.0)),
                                                    )),
                                              ),
                                            ),
                                            if (logging)
                                              Container(
                                                height: textFieldHeight,
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 15.0),
                                                      child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              _showPassword =
                                                                  !_showPassword;
                                                              eye = _showPassword
                                                                  ? FaIcon(
                                                                      FontAwesomeIcons
                                                                          .eye,
                                                                      color: GlobalColors
                                                                          .greenColor,
                                                                    )
                                                                  : FaIcon(
                                                                      FontAwesomeIcons
                                                                          .eyeSlash,
                                                                      color: GlobalColors
                                                                          .greenColor,
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
                                                    horizontal: 25.0,
                                                    vertical: 5.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Remember me",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: 'Raleway',
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 25.0),
                                                child: CircularCheckBox(
                                                  value: this.selected,
                                                  activeColor:
                                                      GlobalColors.greenColor,
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize.padded,
                                                  inactiveColor: Colors.white,
                                                  hoverColor: Colors.white,
                                                  checkColor: Colors.white,
                                                  focusColor: Colors.white,
                                                  onChanged: (value) =>
                                                      this.setState(() {
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
                                                    horizontal: 25.0,
                                                    vertical: 5.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Password again",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontFamily: 'Raleway',
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600),
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
                                                          if (value !=
                                                              passwordController
                                                                  .text) {
                                                            return "Passwords do not match!";
                                                          }
                                                          return null;
                                                        },
                                                        keyboardType: TextInputType
                                                            .visiblePassword,
                                                        controller:
                                                            repasswordController,
                                                        obscureText: true,
                                                        style: new TextStyle(
                                                            fontSize: 15.0,
                                                            fontFamily: 'Raleway',
                                                            color: GlobalColors
                                                                .greyTextColor),
                                                        decoration:
                                                            const InputDecoration(
                                                                contentPadding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            1.0,
                                                                        horizontal:
                                                                            10.0),
                                                                errorStyle: TextStyle(
                                                                    fontFamily:
                                                                        'Raleway',
                                                                    color: GlobalColors
                                                                        .orangeColor),
                                                                errorText: null,
                                                                errorMaxLines: 1,
                                                                filled: true,
                                                                fillColor:
                                                                    Colors.white,
                                                                hintText:
                                                                    'password1234',
                                                                focusColor:
                                                                    GlobalColors
                                                                        .greenColor,
                                                                enabledBorder:
                                                                    const OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: GlobalColors
                                                                          .greenColor),
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              50.0)),
                                                                ),
                                                                border:
                                                                    const OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: GlobalColors
                                                                          .greenColor),
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              50.0)),
                                                                ),
                                                                focusedBorder:
                                                                    const OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: GlobalColors
                                                                          .greenColor,
                                                                      width: 1.5),
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              50.0)),
                                                                ),
                                                                errorBorder:
                                                                    const OutlineInputBorder(
                                                                  borderSide: const BorderSide(
                                                                      color: GlobalColors
                                                                          .orangeColor,
                                                                      width: 1.5),
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              50.0)),
                                                                )),
                                                      ),
                                                    ),
                                                    if (logging)
                                                      Container(
                                                        height: textFieldHeight,
                                                        child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          15.0),
                                                              child: InkWell(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      _showPassword =
                                                                          !_showPassword;
                                                                      eye = _showPassword
                                                                          ? FaIcon(
                                                                              FontAwesomeIcons
                                                                                  .eye,
                                                                              color:
                                                                                  GlobalColors.greenColor,
                                                                            )
                                                                          : FaIcon(
                                                                              FontAwesomeIcons
                                                                                  .eyeSlash,
                                                                              color:
                                                                                  GlobalColors.greenColor,
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
                                    fadeDuration: const Duration(milliseconds: 200),
                                    sizeDuration: const Duration(milliseconds: 200),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
                  Positioned(
                    bottom: _height / 18,
                    left: _width / 10,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: _height / 3,
                        width: _width * .8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: CustomElevation(
                                color: CupertinoColors.black.withOpacity(.15),
                                child: FlatButton(
                                  minWidth: _width / 2,
                                  color: GlobalColors.greenColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0)),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        _state = 1;
                                      });
                                      if (logging) {
                                        Future.delayed(
                                            const Duration(milliseconds: 300),
                                                () async {
                                              // print(nameController.text);
                                              String authenticate = await context
                                                  .read<UserProvider>()
                                                  .login(nameController.text,
                                                  passwordController.text);
                                              if (authenticate == '') {
                                                setState(() {
                                                  _state = 2;
                                                });
                                                print(widget.dao);
                                                if (widget.dao != null) {
                                                  final user = UserData(
                                                      1,
                                                      nameController.text,
                                                      passwordController.text,
                                                      true);
                                                  // await widget.dao.deleteUser(user);
                                                  await widget.dao.insertUser(user);
                                                }

                                                Future.delayed(
                                                    const Duration(milliseconds: 300),
                                                        () {
                                                      //Save login data
                                                      if (selected) {
                                                        _storage.write(
                                                            key: 'email',
                                                            value: nameController.text);
                                                        _storage.write(
                                                            key: 'password',
                                                            value: passwordController.text);
                                                        // print("saved");
                                                      } else {
                                                        _storage.delete(key: 'email');
                                                        _storage.delete(key: 'password');
                                                      }

                                                      final home = SplashScreen(
                                                        dao: widget.dao,
                                                      );
                                                      Navigator.of(context)
                                                          .pushAndRemoveUntil(
                                                          CupertinoPageRoute(
                                                            builder: (context) => home,
                                                          ),
                                                              (route) => false);
                                                    });
                                              } else {
                                                setState(() {
                                                  _state = 0;
                                                });
                                                Widget toast = CustomToast(
                                                    color: GlobalColors.fireColor,
                                                    icon: FontAwesomeIcons
                                                        .exclamationCircle,
                                                    text: "$authenticate");
                                                fToast.showToast(
                                                  child: toast,
                                                  gravity: ToastGravity.BOTTOM,
                                                  toastDuration: Duration(seconds: 3),
                                                );
                                              }
                                            });
                                      } else {
                                        Future.delayed(
                                            const Duration(milliseconds: 300),
                                                () async {
                                              String authenticate =
                                              await Provider.of<UserProvider>(context,
                                                  listen: false)
                                                  .register(nameController.text,
                                                  passwordController.text);
                                              passwordController.clear();
                                              nameController.clear();
                                              if (authenticate == null) {
                                                setState(() {
                                                  _state = 2;
                                                });
                                                Future.delayed(
                                                    const Duration(milliseconds: 300),
                                                        () {
                                                      setState(() {
                                                        logging = true;
                                                        _state = 1;
                                                      });
                                                    });
                                              } else {
                                                // print(auth);
                                                setState(() {
                                                  _state = 0;
                                                });
                                                Fluttertoast.showToast(
                                                    msg: "$authenticate",
                                                    toastLength: Toast.LENGTH_LONG,
                                                    backgroundColor:
                                                    GlobalColors.orangeColor,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 2);
                                              }
                                            });
                                      }
                                    }
                                  },
                                  child: Container(
                                      height: _height / 20,
                                      width: _width / 2,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          buttonChild(),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20.0),
                                            child: FaIcon(
                                              FontAwesomeIcons.longArrowAltRight,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomElevation(
                                color: CupertinoColors.black.withOpacity(.05),
                                child: FlatButton(
                                    minWidth: _width / 2,
                                    color: GlobalColors.lightGreenColor,
                                    highlightColor:
                                    GlobalColors.greenColor.withOpacity(.77),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        logging = !logging;
                                        if (!logging) {
                                          nameController.clear();
                                          passwordController.clear();
                                          repasswordController.clear();
                                        }
                                      });
                                    },
                                    child: Container(
                                      height: textFieldHeight,
                                      width: _width / 2,
                                      child: Center(
                                        child: Text(
                                          logging ? "Register" : "Back to login",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Raleway',
                                              color: GlobalColors.greenColor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ), //BUTTONS
                ],
              ),
            );
          }
        );

    });
  }
}

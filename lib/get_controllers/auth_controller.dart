import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:show_time/database/database.dart';
import 'package:show_time/database/user_data.dart';
import 'package:show_time/database/user_data_dao.dart';
import 'package:show_time/models/user.dart';
import 'package:show_time/models/user.dart';
import 'package:show_time/network/firebase_utils.dart';
import 'package:show_time/pages/home.dart';
import 'package:show_time/pages/login.dart';
import 'package:show_time/pages/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class AuthController extends GetxController {
  Rx<SessionUser> sessionUser = Rx<SessionUser>();
  //TODO: resolve floor dependency issue
  var usersWithBiometricAuth = <UserData>[].obs;
  late UserDao _dao;
  UserDao get dao => _dao;
  bool selected = false;

  FirebaseAuth _auth = FirebaseAuth.instance;
  SessionUser? get user => sessionUser.value;


  final Duration _loginTime = Duration(milliseconds: 500);
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final _storage = FlutterSecureStorage();

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  TextEditingController resetController = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();
    final database = await $FloorAppDatabase.databaseBuilder('users.db').build();
    _dao = database.userDao;
    getUserData();
    fetchAccounts();
    getSavedData();

    _checkBiometrics();
    print(_canCheckBiometrics);
    _getAvailableBiometrics();
  }

  void getSavedData() async {
    try {
      nameController.text = (await _storage.read(key: 'email'))!;
      passwordController.text = (await _storage.read(key: 'password'))!;
    } catch (e) {
    }
  }
  void getUserData() {
    SessionUser user = SessionUser(firstName: '', emailAddress: '', lastName: '', age: 0, sex: '');
    FirebaseFirestore.instance
        .doc("${_auth.currentUser?.email}/user")
        .snapshots()
        .first
        .then((element) {
      if (element.exists) {
        user.id = _auth.currentUser!.uid;
        user.emailAddress = _auth.currentUser!.email!;
        user.firstName = element.data()!['firstName'];
        user.lastName = element.data()!['lastName'];
        user.sex = element.data()!['sex'];
        user.age = element.data()!['age'];
        sessionUser.value = user;
      }
    });
  }

  Future<String> login(String userName, String password) {
    // print('Name: ${userName}, Password: ${password}');
    return Future.delayed(_loginTime).then((_) async {
      try {
        await _auth.signInWithEmailAndPassword(email: userName, password: password);
        return '';
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return 'Username does not exist';
        } else if (e.code == 'wrong-password') {
          return 'Wrong password!';
        } else {
          return e.code;
        }
      }
    });
  }

   register(String userName, String password) {
    // print('Name: ${data.name}, Password: ${data.password}');

    return Future.delayed(_loginTime).then((_) async {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: userName, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          return 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          return 'The account already exists for that email.';
        }
      } catch (e) {
        return e.toString();
      }
      return null;
    });
  }

  void signOut() async {
    await _auth.signOut().then((value) => Get.offAll(LoginScreen()));
  }





  void signInWithGoogle() async {
    await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount = (await googleSignIn.signIn())!;
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
        .authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    await _auth.signInWithCredential(credential).then((result) {
      print("result:$result");
      if (result != null) {
        Get.off(SplashScreen());
      }
    });
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
    print("User Signed Out");
  }




  Future<void> fetchAccounts() async {
    await Future.delayed(Duration(seconds: 1));
    List<UserData> users = (await dao.fetchEnabledBiometricUsers())!;
    usersWithBiometricAuth.addAll(users);
    print("Accounts with biometric: ${usersWithBiometricAuth.length}");
  }
  Future<void> addUser(String email, String password) async {
    if (_dao != null && usersWithBiometricAuth.where((user) => user.email == email).toList().isEmpty) {
      final temp = UserData(
          0,
          user!.id,
          email,
          password,
          true);
      print(temp);
      await _dao.insertUser(temp); //no error
      print("User inserted!");
    }
  }

  deleteUser(String email, String password) async {
    final temp = UserData(3, user!.id, email, password, true);
    await _dao.deleteUser(temp);
    print("User deleted!");
  }
  void setDao(UserDao userDao) {
    this._dao = userDao;
  }

  void rememberInfo(String email, String password) {
    //Save login data
    if (selected) {
      _storage.write(
          key: 'email',
          value: email);
      _storage.write(
          key: 'password',
          value: password);
      // print("saved");
    } else {
      _storage.delete(key: 'email');
      _storage.delete(key: 'password');
    }
  }



  void updateUserInfo(String firstName, String lastName, int age, String sex) {
    user!.id = _auth.currentUser!.uid;
    user!.emailAddress = _auth.currentUser!.email!;
    user!.firstName = firstName;
    user!.lastName = lastName;
    user!.age = age;
    user!.sex = sex;
    // print(currentUser);
    FirestoreUtils().updateUserInfo(user!);
  }
  @override
  void onClose() {
    super.onClose();
  }

  //region BIOMETRIC_LOGIN
  final LocalAuthentication auth = LocalAuthentication();
  late bool _canCheckBiometrics;
  bool get canCheckBiometrics => _canCheckBiometrics;

  late List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;


  Future<void> _checkBiometrics() async {
    bool canCheck = false;
    try {
      canCheck = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    // if (!mounted) return;

    // setState(() {
      _canCheckBiometrics = canCheck;
    // });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = [];
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    // if (!mounted) return;

    // setState(() {
      _availableBiometrics = availableBiometrics;
    // });
  }

  Future<String> _authenticate() async {
    bool authenticated = false;
    try {
      // setState(() {
      //   _isAuthenticating = true;
        _authorized = 'Authenticating';
      // });
      authenticated = await auth.authenticate(
          biometricOnly: true,
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      // setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      // });
    } on PlatformException catch (e) {
      print(e);
    }
    // if (!mounted) return '';

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    // setState(() {
      _authorized = message;
    // });
    return _authorized;
  }

  void _cancelAuthentication() {
    auth.stopAuthentication();
  }

  bool _fingerprintAnimStopped = true;
  bool get fingerprintAnimStopped  => _fingerprintAnimStopped;

  void authenticateUserWithFingerprint() {
    _authenticate().then((value) async {
      if (_authorized == 'Authorized') {
        _fingerprintAnimStopped = false;
        if (usersWithBiometricAuth.length > 1) {
          showCupertinoModalPopup(
              context: Get.context!,
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
                      usersWithBiometricAuth.length, (index) {
                    return CupertinoActionSheetAction(
                        child: Text(
                            usersWithBiometricAuth[index].email),
                        onPressed: () async {
                          //log-in with the biometric account
                          String auth = await login(usersWithBiometricAuth[index].email, usersWithBiometricAuth[index].password);
                          if (auth == '') {
                            Get.off(SplashScreen());
                          }
                        });
                  }),
                );
              });
        }
        else if (usersWithBiometricAuth.length == 1){
          print("logging in! ${usersWithBiometricAuth.first.password}");
          String auth = await login(usersWithBiometricAuth.first.email, usersWithBiometricAuth.first.password);
          if (auth == '') {
            Get.off(() => SplashScreen(), transition: Transition.fadeIn);
          }
        }
        else{
          print(usersWithBiometricAuth.length);
        }
      }
    });
  }
}
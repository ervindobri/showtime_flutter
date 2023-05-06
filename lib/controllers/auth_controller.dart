// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:show_time/database/user_data.dart';
import 'package:show_time/database/user_data_dao.dart';
import 'package:show_time/models/user.dart';
import 'package:show_time/network/firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  ValueNotifier<String?> currentUserEmail = ValueNotifier(null);
  ValueNotifier<SessionUser> sessionUser = ValueNotifier<SessionUser>(
      SessionUser(
          id: 0, firstName: "", lastName: "", email: "", age: 0, sex: ""));
  ValueNotifier<List<UserData>> usersWithBiometricAuth =
      ValueNotifier(<UserData>[]);
  late UserDao _dao;
  UserDao get dao => _dao;
  bool selected = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  SessionUser? get user => sessionUser.value;

  final Duration _loginTime = const Duration(milliseconds: 500);
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final _storage = const FlutterSecureStorage();

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  TextEditingController resetController = TextEditingController();

  // @override
  // Future<void> onInit() async {
  //   super.onInit();
  //   getUserData();

  //   if (!kIsWeb) {
  //     final database =
  //         await $FloorAppDatabase.databaseBuilder('users.db').build();
  //     _dao = database.userDao;
  //     fetchAccounts();
  //     getSavedData();
  //     _checkBiometrics();
  //     _getAvailableBiometrics();
  //   }
  //   nameController.text = "dobriervin@yahoo.com";
  //   passwordController.text = "djcaponegood";
  //   print("Set default login data!");
  // }

  void getSavedData() async {
    try {
      nameController.text = (await _storage.read(key: 'email'))!;
      passwordController.text = (await _storage.read(key: 'password'))!;
      // ignore: empty_catches
    } catch (e) {
      print(e);
    }
  }

  void getUserData() {
    SessionUser user =
        SessionUser(firstName: '', email: '', lastName: '', age: 0, sex: '');
    FirebaseFirestore.instance
        .doc("${_auth.currentUser?.email}/user")
        .snapshots()
        .first
        .then((element) {
      if (element.exists) {
        user.id = _auth.currentUser!.uid;
        user.email = _auth.currentUser!.email!;
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
        await _auth.signInWithEmailAndPassword(
            email: userName, password: password);
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
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: userName, password: password);
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
    // await _auth.signOut().then((value) => Get.offAll(const LoginScreen()));
  }

  void signInWithGoogle() async {
    await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount =
        (await googleSignIn.signIn())!;
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    await _auth.signInWithCredential(credential).then((result) {
      print("result:$result");
      // Get.off(const SplashScreen());
    });
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
    print("User Signed Out");
  }

  Future<void> fetchAccounts() async {
    await Future.delayed(const Duration(seconds: 1));
    List<UserData> users = (await dao.fetchEnabledBiometricUsers())!;
    usersWithBiometricAuth.value.addAll(users);
    print("Accounts with biometric: ${usersWithBiometricAuth.value.length}");
  }

  Future<void> addUser(String email, String password) async {
    if (usersWithBiometricAuth.value
        .where((user) => user.email == email)
        .toList()
        .isEmpty) {
      final temp = UserData(0, user!.id, email, password, true);
      print(temp);
      await _dao.insertUser(temp); //no error
      print("User inserted!");
    }
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

  deleteUser(String email, String password) async {
    final temp = UserData(3, user!.id, email, password, true);
    await _dao.deleteUser(temp);
    print("User deleted!");
  }

  void setDao(UserDao userDao) {
    _dao = userDao;
  }

  void rememberInfo(String email, String password) {
    //Save login data
    if (selected) {
      _storage.write(key: 'email', value: email);
      _storage.write(key: 'password', value: password);
      // print("saved");
    } else {
      _storage.delete(key: 'email');
      _storage.delete(key: 'password');
    }
  }

  void updateUserInfo(String firstName, String lastName, int age, String sex) {
    user!.id = _auth.currentUser!.uid;
    user!.email = _auth.currentUser!.email!;
    user!.firstName = firstName;
    user!.lastName = lastName;
    user!.age = age;
    user!.sex = sex;
    // print(currentUser);
    FirestoreUtils().updateUserInfo(user!);
  }

  //region BIOMETRIC_LOGIN
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool get canCheckBiometrics => _canCheckBiometrics;

  late List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';

  Future<void> _checkBiometrics() async {
    bool canCheck = false;
    try {
      canCheck = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    _canCheckBiometrics = canCheck;
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = [];
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    _availableBiometrics = availableBiometrics;
    print(_availableBiometrics);
  }

  Future<String> _authenticate() async {
    bool authenticated = false;
    try {
      // setState(() {
      //   _isAuthenticating = true;
      _authorized = 'Authenticating';
      // });
      authenticated = await auth.authenticate(
        // biometricOnly: true,
        localizedReason: 'Scan your fingerprint to authenticate',
        // useErrorDialogs: true,
        // stickyAuth: true,
      );
      // setState(() {
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

  // void _cancelAuthentication() {
  // auth.stopAuthentication();
  // }

  bool _fingerprintAnimStopped = true;
  bool get fingerprintAnimStopped => _fingerprintAnimStopped;

  void authenticateUserWithFingerprint() {
    _authenticate().then((value) async {
      if (_authorized == 'Authorized') {
        _fingerprintAnimStopped = false;
        if (usersWithBiometricAuth.value.length > 1) {
          // showCupertinoModalPopup(
          // context: context!,
          //     builder: (BuildContext context) {
          //       return CupertinoActionSheet(
          //         title: const Text('Account'),
          //         message: const Text(
          //             'Choose in which account would you like to sign-in'),
          //         cancelButton: CupertinoActionSheetAction(
          //           child: const Text('Cancel'),
          //           isDefaultAction: true,
          //           onPressed: () {
          //             Navigator.pop(context, 'Cancel');
          //           },
          //         ),
          //         actions:
          //             List.generate(usersWithBiometricAuth.value.length, (index) {
          //           return CupertinoActionSheetAction(
          //               child: Text(usersWithBiometricAuth.value[index].email),
          //               onPressed: () async {
          //                 //log-in with the biometric account
          //                 String auth = await login(
          //                     usersWithBiometricAuth.value[index].email,
          //                     usersWithBiometricAuth.value[index].password);
          //                 if (auth == '') {
          //                   // Get.off(const SplashScreen());
          //                 }
          //               });
          //         }),
          //       );
          //     });
        } else if (usersWithBiometricAuth.value.length == 1) {
          print("logging in! ${usersWithBiometricAuth.value.first.password}");
          String auth = await login(usersWithBiometricAuth.value.first.email,
              usersWithBiometricAuth.value.first.password);
          if (auth == '') {
            // Get.off(() => const SplashScreen(), transition: Transition.fadeIn);
          }
        } else {
          print(usersWithBiometricAuth.value.length);
        }
      }
    });
  }
}

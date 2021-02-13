import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eWoke/database/database.dart';
import 'package:eWoke/database/user_data.dart';
import 'package:eWoke/database/user_data_dao.dart';
import 'package:eWoke/models/user.dart';
import 'package:eWoke/network/firebase_utils.dart';
import 'package:eWoke/pages/home.dart';
import 'package:eWoke/pages/login.dart';
import 'package:eWoke/pages/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  Rx<SessionUser> sessionUser = Rx<SessionUser>();
  var usersWithBiometricAuth = List<UserData>().obs;
  bool selected = false;

  FirebaseAuth _auth = FirebaseAuth.instance;
  SessionUser get user => sessionUser.value;

  UserDao _dao;
  UserDao get dao => _dao;

  final Duration _loginTime = Duration(milliseconds: 500);
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final _storage = FlutterSecureStorage();

  @override
  Future<void> onInit() async {
    super.onInit();
    getUserData();
    fetchAccounts();
  }

  void getUserData() {
    SessionUser user = SessionUser();
    FirebaseFirestore.instance
        .doc("${_auth.currentUser?.email}/user")
        .snapshots()
        .first
        .then((element) {
      if (element.exists) {
        user.id = _auth.currentUser.uid;
        user.emailAddress = _auth.currentUser.email;
        user.firstName = element.data()['firstName'];
        user.lastName = element.data()['lastName'];
        user.sex = element.data()['sex'];
        user.age = element.data()['age'];
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

  Future<String> register(String userName, String password) {
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

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
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
    var users = await dao.fetchEnabledBiometricUsers();
    usersWithBiometricAuth.addAll(users);
    print("Accounts with biometric: ${usersWithBiometricAuth.length}");
  }



  @override
  void onClose() {
    super.onClose();
  }

  Future<void> addUser(String email, String password) async {
    if (_dao != null && usersWithBiometricAuth.where((user) => user.email == email).toList().isEmpty) {
      final temp = UserData(null, user.id, email, password, true);
      print(temp);
      await _dao.insertUser(temp); //no error
      print("User inserted!");
    }
  }

  deleteUser(String email, String password) async {
    final temp = UserData(3, user.id, email, password, true);
    await _dao.deleteUser(temp);
    print("User deleted!");
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

  void setDao(UserDao userDao) {
    this._dao = userDao;
  }

  void updateUserInfo(String firstName, String lastName, int age, String sex) {
    user.id = _auth.currentUser.uid;
    user.emailAddress = _auth.currentUser.email;
    user.firstName = firstName;
    user.lastName = lastName;
    user.age = age;
    user.sex = sex;
    // print(currentUser);
    FirestoreUtils().updateUserInfo(user);
  }
}
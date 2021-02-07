import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eWoke/database/database.dart';
import 'package:eWoke/database/user_data_dao.dart';
import 'package:eWoke/models/user.dart';
import 'package:eWoke/pages/home.dart';
import 'package:eWoke/pages/login.dart';
import 'package:eWoke/pages/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  Rx<SessionUser> sessionUser = Rx<SessionUser>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  String get user => sessionUser.value?.firstName;

  UserDao _dao;

  UserDao get dao => _dao;
  final Duration _loginTime = Duration(milliseconds: 500);

  final GoogleSignIn googleSignIn = GoogleSignIn();


  @override
  Future<void> onInit() async {
    super.onInit();
    getUserData();
    final database = await $FloorAppDatabase
        .databaseBuilder('users.db')
        .build();
    _dao = database.userDao;
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
    return null;
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
        Get.to(SplashScreen());
      }
    });
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }

  @override
  void onClose() {
    super.onClose();
  }
}
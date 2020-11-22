import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eWoke/models/user.dart';
import 'package:eWoke/network/firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }


class UserProvider  with ChangeNotifier {

  Status _status = Status.Uninitialized;
  Status get status => _status;

  FirebaseAuth _auth;

  User _user;
  User get user => _user;

  bool _disposed = false;

  UserProvider.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  initUserProvider() async {
    String email = await FlutterSecureStorage().read(key: 'email');
    String password = await FlutterSecureStorage().read(key: 'password');
    print(email + password);

    if ( email != null && password != null){
     _status = Status.Authenticated;
    }
    else{
      _status = Status.Unauthenticated;
    }
    notifyListeners();
  }

  final Duration _loginTime = Duration(milliseconds: 500);

  Future<SessionUser> getUserData() async {
    SessionUser user = SessionUser();
    FirebaseFirestore.instance.doc("${_auth.currentUser?.email}/user").snapshots().first.then((element) {
      if ( element.exists){
        user.id = _auth.currentUser.uid;
        user.emailAddress = _auth.currentUser.email;
        user.firstName = element.data()['firstName'];
        user.lastName = element.data()['lastName'];
        user.sex = element.data()['sex'];
        user.age = element.data()['age'];
        return user;
      }
    });
    return user;
  }

  void saveProfile(String firstName, String lastName, int age, String sex) {
    FirestoreUtils().userProfile.set({
      'age' : age,
      'firstName' : firstName,
      'lastName' : lastName,
      'sex' : sex
    });
  }

  Future<String> login(String userName, String password) {
    // print('Name: ${userName}, Password: ${password}');
    return Future.delayed(_loginTime).then((_) async {
      try {
        _status = Status.Authenticating;
        notifyListeners();
        await _auth.signInWithEmailAndPassword(email: userName, password: password);
      } on FirebaseAuthException catch (e) {
        _status = Status.Unauthenticated;
        notifyListeners();
        if (e.code == 'user-not-found') {
          return 'Username does not exist';
        } else if (e.code == 'wrong-password') {
          return 'Wrong password!';
        } else {
          return e.code;
        }
      }
      return null;
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

  //Method to handle user signing out
  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
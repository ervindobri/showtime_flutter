import 'package:firebase_auth/firebase_auth.dart';
import 'package:show_time/core/error/exceptions.dart';
import 'package:show_time/features/authentication/domain/usecases/post_login.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> postLogin(
      LoginType type, String email, String password);
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final FirebaseAuth firebase;
  AuthRemoteDataSourceImpl({required this.firebase});

  @override
  Future<UserCredential> postLogin(
      LoginType type, String email, String password) {
    switch (type) {
      case LoginType.email:
        return _postEmailLogin(email, password);
        // break;
      // case LoginType.google:
      //   return _postEmailLogin(email, password);

      //   break;
      default:
        return _postEmailLogin(email, password);
        // break;
    }
  }

  Future<UserCredential> _postEmailLogin(String email, String password) async {
    try {
      final uc = await firebase.signInWithEmailAndPassword(
          email: email, password: password);
      // print("User credential: $uc");
      return uc;
    } on FirebaseAuthException catch (e) {
      throw CustomServerException(e.code);
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:show_time/features/authentication/domain/usecases/post_login.dart';

abstract class AuthRepository {
  postLogin(LoginType type, String email, String password);
  postRegister(String email, String password);

}

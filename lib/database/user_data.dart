import 'package:floor/floor.dart';

@entity
class UserData{
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String uid;
  final String email;
  final String password;
  final bool biometrics;

  UserData( this.id, this.uid, this.email, this.password, this.biometrics, );

  @override
  String toString() {
    return 'UserData{id: $id, email: $email, password: $password, biometrics: $biometrics}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          uid == other.uid &&
          email == other.email &&
          password == other.password &&
          biometrics == other.biometrics;

  @override
  int get hashCode =>
      id.hashCode ^
      uid.hashCode ^
      email.hashCode ^
      password.hashCode ^
      biometrics.hashCode;
}
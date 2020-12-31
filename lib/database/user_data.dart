import 'package:floor/floor.dart';

@entity
class UserData{
  @primaryKey
  final int id;

  final String email;
  final bool biometrics;

  UserData(this.id, this.email, this.biometrics);
}
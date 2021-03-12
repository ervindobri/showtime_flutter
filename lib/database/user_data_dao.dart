
// dao/person_dao.dart
import 'package:floor/floor.dart';
import 'package:show_time/database/user_data.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM userdata')
  Future<List<UserData?>> findAllPersons();


  @Query('SELECT * FROM userdata WHERE id = :id')
  Stream<UserData?> findUserById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUser(UserData user);


  @Query('SELECT * FROM userdata WHERE email = :email')
  Future<UserData?> findUserByEmail(String email);

  @Query('SELECT * FROM userdata WHERE biometrics = 1')
  Future<List<UserData>?> fetchEnabledBiometricUsers();

  @delete
  Future<void> deleteUser(UserData user);

}
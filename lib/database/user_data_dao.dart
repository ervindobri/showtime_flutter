
// dao/person_dao.dart
import 'package:eWoke/database/user_data.dart';
import 'package:floor/floor.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM userdata')
  Future<List<UserData>> findAllPersons();


  @Query('SELECT * FROM userdata WHERE id = :id')
  Stream<UserData> findUserById(int id);

  @insert
  Future<void> insertUser(UserData user);
}

// database.dart

// required package imports
import 'dart:async';
import 'package:eWoke/database/user_data.dart';
import 'package:eWoke/database/user_data_dao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;


part "database.g.dart"; // the generated code will be there

@Database(version: 1, entities: [UserData])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
}
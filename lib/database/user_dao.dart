import 'package:floor/floor.dart';
import 'package:tchat_app/models/user_model.dart';

@dao
abstract class UserDao {

  @Query('SELECT * FROM UserModel')
  Future<List<UserModel>> findAllUsers();

  @Query('SELECT * FROM UserModel WHERE id = :id LIMIT 1')
  Future<UserModel> findUserById(String id);

  @Query('SELECT * FROM UserModel LIMIT 1')
  Future<UserModel> getSingleUser();

  @insert
  Future<void> InsertUser(UserModel user);

  @Query("DELETE * FROM UserModel")
  Future<void> deleteAllUsers();

  // @transaction
  // Future<void> replaceUsers(List<UserData> users) async {
  //   await deleteAllUsers();
  // //  await insertUsers(users);
  // }
}
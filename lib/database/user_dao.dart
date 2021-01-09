import 'package:floor/floor.dart';
import 'package:tchat_app/models/account_model.dart';

@dao
abstract class UserDao {

  @Query('SELECT * FROM AccountModel')
  Future<List<AccountModel>> findAllUsers();

  @Query('SELECT * FROM AccountModel WHERE id = :id LIMIT 1')
  Future<AccountModel> findUserById(String id);

  @Query('SELECT * FROM AccountModel LIMIT 1')
  Future<AccountModel> getSingleUser();

  @insert
  Future<void> InsertUser(AccountModel user);

  @Query('DELETE FROM AccountModel')
  Future<void> deleteAllUsers();

  @update
  Future<void> updateUser(AccountModel user);


  // @transaction
  // Future<void> replaceUsers(List<UserData> users) async {
  //   await deleteAllUsers();
  // //  await insertUsers(users);
  // }
}
import 'package:floor/floor.dart';
import 'package:tchat_app/models/message._model.dart';

@dao
abstract class MessageDao {

  @Query('SELECT * FROM MessageModel')
  Future<List<MessageModel>> getAllMessage();

  @Query('SELECT * FROM MessageModel WHERE id = :id LIMIT 1')
  Future<MessageModel> getMessageById(String id);

  @Query('SELECT * FROM MessageModel GROUP BY idTo ORDER BY timestamp DESC LIMIT 1')//  DESC ASC
  Future<List<MessageModel>> getLastMessage();

  @Query('SELECT * FROM MessageModel LIMIT 1')
  Future<MessageModel> getSingleMessage();

  @insert
  Future<void> insertMessage(MessageModel message);

  @Query("DELETE * FROM MessageModel")
  Future<void> deleteAllMessage();

// @transaction
// Future<void> replaceUsers(List<UserData> users) async {
//   await deleteAllUsers();
// //  await insertUsers(users);
// }
}
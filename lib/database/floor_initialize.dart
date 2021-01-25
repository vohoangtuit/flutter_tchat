import 'package:tchat_app/database/database.dart';
import 'package:tchat_app/database/user_dao.dart';

import 'last_message_dao.dart';
import 'message_dao.dart';

class FloorInitialize {
  TChatAppDatabase database;
  UserDao userDao;
  MessageDao messageDao;
  LastMessageDao lastMessageDao;
   init()async{
    database = await $FloorTChatAppDatabase.databaseBuilder('TChatApp.db').build();
    userDao = database.userDao;
    messageDao =database.messageDao;
    lastMessageDao =database.lastMessageDao;
  }
  getUserDao() =>userDao;
  getMessageDao() =>messageDao;
  getLastMessageDao() =>lastMessageDao;
}
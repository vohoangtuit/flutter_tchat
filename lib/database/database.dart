import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:tchat_app/database/message_dao.dart';
import 'package:tchat_app/database/user_dao.dart';
import 'package:tchat_app/models/last_message_model.dart';
import 'package:tchat_app/models/message._model.dart';
import 'package:tchat_app/models/account_model.dart';

import 'last_message_dao.dart';

// todo: run comment to create database: flutter packages pub run build_runner build
part 'database.g.dart'; // the generated code will be there
//
@Database(version: 1, entities: [AccountModel,MessageModel,LastMessageModel])
abstract class TChatAppDatabase extends FloorDatabase {
  UserDao get userDao;
  MessageDao get messageDao;
  LastMessageDao get lastMessageDao;
}
// todo: fix if cannot run terminal build_runner on macbook : https://www.youtube.com/watch?v=kIcwX_w3Xw8
// export PATH="/Volumes/DATA/Develop/AndroidStudio/FlutterSDK/flutter/bin:$PATH"
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:tchat_app/database/message_dao.dart';
import 'package:tchat_app/database/user_dao.dart';
import 'package:tchat_app/models/message._model.dart';
import 'package:tchat_app/models/user_model.dart';

// todo: run comment to create database: flutter packages pub run build_runner build
part 'database.g.dart'; // the generated code will be there
//
@Database(version: 2, entities: [UserModel,MessageModel])
abstract class TChatAppDatabase extends FloorDatabase {
  UserDao get userDao;
  MessageDao get messageDao;
}
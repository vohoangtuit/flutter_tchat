// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorTChatAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$TChatAppDatabaseBuilder databaseBuilder(String name) =>
      _$TChatAppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$TChatAppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$TChatAppDatabaseBuilder(null);
}

class _$TChatAppDatabaseBuilder {
  _$TChatAppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$TChatAppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$TChatAppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<TChatAppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$TChatAppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$TChatAppDatabase extends TChatAppDatabase {
  _$TChatAppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao _userDaoInstance;

  MessageDao _messageDaoInstance;

  LastMessageDao _lastMessageDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserModel` (`idDB` INTEGER PRIMARY KEY AUTOINCREMENT, `id` TEXT, `userName` TEXT, `fullName` TEXT, `birthday` TEXT, `email` TEXT, `photoURL` TEXT, `statusAccount` INTEGER, `phoneNumber` TEXT, `createdAt` TEXT, `pushToken` TEXT, `isLogin` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MessageModel` (`idDB` INTEGER PRIMARY KEY AUTOINCREMENT, `idSender` TEXT, `nameSender` TEXT, `photoSender` TEXT, `idReceiver` TEXT, `nameReceiver` TEXT, `photoReceiver` TEXT, `timestamp` TEXT, `content` TEXT, `type` INTEGER, `status` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `LastMessageModel` (`idDB` INTEGER PRIMARY KEY AUTOINCREMENT, `idReceiver` TEXT, `nameReceiver` TEXT, `photoReceiver` TEXT, `timestamp` TEXT, `content` TEXT, `type` INTEGER, `status` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  MessageDao get messageDao {
    return _messageDaoInstance ??= _$MessageDao(database, changeListener);
  }

  @override
  LastMessageDao get lastMessageDao {
    return _lastMessageDaoInstance ??=
        _$LastMessageDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userModelInsertionAdapter = InsertionAdapter(
            database,
            'UserModel',
            (UserModel item) => <String, dynamic>{
                  'idDB': item.idDB,
                  'id': item.id,
                  'userName': item.userName,
                  'fullName': item.fullName,
                  'birthday': item.birthday,
                  'email': item.email,
                  'photoURL': item.photoURL,
                  'statusAccount': item.statusAccount,
                  'phoneNumber': item.phoneNumber,
                  'createdAt': item.createdAt,
                  'pushToken': item.pushToken,
                  'isLogin':
                      item.isLogin == null ? null : (item.isLogin ? 1 : 0)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserModel> _userModelInsertionAdapter;

  @override
  Future<List<UserModel>> findAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM UserModel',
        mapper: (Map<String, dynamic> row) => UserModel(
            idDB: row['idDB'] as int,
            id: row['id'] as String,
            userName: row['userName'] as String,
            fullName: row['fullName'] as String,
            birthday: row['birthday'] as String,
            email: row['email'] as String,
            photoURL: row['photoURL'] as String,
            statusAccount: row['statusAccount'] as int,
            phoneNumber: row['phoneNumber'] as String,
            createdAt: row['createdAt'] as String,
            pushToken: row['pushToken'] as String,
            isLogin:
                row['isLogin'] == null ? null : (row['isLogin'] as int) != 0));
  }

  @override
  Future<UserModel> findUserById(String id) async {
    return _queryAdapter.query('SELECT * FROM UserModel WHERE id = ? LIMIT 1',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => UserModel(
            idDB: row['idDB'] as int,
            id: row['id'] as String,
            userName: row['userName'] as String,
            fullName: row['fullName'] as String,
            birthday: row['birthday'] as String,
            email: row['email'] as String,
            photoURL: row['photoURL'] as String,
            statusAccount: row['statusAccount'] as int,
            phoneNumber: row['phoneNumber'] as String,
            createdAt: row['createdAt'] as String,
            pushToken: row['pushToken'] as String,
            isLogin:
                row['isLogin'] == null ? null : (row['isLogin'] as int) != 0));
  }

  @override
  Future<UserModel> getSingleUser() async {
    return _queryAdapter.query('SELECT * FROM UserModel LIMIT 1',
        mapper: (Map<String, dynamic> row) => UserModel(
            idDB: row['idDB'] as int,
            id: row['id'] as String,
            userName: row['userName'] as String,
            fullName: row['fullName'] as String,
            birthday: row['birthday'] as String,
            email: row['email'] as String,
            photoURL: row['photoURL'] as String,
            statusAccount: row['statusAccount'] as int,
            phoneNumber: row['phoneNumber'] as String,
            createdAt: row['createdAt'] as String,
            pushToken: row['pushToken'] as String,
            isLogin:
                row['isLogin'] == null ? null : (row['isLogin'] as int) != 0));
  }

  @override
  Future<void> deleteAllUsers() async {
    await _queryAdapter.queryNoReturn('DELETE * FROM UserModel');
  }

  @override
  Future<void> InsertUser(UserModel user) async {
    await _userModelInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }
}

class _$MessageDao extends MessageDao {
  _$MessageDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _messageModelInsertionAdapter = InsertionAdapter(
            database,
            'MessageModel',
            (MessageModel item) => <String, dynamic>{
                  'idDB': item.idDB,
                  'idSender': item.idSender,
                  'nameSender': item.nameSender,
                  'photoSender': item.photoSender,
                  'idReceiver': item.idReceiver,
                  'nameReceiver': item.nameReceiver,
                  'photoReceiver': item.photoReceiver,
                  'timestamp': item.timestamp,
                  'content': item.content,
                  'type': item.type,
                  'status': item.status
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MessageModel> _messageModelInsertionAdapter;

  @override
  Future<List<MessageModel>> getAllMessage() async {
    return _queryAdapter.queryList('SELECT * FROM MessageModel',
        mapper: (Map<String, dynamic> row) => MessageModel(
            idDB: row['idDB'] as int,
            idSender: row['idSender'] as String,
            nameSender: row['nameSender'] as String,
            photoSender: row['photoSender'] as String,
            idReceiver: row['idReceiver'] as String,
            nameReceiver: row['nameReceiver'] as String,
            photoReceiver: row['photoReceiver'] as String,
            timestamp: row['timestamp'] as String,
            content: row['content'] as String,
            type: row['type'] as int,
            status: row['status'] as int));
  }

  @override
  Future<MessageModel> getMessageById(String id) async {
    return _queryAdapter.query(
        'SELECT * FROM MessageModel WHERE id = ? LIMIT 1',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => MessageModel(
            idDB: row['idDB'] as int,
            idSender: row['idSender'] as String,
            nameSender: row['nameSender'] as String,
            photoSender: row['photoSender'] as String,
            idReceiver: row['idReceiver'] as String,
            nameReceiver: row['nameReceiver'] as String,
            photoReceiver: row['photoReceiver'] as String,
            timestamp: row['timestamp'] as String,
            content: row['content'] as String,
            type: row['type'] as int,
            status: row['status'] as int));
  }

  @override
  Future<List<MessageModel>> getLastMessage() async {
    return _queryAdapter.queryList(
        'SELECT * FROM MessageModel GROUP BY idReceiver ORDER BY timestamp DESC',
        mapper: (Map<String, dynamic> row) => MessageModel(
            idDB: row['idDB'] as int,
            idSender: row['idSender'] as String,
            nameSender: row['nameSender'] as String,
            photoSender: row['photoSender'] as String,
            idReceiver: row['idReceiver'] as String,
            nameReceiver: row['nameReceiver'] as String,
            photoReceiver: row['photoReceiver'] as String,
            timestamp: row['timestamp'] as String,
            content: row['content'] as String,
            type: row['type'] as int,
            status: row['status'] as int));
  }

  @override
  Future<MessageModel> getSingleMessage() async {
    return _queryAdapter.query('SELECT * FROM MessageModel LIMIT 1',
        mapper: (Map<String, dynamic> row) => MessageModel(
            idDB: row['idDB'] as int,
            idSender: row['idSender'] as String,
            nameSender: row['nameSender'] as String,
            photoSender: row['photoSender'] as String,
            idReceiver: row['idReceiver'] as String,
            nameReceiver: row['nameReceiver'] as String,
            photoReceiver: row['photoReceiver'] as String,
            timestamp: row['timestamp'] as String,
            content: row['content'] as String,
            type: row['type'] as int,
            status: row['status'] as int));
  }

  @override
  Future<void> deleteAllMessage() async {
    await _queryAdapter.queryNoReturn('DELETE * FROM MessageModel');
  }

  @override
  Future<void> insertMessage(MessageModel message) async {
    await _messageModelInsertionAdapter.insert(
        message, OnConflictStrategy.abort);
  }
}

class _$LastMessageDao extends LastMessageDao {
  _$LastMessageDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _lastMessageModelInsertionAdapter = InsertionAdapter(
            database,
            'LastMessageModel',
            (LastMessageModel item) => <String, dynamic>{
                  'idDB': item.idDB,
                  'idReceiver': item.idReceiver,
                  'nameReceiver': item.nameReceiver,
                  'photoReceiver': item.photoReceiver,
                  'timestamp': item.timestamp,
                  'content': item.content,
                  'type': item.type,
                  'status': item.status
                }),
        _lastMessageModelUpdateAdapter = UpdateAdapter(
            database,
            'LastMessageModel',
            ['idDB'],
            (LastMessageModel item) => <String, dynamic>{
                  'idDB': item.idDB,
                  'idReceiver': item.idReceiver,
                  'nameReceiver': item.nameReceiver,
                  'photoReceiver': item.photoReceiver,
                  'timestamp': item.timestamp,
                  'content': item.content,
                  'type': item.type,
                  'status': item.status
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LastMessageModel> _lastMessageModelInsertionAdapter;

  final UpdateAdapter<LastMessageModel> _lastMessageModelUpdateAdapter;

  @override
  Future<List<LastMessageModel>> getAllLastMessage() async {
    return _queryAdapter.queryList('SELECT * FROM LastMessageModel',
        mapper: (Map<String, dynamic> row) => LastMessageModel(
            idDB: row['idDB'] as int,
            idReceiver: row['idReceiver'] as String,
            nameReceiver: row['nameReceiver'] as String,
            photoReceiver: row['photoReceiver'] as String,
            content: row['content'] as String,
            type: row['type'] as int,
            timestamp: row['timestamp'] as String,
            status: row['status'] as int));
  }

  @override
  Future<LastMessageModel> getLastMessageById(String idReceiver) async {
    return _queryAdapter.query(
        'SELECT * FROM LastMessageModel WHERE idReceiver = ? LIMIT 1',
        arguments: <dynamic>[idReceiver],
        mapper: (Map<String, dynamic> row) => LastMessageModel(
            idDB: row['idDB'] as int,
            idReceiver: row['idReceiver'] as String,
            nameReceiver: row['nameReceiver'] as String,
            photoReceiver: row['photoReceiver'] as String,
            content: row['content'] as String,
            type: row['type'] as int,
            timestamp: row['timestamp'] as String,
            status: row['status'] as int));
  }

  @override
  Future<List<LastMessageModel>> getSingleLastMessage() async {
    return _queryAdapter.queryList(
        'SELECT * FROM LastMessageModel GROUP BY idReceiver ORDER BY timestamp DESC',
        mapper: (Map<String, dynamic> row) => LastMessageModel(
            idDB: row['idDB'] as int,
            idReceiver: row['idReceiver'] as String,
            nameReceiver: row['nameReceiver'] as String,
            photoReceiver: row['photoReceiver'] as String,
            content: row['content'] as String,
            type: row['type'] as int,
            timestamp: row['timestamp'] as String,
            status: row['status'] as int));
  }

  @override
  Future<LastMessageModel> getSingleMessage() async {
    return _queryAdapter.query('SELECT * FROM LastMessageModel LIMIT 1',
        mapper: (Map<String, dynamic> row) => LastMessageModel(
            idDB: row['idDB'] as int,
            idReceiver: row['idReceiver'] as String,
            nameReceiver: row['nameReceiver'] as String,
            photoReceiver: row['photoReceiver'] as String,
            content: row['content'] as String,
            type: row['type'] as int,
            timestamp: row['timestamp'] as String,
            status: row['status'] as int));
  }

  @override
  Future<void> deleteAllMessage() async {
    await _queryAdapter.queryNoReturn('DELETE * FROM LastMessageModel');
  }

  @override
  Future<void> insertMessage(LastMessageModel message) async {
    await _lastMessageModelInsertionAdapter.insert(
        message, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateLastMessageById(LastMessageModel message) async {
    await _lastMessageModelUpdateAdapter.update(
        message, OnConflictStrategy.abort);
  }
}

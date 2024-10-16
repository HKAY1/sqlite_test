import 'package:sqflite/sqflite.dart';
import 'package:test_app/constants/user_feilds.dart';
import 'package:test_app/models/user_model.dart';
import '../constants/notes_feilds.dart';
import '../models/notes_model.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();

  static Database? _database;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      'notes.db',
      version: 1,
      onCreate: (Database db, int i) async {
        await _createUserTable(db, i);
        await _createNotesTable(db, i);
      },
    );
  }

  Future<void> _createNotesTable(Database db, _) async {
    return await db.execute('''
        CREATE TABLE ${NoteFields.tableName} (
          ${NoteFields.id} ${NoteFields.idType},
          ${NoteFields.number} ${NoteFields.intType},
          ${NoteFields.title} ${NoteFields.textType},
          ${NoteFields.content} ${NoteFields.textType},
          ${NoteFields.isFavorite} ${NoteFields.intType},
          ${NoteFields.createdTime} ${NoteFields.textType}
        )
      ''');
  }

  Future<void> _createUserTable(Database db, _) async {
    return await db.execute('''
        CREATE TABLE ${UserFeilds.tableName} (
          ${UserFeilds.id} ${UserFeilds.idType},
          ${UserFeilds.number} ${UserFeilds.numberType},
          ${UserFeilds.otp} ${UserFeilds.otpType}
        )
      ''');
  }

  Future<NoteModel> create(NoteModel note) async {
    final db = await instance.database;
    final id = await db.insert(NoteFields.tableName, note.toMap());
    return note.copyWith(id: id);
  }

  Future<bool> createUser(UserModel user) async {
    try {
      print(user.phoneNumber);
      final db = await instance.database;
      // final UserModel users = await readUser(user);
      // if (users.phoneNumber.isNotEmpty) {
      //   return true;
      //   //Update Otp here
      // }
      int result = await db.insert(UserFeilds.tableName, user.toMap());
      print(result);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<int> updateUser(UserModel user) async {
    final db = await instance.database;
    return db.update(
      UserFeilds.tableName,
      user.toMap(),
      where: '${UserFeilds.id} = ?',
      whereArgs: [user.id],
    );
  }

  Future<UserModel> readUser(UserModel? user) async {
    final db = await instance.database;
    final query = await db.query(UserFeilds.tableName,
        columns: UserFeilds.values,
        where: "${UserFeilds.number} = ?",
        whereArgs: [user!.phoneNumber]);
    if (query.isNotEmpty) {
      print(query.first);
      return UserModel.fromMap(query.first);
    } else {
      throw Exception('User ${user.phoneNumber} not found');
    }
  }

  Future<List<Map<String, dynamic>>> readUser1() async {
    final db = await instance.database;
    final query = await db.query(
      UserFeilds.tableName,
    );
    if (query.isNotEmpty) {
      print(query.first);
      return query;
    } else {
      return [];
    }
  }

  Future<NoteModel> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      NoteFields.tableName,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return NoteModel.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<NoteModel>> readAll() async {
    final db = await instance.database;
    const orderBy = '${NoteFields.createdTime} DESC';
    final result = await db.query(NoteFields.tableName, orderBy: orderBy);
    return result.map((json) => NoteModel.fromMap(json)).toList();
  }

  Future<int> update(NoteModel note) async {
    final db = await instance.database;
    return db.update(
      NoteFields.tableName,
      note.toMap(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      NoteFields.tableName,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

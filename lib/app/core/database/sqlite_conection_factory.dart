
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:todolist_provider/app/core/database/sqlite_migration_factory.dart';

class SqliteConectionFactory {

  static const _VERSION = 1;
  static const _DATABASE_NAME = 'TODO_LIST_PROVIDER';


  
  static SqliteConectionFactory? _instance;

  Database? _db;
  final _lock = Lock();


SqliteConectionFactory._();

factory SqliteConectionFactory(){
  if(_instance ==null){
    _instance = SqliteConectionFactory._();
  }
  return _instance!;
}

Future<Database> openconnection () async {

  var dataBasePath = await getDatabasesPath();
  var DataBasePathFinal = join(dataBasePath, _DATABASE_NAME);

      if(_db==null){
          await _lock.synchronized(() async {
            if(_db == null){
                  _db = await openDatabase(
                          DataBasePathFinal,
                          version: _VERSION,
                          onConfigure: _onConfigure,
                          onCreate:  _onCreate,
                          onUpgrade: _onUpgrade,
                          onDowngrade: _onDowngrade
                  );
            }
      });  
      }
  return _db!;
}

  void closeConnection(){
    _db?.close();
    _db=null;
  }

  Future<void> _onConfigure(Database db) async{
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate (Database db, int version) async{
    final batch = db.batch();
    final migrations = SqliteMigrationFactory().getCreateMigration();
    for (var migration in migrations) {

      migration.create(batch);  
    }
    batch.commit();
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int version) async{
    final batch = db.batch();
    final migrations = SqliteMigrationFactory().getUpgradeMigration(oldVersion);
    for (var migration in migrations) {

      migration.create(batch);  
    }
    batch.commit();
  }
  

  Future<void> _onDowngrade(Database db, int oldVersion, int version) async{}




}
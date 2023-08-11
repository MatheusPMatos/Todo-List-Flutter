
import 'package:sqflite_common/sqlite_api.dart';
import 'package:todolist_provider/app/core/database/migrations/migrations.dart';

class MigrationsV2  implements Migrations{
  @override
  void create(Batch batch) {
    batch.execute('create table teste(id integer)');
  }

  @override
  void update(Batch batch) {
     batch.execute('create table teste(id integer)');
  }
  
}
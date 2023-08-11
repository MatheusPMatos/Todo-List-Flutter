
import 'package:sqflite_common/sqlite_api.dart';
import 'package:todolist_provider/app/core/database/migrations/migrations.dart';

class MigrationsV1 implements Migrations{


  @override
  void create(Batch batch) {
   batch.execute('''
      create table todo(
        id Integer primary key autoincrement,
        descricao varchar(500) not null,
        data_hora datetime,
        finalizado integer
      )
''');
  }

  @override
  void update(Batch batch) {}
  
}


import 'package:todolist_provider/app/core/database/migrations/migrations.dart';
import 'package:todolist_provider/app/core/database/migrations/migrations_v1.dart';
import 'package:todolist_provider/app/core/database/migrations/migrations_v2.dart';

class SqliteMigrationFactory {
  

  List<Migrations> getCreateMigration()=>[
    MigrationsV1(),
    MigrationsV2()
  ];

  List<Migrations> getUpgradeMigration(int version) {
    final migrations = <Migrations>[];

    if(version == 1){
      migrations.add(MigrationsV2());
    }

    return migrations;
  }


}
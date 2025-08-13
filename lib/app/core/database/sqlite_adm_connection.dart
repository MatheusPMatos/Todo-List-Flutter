import 'package:flutter/material.dart';
import 'package:todolist_provider/app/core/database/sqlite_conection_factory.dart';

class SqliteAdmConnection with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final connection = SqliteConectionFactory();

    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        connection.closeConnection();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
}

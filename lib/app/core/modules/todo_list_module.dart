import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';
import 'package:todolist_provider/app/core/modules/todo_list_page.dart';

abstract class TodoListModule {

  final Map<String, WidgetBuilder> _router;
  final List<SingleChildWidget>? _bindings;

  TodoListModule ({
    final List<SingleChildWidget>? bindings,
    required  final Map<String, WidgetBuilder> router
  }): _router = router, _bindings = bindings;


  Map<String, WidgetBuilder>get routers {
    return _router.map(
      (key, pagebuilder) => MapEntry(
        key, 
        (_) => TodoListPage(
          page: pagebuilder,
           bindings: _bindings,
           ),
          ),
        );
  }


  //metodo para encapsular a navegação e capturar o context do multiprovider
  // no momento da naveção através do push, que nao carrega o contexto como na pushnamed. 
  Widget getPage(String path, BuildContext context){
    final widgetBuilder = _router[path];

    if(widgetBuilder != null){
      return TodoListPage(
        page: widgetBuilder,
        bindings: _bindings,);
    } 
    throw Exception();
  }

}
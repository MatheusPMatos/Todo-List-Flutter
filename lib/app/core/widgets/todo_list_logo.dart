import 'package:flutter/material.dart';
import 'package:todolist_provider/app/core/ui/theme_extensions.dart';

class TodoListLogo extends StatelessWidget {

  const TodoListLogo({ super.key });

   @override
   Widget build(BuildContext context) {
       return Center(
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 200,),
            Text('Todo List', style:context.textTheme.headlineSmall,
            ),
          ],
         ),
       );
  }
}
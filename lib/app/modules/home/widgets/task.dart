// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todolist_provider/app/core/ui/theme_extensions.dart';

import 'package:todolist_provider/app/models/task_model.dart';
import 'package:todolist_provider/app/modules/home/home_controller.dart';
import 'package:todolist_provider/app/services/tasks/tasks_service.dart';

class Task extends StatelessWidget {

  final TaskModel model;
  final dateFormat = DateFormat('dd/MM/y');

   Task({
    Key? key,
    required this.model,
  }) : super(key: key);

   @override
   Widget build(BuildContext context) {
       return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.grey)],          
        ),
        margin:const EdgeInsets.symmetric(vertical: 5),
        child: IntrinsicHeight(
          child: ListTile(
            leading: Checkbox(
              value: model.finished, 
              onChanged: (value) =>context.read<HomeController>().checkOrUncheckTask(model),
              ),
            title: Text(
              model.description, 
              style: TextStyle(
                decoration: model.finished ? TextDecoration.lineThrough : null),
              ),
              subtitle: Text(
                dateFormat.format(model.dateTime),
                style: TextStyle(
                decoration: model.finished ? TextDecoration.lineThrough : null),   
          ),
          trailing: IconButton( 
            icon:const Icon(Icons.delete_outline_rounded),
            onPressed: (){
              showDialog(context: context, builder: (_){
                return  AlertDialog(
                title: Text('Deletar Task?', style: context.titleStyle,  ),
                actions: [
                  TextButton(
                     onPressed: () => Navigator.of(context).pop() , 
                     child: Text('Cancelar', style:TextStyle(color: context.primaryColor,),),
                       ),
                  TextButton(
                    onPressed: () async { 
                     
                      await context.read<TasksService>().delete(model.id);
                      Navigator.of(context).pushNamed('/home');
                    },
                    child: const Text('Deletar', style: TextStyle(color: Colors.red),))
                ],
              );
              });  
            },
            ),

      
          
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side:const BorderSide(width: 1)
            ),
        ),
        ),
       );
  }
}

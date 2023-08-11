// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:todolist_provider/app/core/notifier/default_listener_notifier.dart';
import 'package:todolist_provider/app/core/ui/theme_extensions.dart';
import 'package:todolist_provider/app/core/widgets/todo_list_field.dart';

import 'package:todolist_provider/app/modules/tasks/task_create_controller.dart';
import 'package:todolist_provider/app/modules/tasks/widgets/calendar_buttom.dart';
import 'package:validatorless/validatorless.dart';

class TasksCreatePage extends StatefulWidget {

  final TaskCreateController _controller;


 TasksCreatePage({
    Key? key,
    required TaskCreateController controller,
  }) : _controller = controller, super(key: key);

  @override
  State<TasksCreatePage> createState() => _TasksCreatePageState();
}

class _TasksCreatePageState extends State<TasksCreatePage> {

  final _descriptionEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
  
    super.initState();
    DefaultListenerNotifier(changeNotifier: widget._controller)
      .listener(context: context, successVoidCallBack: (notifier, listenerInstance){
        listenerInstance.dispose();
        Navigator.pop(context);
      });

  }

  @override
  void dispose() {
    _descriptionEC.dispose();
    super.dispose();
  }


   @override
   Widget build(BuildContext context) {
       return Scaffold(
           appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(onPressed: (){
                Navigator.of(context).pop();
              }, 
              icon:const  Icon(Icons.close, color: Colors.black,))
            ],
            title: const Text('TASK'),),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: context.primaryColor,
              onPressed: (){
                final formValid = _formKey.currentState?.validate() ?? false;
                if(formValid){
                  widget._controller.save(_descriptionEC.text);
                }
              }, 
              label:const  Text(
                'Salvar Task',
                style: TextStyle(fontWeight: FontWeight.bold,),)),
           body: Form(
            key: _formKey,
            child: Container(
              margin:const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text('Criar Nota', style: context.titleStyle.copyWith(fontSize: 20),)),
                    const SizedBox(height: 30,),
                    TodoListField(
                      controller: _descriptionEC,
                      validator: Validatorless.required('Descrição Obrigatória'),
                      label: ''),
                    const SizedBox(height: 20,), 
                    CalendarButtom(),

                ],
              ),
            ),
           ),
       );
  }
}
 
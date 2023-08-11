import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_provider/app/core/ui/theme_extensions.dart';
import 'package:todolist_provider/app/models/task_filter_enum.dart';
import 'package:todolist_provider/app/models/task_model.dart';
import 'package:todolist_provider/app/modules/home/home_controller.dart';
import 'package:todolist_provider/app/modules/home/widgets/task.dart';

class HomeTasks extends StatelessWidget {

  const HomeTasks({ super.key });

   @override
   Widget build(BuildContext context) {
       return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            Selector<HomeController, String>(
              builder: (context, value, child){

                return Text('TASk\'S $value.', style: context.titleStyle,);

              }, 
              selector: (context, controller){
                return controller.filterSelected.description;
              }),
           
              Column(
              children: context.select<HomeController, List<TaskModel>>(
                (controler) => controler.filteredtasks)
                  .map((t) =>  Task(model: t,)).toList(),
            )
          ],
        ));
  }
}
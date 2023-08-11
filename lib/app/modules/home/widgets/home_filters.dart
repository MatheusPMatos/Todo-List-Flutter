import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_provider/app/core/ui/theme_extensions.dart';
import 'package:todolist_provider/app/models/task_filter_enum.dart';
import 'package:todolist_provider/app/models/total_tasks_model.dart';
import 'package:todolist_provider/app/modules/home/home_controller.dart';


import 'todo_card_filter.dart';

class HomeFilters extends StatelessWidget {

   @override
   Widget build(BuildContext context) {
       return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filtros', style: context.titleStyle,),
          const SizedBox(height: 10,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                TodoCardFilter(                
                  taskFilter: TaskFilterEnum.today,
                  label: 'HOJE',
                  totalTasksModel: context.select<HomeController, TotalTasksModel?>(
                    (controller) => controller.todayTotalTasks),
                  selected: context.select<HomeController, TaskFilterEnum>(
                    (value) => value.filterSelected) == TaskFilterEnum.today,
                  
                ),
                TodoCardFilter(                
                  taskFilter: TaskFilterEnum.tomorrow,
                  label: 'AMANHÃ',
                  totalTasksModel: context.select<HomeController, TotalTasksModel?>(
                    (controller) => controller.tomorrowTotalTasks),
                  selected: context.select<HomeController, TaskFilterEnum>(
                    (value) => value.filterSelected) == TaskFilterEnum.tomorrow,
                ),
                TodoCardFilter(
                  taskFilter: TaskFilterEnum.week,
                  label: 'SEMANA',
                  totalTasksModel: context.select<HomeController, TotalTasksModel?>(
                    (controller) => controller.weekTotalTasks),
                  selected: context.select<HomeController, TaskFilterEnum>(
                    (value) => value.filterSelected) == TaskFilterEnum.week,
                ),
                
              ],
            ),
          )
        ],
       );
  }
}
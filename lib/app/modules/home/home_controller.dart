
import 'package:todolist_provider/app/models/task_filter_enum.dart';
import 'package:todolist_provider/app/models/task_model.dart';
import 'package:todolist_provider/app/models/total_tasks_model.dart';
import 'package:todolist_provider/app/models/week_task_model.dart';
import 'package:todolist_provider/app/services/tasks/tasks_service.dart';

import '../../core/notifier/default_change_notifier.dart';

class HomeController extends DefaultChangeNotifier {

  final TasksService _tasksService;

  HomeController({required TasksService tasksService}): _tasksService = tasksService;


  var filterSelected = TaskFilterEnum.today;
  TotalTasksModel? todayTotalTasks;
  TotalTasksModel? tomorrowTotalTasks;
  TotalTasksModel? weekTotalTasks;
  List<TaskModel> allTasks = [];
  List<TaskModel> filteredtasks = [];
  DateTime? initialDateOfWeek;
  DateTime? selectedDate;
  bool showFinishingTasks = true;




  Future<void> loadTotalTasks () async {
    final allTasks = await  Future.wait([
      _tasksService.getToday(),
      _tasksService.getTomorrow(),
      _tasksService.getWeek()
    ]);

    final todayTasks = allTasks[0] as List<TaskModel>;
    final tomorrowTasks = allTasks[1] as List<TaskModel>;
    final weekTasks = allTasks[2] as WeekTaskModel;


    todayTotalTasks = TotalTasksModel(
      totalTasks: todayTasks.length, 
      totalTasksFinish: todayTasks.where((task) => task.finished).length ); 
  

    tomorrowTotalTasks = TotalTasksModel(
      totalTasks: tomorrowTasks.length, 
      totalTasksFinish: tomorrowTasks.where((task) => task.finished).length ); 
  

    weekTotalTasks = TotalTasksModel(
      totalTasks: weekTasks.tasks.length, 
      totalTasksFinish: weekTasks.tasks.where((task) => task.finished).length ); 

      notifyListeners();

  }

  Future<void> findsTasks({required TaskFilterEnum filter}) async {
    filterSelected = filter;
    showLoading();
    notifyListeners();

    List<TaskModel> tasks;
    switch(filter){
      case TaskFilterEnum.today:
      tasks = await _tasksService.getToday();
      break;

      case TaskFilterEnum.tomorrow:
      tasks = await _tasksService.getTomorrow();
      break;

      case TaskFilterEnum.week:
      final weekModel =  await _tasksService.getWeek();
      initialDateOfWeek = weekModel.startDate;
      tasks = weekModel.tasks;
      break;
    }

    filteredtasks = tasks;
    allTasks = tasks;

    if(filter == TaskFilterEnum.week){

      if(selectedDate != null){
         filterByDay(selectedDate!);
      } else if(initialDateOfWeek != null){
        filterByDay(initialDateOfWeek!);
      }
    }else {
      selectedDate = null;
    }

    if(!showFinishingTasks){
      filteredtasks = filteredtasks.where((task) => !task.finished).toList();
      
    }

    hideLoading();
    notifyListeners();
  }

  void filterByDay(DateTime data) {
    selectedDate = data;
    filteredtasks = allTasks.where((task) {
      return task.dateTime == selectedDate;
    }).toList();
    notifyListeners();
  }

  Future<void> refreshPage() async {
    await  findsTasks(filter: filterSelected);
    await loadTotalTasks();
    notifyListeners();
  }


  Future<void>checkOrUncheckTask(TaskModel task) async {
    showLoadingAndResetState();
    notifyListeners();

    final taskUpdate = task.copyWith( finished: !task.finished );
    await _tasksService.checkOrUncheckTask(taskUpdate);
    hideLoading();
    refreshPage();

  }

  void hideFinishedTasks (){
    showFinishingTasks = !showFinishingTasks;
    refreshPage();
  }


}
  


import 'package:todolist_provider/app/core/notifier/default_change_notifier.dart';
import 'package:todolist_provider/app/services/tasks/tasks_service.dart';

class TaskCreateController extends DefaultChangeNotifier{

  final  TasksService _tasksService;
  DateTime? _selectedDate;


  TaskCreateController({required TasksService tasksService}):_tasksService = tasksService;

  set selectDate(DateTime? selectDate){
    resetState();
    _selectedDate = selectDate;
    notifyListeners();
  }

  DateTime? get selectedDate => _selectedDate;

  Future<void> save(String description) async {
    try {
          showLoadingAndResetState();
          notifyListeners();
          if(_selectedDate != null){
            await _tasksService.save(_selectedDate!, description);
            success();
          }else {
            setError('Data não selecionada');
          }
    }  catch (e) {
      setError('Erro ao cadastrar task');
    }finally{
      hideLoading();
      notifyListeners();
    }
      
      }
      
}
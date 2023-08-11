
enum TaskFilterEnum {
  today, tomorrow, week
}

extension TaskFilterDescription on TaskFilterEnum {
  String get description {
    switch(this){
      case TaskFilterEnum.today:
      return 'De Hoje';
      case TaskFilterEnum.tomorrow:
      return 'De Amanhã';
      case TaskFilterEnum.week:
      return 'Da Semana';

    }
  }
}
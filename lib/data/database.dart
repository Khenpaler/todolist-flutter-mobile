import 'package:hive/hive.dart';

class ToDoDatabase {
  List toDoList = [];
  
  // reference the hive box
  final _myBox = Hive.box('mybox');
  
  // run this method if this is the first time the app is opened
  void createInitialData() {
    toDoList = [
      ["Make tutorial", false],
      ["Create Tasks", false],
    ];
  }

  // load the data from the hive box
  void loadData() {
    toDoList = _myBox.get('TODOLIST');
  }

  // update the database
  void updateDatabase() {
    _myBox.put('TODOLIST', toDoList);
  }
}
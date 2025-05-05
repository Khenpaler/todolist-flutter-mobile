import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../util/todo_tile.dart';
import '../util/dialog_box.dart';
import '../data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    // if this is the first time opening the app, create default data
    if (_myBox.get('TODOLIST') == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }
    
    super.initState();
  }

  // text controller
  final _controller = TextEditingController();

  // checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    if (value == null) return;
    
    setState(() {
      db.toDoList[index][1] = value;
      // Sort the list to move completed tasks to the bottom
      db.toDoList.sort((a, b) {
        if (a[1] == b[1]) return 0;
        return a[1] ? 1 : -1;
      });
    });
    db.updateDatabase();
    
    // Show toast notification
    Fluttertoast.showToast(
      msg: value ? "Task completed!" : "Task uncompleted!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: value ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  void saveNewTask() {
    if (_controller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter a task!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Colors.white,
        fontSize: 16.0
      );
      return;
    }

    setState(() {
      // Add new task at the beginning of the list
      db.toDoList.insert(0, [_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
    Fluttertoast.showToast(
      msg: "Task added successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  // create new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDatabase();
    Fluttertoast.showToast(
      msg: "Task deleted!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('TO DO'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
         itemCount: db.toDoList.length,
         itemBuilder: (context, index) 
          return Opacity(
            opacity: db.toDoList[index][1] ? 0.5 : 1.0,
            child: TodoTile(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
            ),
          );
         }
      )
    );
  }
}

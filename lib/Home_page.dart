import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/database.dart';
import 'package:todo_app/dialog_box.dart';
import 'package:todo_app/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //reference the Hive box
  final _myBox = Hive.box('mybox');
  TodoDatabase db = TodoDatabase();

  @override
  void initState() {
    // if this first time ever open the app, then create default data
    if(_myBox.get('TODOLIST') == null){
      db.createInitialData();
    }else{
      //there already exist data
      db.loadData();
    }

    super.initState();
  }

  //controller
  final _controller = TextEditingController();
  //list of todotask

  //CheckBox was tapped
  void checkBoxChanged(bool? value, int index){
    setState(() {
      db.todolist[index][1] = !db.todolist[index][1];
    });
    db.updateData();
  }
  //save new task
  void saveNewTask(){
    setState(() {
      db.todolist.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateData();
  }

  //Create new Task
  void createNewTask(){
  showDialog(context: context, builder: (context){
    return DialogBox(
    controller: _controller,
      onSave: saveNewTask,
      onCancel: ()=> Navigator.of(context).pop(),
    );
    },
  );
  }
  //delete function
  void deleteTask(int index){
    setState(() {
      db.todolist.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Center(child: Text('Todo App')),
        elevation: 0,

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          createNewTask();
          },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.todolist.length,
        itemBuilder: (context, index){
          return TodoList(
              taskName: db.todolist[index][0],
              taskCompleted: db.todolist[index][1],
              onchanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        }

      ),
    );
  }
}

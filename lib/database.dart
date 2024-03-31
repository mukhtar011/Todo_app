import 'package:hive/hive.dart';

class TodoDatabase {
  List todolist = [];

  //reference the Box
  final _myBox = Hive.box("mybox");

  //run this method if user first time ever the open the app
void createInitialData(){
  todolist = [
    ['Make Tutorial', false],
    ['Do Exercise', false],

  ];
}
//load the Data from Database
void loadData(){
  todolist = _myBox.get('TODOLIST');

}
//update the DataBase
void updateData(){
  _myBox.put('TODOLIST', todolist);

}

}
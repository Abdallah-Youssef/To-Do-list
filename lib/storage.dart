import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/SubTask.dart';
import 'package:to_do_app/ToDo.dart';

void saveToDos (List<ToDo>toDos)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("todos", json.encode(toDos));
  uploadData(toDos);
}

void saveIndexedToDo (ToDo toDo, int i)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<ToDo> savedToDos = json.decode(prefs.getString("todos"));
  savedToDos[i] = toDo;
  saveToDos(savedToDos);
}

Future<List<ToDo>> readToDos ()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<dynamic> dynList = json.decode(prefs.getString("todos"));
  List<ToDo> toDos = [];

  for (int i = 0;i < dynList.length;i++) {
    ToDo todo = new ToDo.fromJson(dynList[i]);
    toDos.add(todo);
  }

  return toDos;
}

Future<List<ToDo>> getfirebaseToDos ()async{
  List<ToDo>toDos = [];

  return toDos;
}

Future<void> uploadData(List<ToDo> todos) async {
  todos.forEach((todo) async {
    await Firestore.instance.collection("ToDos").add(
      todo.toJson()
    );
  });
}




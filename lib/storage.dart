import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/ToDo.dart';

void saveToDos (List<ToDo>toDos)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  for (var i = 0;i < toDos.length;i++){
    prefs.setString('$i.text', toDos[i].text);
    prefs.setBool('$i.status', toDos[i].status);
    prefs.setBool('$i.fav', toDos[i].fav);
    prefs.setStringList('$i.steps', toDos[i].steps);
  }
  prefs.setInt('n_tasks', toDos.length);
}

void saveIndexedToDo (ToDo toDo, int i)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('$i.text', toDo.text);
  prefs.setBool('$i.status', toDo.status);
  prefs.setBool('$i.fav', toDo.fav);
  prefs.setStringList('$i.steps', toDo.steps);
}

Future<List<ToDo>> readToDos ()async{
  List<ToDo>toDos = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  for (var i = 0;i <  prefs.getInt('n_tasks');i++){
    toDos.add(ToDo(prefs.getString('$i.text'),
                   prefs.getBool('$i.status'),
                   prefs.getBool('$i.fav'),
                   prefs.getStringList('$i.steps') ?? []));
  }
  return toDos;
}
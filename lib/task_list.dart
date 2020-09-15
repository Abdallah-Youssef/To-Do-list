import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/SubTask.dart';
import 'package:to_do_app/ToDo.dart';
import 'package:to_do_app/storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/task_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TaskList extends StatefulWidget {
  TaskList({
    Key key,
  }) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<String> status;
  List<ToDo> toDos = [];
  bool showToDoInput = false;
  TextEditingController txtCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    showToDoInput = false;
    toDos = [];


    /*getfirebaseToDos().then((List<ToDo> content) {
      setState(() {
        toDos = content;
      });
    });*/

    readToDos().then((List<ToDo> content) {
      setState(() {
        toDos = content;
        uploadData(toDos);
      });
    });
  }

  @override
  Widget build(BuildContext contexts) {
    return Scaffold(
        appBar: AppBar(
          title: Text('To Do list'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                deleteAll();
              },
              tooltip: 'Remove all tasks',
            ),
            IconButton(
              icon: Icon(Icons.autorenew),
              onPressed: () {
                refresh();
              },
              tooltip: 'Remove completed tasks',
            )
          ],
        ),
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("ToDos").snapshots(),
                builder: (context, snapshot) {
                  Future.delayed(Duration.zero, () async {
                    readToDos().then((List<ToDo> content) {
                      setState(() {
                        toDos = content;
                      });
                    });
                    //snapShotToToDos(snapshot);
                  });

                  return toDos.length == 0
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: toDos.length,
                          itemBuilder: (contexts, index) {
                            return listItem(index);
                          });
                }),
            showToDoInput == true
                ? Row(
                    children: <Widget>[
                      Container(
                          width: 250,
                          child: TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Type your To Do here'),
                            autofocus: true,
                            controller: txtCtrl,
                            onSubmitted: (String txt) {
                              if (txt != '') submit(txt);
                            },
                          )),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if (txtCtrl.text != '') submit(txtCtrl.text);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                            txtCtrl.clear();
                            showToDoInput = false;
                          });
                        },
                      )
                    ],
                  )
                : Container()
          ],
        ),
        floatingActionButton: showToDoInput == false
            ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    showToDoInput = true;
                  });
                },
                tooltip: 'Add To Do',
                child: Icon(Icons.add),
              )
            : null // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  void submit(String txt) {
    setState(() {
      toDos.add(ToDo(txt, false, false, []));
      saveToDos(toDos);
      txtCtrl.clear();
    });
  }

  void deleteAll() {
    this.setState(() {
      toDos = [];
      saveToDos(toDos);
    });
  }

  void refresh() {
    List<ToDo> _toDos = [];
    for (var i = 0; i < toDos.length; i++)
      if (toDos[i].status == false) {
        _toDos.add(ToDo(toDos[i].text, toDos[i].status, toDos[i].fav,
            toDos[i].subtasks));
      }

    this.setState(() {
      toDos = _toDos;
      saveToDos(toDos);
    });
  }

  Text stepProgress(List<SubTask> subtasks) {
    int count = 0;
    for (var i = 0; i < subtasks.length; i++) {
      if (subtasks[i].status == true) count++;
    }
    return Text(subtasks.length != 0? '$count out of ${subtasks.length}' : "No subtasks");
  }

  void snapShotToToDos(snapshot) {
    List<ToDo> _toDos = [];
    for (int i = 0; i < snapshot.data.documents.length; i++) {
      DocumentSnapshot data = snapshot.data.documents[i];
      List<SubTask> _subtasks = [];
      if (data["subtasks"] != null) {
        for (int j = 0; j < data["subtasks"].length; j++) {
          _subtasks.add(SubTask(
              data["subtasks"][j]["text"], data["subtasks"][j]["status"]));
        }
      }

      _toDos.add(ToDo(data["text"] ?? "", data["status"] ?? false,
          data["fav"] ?? false, _subtasks));
    }

    print(_toDos);

    setState(() {
      toDos = _toDos;
    });
  }

  Widget listItem(int i) {
    return Slidable(
        actionPane: SlidableBehindActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            icon: Icons.delete,
            color: Colors.red,
            onTap: () {
              setState(() {
                toDos.removeAt(i);
                saveToDos(toDos);
              });
            },
          ),
        ],
        child: Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskView(task: toDos[i], index: i)),
                );
              },
              leading: Checkbox(
              value: toDos[i].status,
              onChanged: (bool value) {
                setState(() {
                  toDos[i].status = value;
                  saveIndexedToDo(toDos[i], i);
                });
              }),
              title: Text(toDos[i].text,
                style: TextStyle(
                  fontSize: 20,
                  decoration:
                      toDos[i].status ? TextDecoration.lineThrough : null)),
              subtitle: stepProgress(toDos[i].subtasks),
              trailing: IconButton(
                icon: toDos[i].fav
                  ? Icon(FontAwesomeIcons.solidHeart)
                  : Icon(FontAwesomeIcons.heart),
              onPressed: () {
                setState(() {
                  toDos[i].fav = !toDos[i].fav;
                  saveIndexedToDo(toDos[i], i);
                });
              }),
        )));
  }
}

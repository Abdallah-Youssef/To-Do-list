import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/ToDo.dart';
import 'package:to_do_app/storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/task_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> texts;
  List<String> status;
  List<ToDo> toDos = [];
  bool showToDoInput = false;
  TextEditingController txtCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showToDoInput = false;
    readToDos().then((List<ToDo> content) {
      setState(() {
        toDos = content;
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
            //(texts != null && status != null)
            toDos != null
                ? ListView.builder(
                    itemCount: toDos.length,
                    itemBuilder: (contexts, i) {
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
                                    builder: (context) =>
                                        TaskView(task: toDos[i], index: i)),
                              );
                            },
                            leading: Checkbox(
                                value: toDos[i].status,
                                onChanged: (bool value) {
                                  setState(() {
                                    toDos[i].status = value;
                                    saveIndexedToDo(toDos[i],i);
                                  });
                                }),
                            title: Text(toDos[i].text,
                                style: TextStyle(
                                    fontSize: 20,
                                    decoration: toDos[i].status
                                        ? TextDecoration.lineThrough
                                        : null)),
                            subtitle:
                                Text('Insert file name and step progress'),
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
                    })
                : Center(
                    child: Text('....'),
                  ),
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
      toDos.add(ToDo(txt, false, false , []));
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
      if (toDos[i].status == false)
        _toDos.add(ToDo(toDos[i].text, toDos[i].status, toDos[i].fav , toDos[i].steps));

    this.setState(() {
      toDos = _toDos;
      saveToDos(toDos);
    });
  }
}

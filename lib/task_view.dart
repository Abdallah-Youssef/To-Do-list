import 'package:flutter/material.dart';
import 'package:to_do_app/ToDo.dart';
import 'package:to_do_app/storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskView extends StatefulWidget {
  final ToDo task;
  final int index;

  const TaskView({Key key, this.task, this.index}) : super(key: key);

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  TextEditingController inputCtrl = TextEditingController();
  TextEditingController mainCtrl = TextEditingController();
  TextEditingController stepCtrl = TextEditingController();
  bool editMainTask = false;
  int editStep = -1;

  //editStep holds the index of the step that should become a stepTileEditable,
  //if it's -1 that means none of the steps should be editable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            'Tasks',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: <Widget>[
            editMainTask == false ? mainTask() : mainTaskEditable(),
            Expanded(
                child: ListView.builder(
                    itemCount: widget.task.steps.length + 1,
                    itemBuilder: (context, i) {
                      if (i == widget.task.steps.length) return inputField();
                      if (i == editStep) {
                        stepCtrl.text = widget.task.steps[editStep];
                        return stepTileEditable(editStep);}
                      return stepTile(i);
                    })),
          ],
        ));
  }

  Card mainTask() {
    return Card(
      margin: EdgeInsets.fromLTRB(13, 13, 13, 0),
      child: ListTile(
        contentPadding: EdgeInsets.all(20),
        leading: Checkbox(
            value: widget.task.status,
            onChanged: (bool value) {
              setState(() {
                widget.task.status = value;
                saveIndexedToDo(widget.task, widget.index);
              });
            }),
        title: Text(widget.task.text,
            style: TextStyle(
                fontSize: 35,
                decoration:
                    widget.task.status ? TextDecoration.lineThrough : null)),
        trailing: IconButton(
            icon: widget.task.fav
                ? Icon(FontAwesomeIcons.solidHeart)
                : Icon(FontAwesomeIcons.heart),
            onPressed: () {
              setState(() {
                widget.task.fav = !widget.task.fav;
                saveIndexedToDo(widget.task, widget.index);
              });
            }),
        onTap: () {
          setState(() {
            mainCtrl.text = widget.task.text;
            editMainTask = true;
          });
        },
      ),
    );
  }

  Card mainTaskEditable() {
    return Card(
      margin: EdgeInsets.fromLTRB(13, 13, 13, 0),
      child: ListTile(
        contentPadding: EdgeInsets.all(20),
        leading: Checkbox(
            value: widget.task.status,
            onChanged: (bool value) {
              setState(() {
                widget.task.status = value;
                saveIndexedToDo(widget.task, widget.index);
              });
            }),
        title: TextField(
          autofocus: true,
          controller: mainCtrl,
          style: TextStyle(
              fontSize: 35,
              decoration:
                  widget.task.status ? TextDecoration.lineThrough : null),
          onTap: () {
            mainCtrl.text = widget.task.text;
          },
          onSubmitted: (String txt) {
            widget.task.text = txt;
            saveIndexedToDo(widget.task, widget.index);
            setState(() {
              editMainTask = false;
            });
          },
        ),
        trailing: IconButton(
            icon: widget.task.fav
                ? Icon(FontAwesomeIcons.solidHeart)
                : Icon(FontAwesomeIcons.heart),
            onPressed: () {
              setState(() {
                widget.task.fav = !widget.task.fav;
                saveIndexedToDo(widget.task, widget.index);
              });
            }),
        onTap: () {
          setState(() {
            editMainTask = true;
          });
        },
      ),
    );
  }

  Card inputField() {
    return Card(
      color: Color.fromRGBO(176, 255, 187, 1),
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: <Widget>[
          Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: IconButton(icon : Icon(FontAwesomeIcons.plus),
              onPressed: (){
                if (inputCtrl.text != '') {
                  setState(() {
                    widget.task.steps.add(inputCtrl.text);
                    widget.task.stepsStatus.add('f');
                    inputCtrl.clear();
                  });
                  saveIndexedToDo(widget.task, widget.index);
                  print(widget.task.steps);
                  print(widget.task.stepsStatus);
                }
              },)),
          Container(
              width: 250,
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Add Step'),
                controller: inputCtrl,
                onSubmitted: (String txt) {
                  if (txt != '') {
                    setState(() {
                      widget.task.steps.add(txt);
                      widget.task.stepsStatus.add('f');
                      inputCtrl.clear();
                    });
                    saveIndexedToDo(widget.task, widget.index);
                  }
                },
              ))
        ],
      ),
    );
  }

  Slidable stepTileEditable(int i) {
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
                widget.task.stepsStatus.removeAt(i);
                widget.task.steps.removeAt(i);
                saveIndexedToDo(widget.task, widget.index);
              });
            },
          ),
        ],
        child: Card(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListTile(
              leading: Checkbox(
                  value: widget.task.stepsStatus[i] == 'f' ? false : true,
                  onChanged: (bool value) {
                    setState(() {
                      widget.task.stepsStatus[i] = value ? 't' : 'f';
                      saveIndexedToDo(widget.task, widget.index);
                    });
                  }),
              title: TextField(
                autofocus: true,
                controller: stepCtrl,
                style: TextStyle(
                    fontSize: 20,
                    decoration: widget.task.stepsStatus[i] == 't'
                        ? TextDecoration.lineThrough
                        : null),
                onSubmitted: (String txt) {
                  widget.task.steps[i] = txt;
                  saveIndexedToDo(widget.task, widget.index);
                  setState(() {
                    editStep = -1;
                  });
                },
              ),
            )));
  }

  Slidable stepTile(int _i) {
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
                widget.task.stepsStatus.removeAt(_i);
                widget.task.steps.removeAt(_i);
                saveIndexedToDo(widget.task, widget.index);
              });
            },
          ),
        ],
        child: Card(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListTile(
              leading: Checkbox(
                  value: widget.task.stepsStatus[_i] == 'f' ? false : true,
                  onChanged: (bool value) {
                    setState(() {
                      widget.task.stepsStatus[_i] = value ? 't' : 'f';
                      saveIndexedToDo(widget.task, widget.index);
                    });
                  }),
              title: Text(widget.task.steps[_i],
                  style: TextStyle(
                      fontSize: 20,
                      decoration: widget.task.stepsStatus[_i] == 't'
                          ? TextDecoration.lineThrough
                          : null)),
              onTap: (){
                setState(() {
                  editStep = _i;
                });
              },
            )));
  }
}

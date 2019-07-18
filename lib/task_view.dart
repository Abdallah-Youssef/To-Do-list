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
  TextEditingController txtCtrl = TextEditingController();

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
            Card(
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
                        fontSize: 40,
                        decoration: widget.task.status
                            ? TextDecoration.lineThrough
                            : null)),
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
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: widget.task.steps.length,
                    itemBuilder: (context, i) {
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
                                    value: widget.task.stepsStatus[i] == 'f'
                                        ? false
                                        : true,
                                    onChanged: (bool value) {
                                      setState(() {
                                        widget.task.stepsStatus[i] =
                                            value ? 't' : 'f';
                                        saveIndexedToDo(
                                            widget.task, widget.index);
                                      });
                                    }),
                                title: Text(widget.task.steps[i],
                                    style: TextStyle(
                                        fontSize: 20,
                                        decoration:
                                            widget.task.stepsStatus[i] == 't'
                                                ? TextDecoration.lineThrough
                                                : null)),
                              )));
                    })),
            /*Column(
                children: widget.task.steps
                    .map((step) => Slidable(
                        actionPane: SlidableBehindActionPane(),
                        actionExtentRatio: 0.25,
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Delete',
                            icon: Icons.delete,
                            color: Colors.red,
                            onTap: () {
                              setState(() {
                                widget.task.stepsStatus
                                    .removeAt(widget.task.steps.indexOf(step));
                                widget.task.steps.remove(step);
                                saveIndexedToDo(widget.task, widget.index);
                              });
                            },
                          ),
                        ],
                        child: Card(
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: ListTile(
                              leading: Checkbox(
                                  value: widget.task.stepsStatus[widget
                                              .task.steps
                                              .indexOf(step)] ==
                                          'f'
                                      ? false
                                      : true,
                                  onChanged: (bool value) {
                                    setState(() {
                                      widget.task.stepsStatus[widget.task.steps
                                          .indexOf(step)] = value ? 't' : 'f';
                                      saveIndexedToDo(
                                          widget.task, widget.index);
                                    });
                                  }),
                              title: Text(step,
                                  style: TextStyle(
                                      fontSize: 20,
                                      decoration: widget.task.stepsStatus[widget
                                                  .task.steps
                                                  .indexOf(step)] ==
                                              't'
                                          ? TextDecoration.lineThrough
                                          : null)),
                            ))))
                    .toList())*/
            Card(
              color: Color.fromRGBO(176, 255, 187, 1),
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(30, 0, 10, 0),
                      child: Icon(FontAwesomeIcons.plus)),
                  Container(
                      width: 250,
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Add Step'),
                        autofocus: true,
                        controller: txtCtrl,
                        onSubmitted: (String txt) {
                          txtCtrl.clear();
                          if (txt != '') {
                            setState(() {
                              widget.task.steps.add(txt);
                              widget.task.stepsStatus.add('f');
                            });
                            saveIndexedToDo(widget.task, widget.index);
                            print(widget.task.steps);
                            print(widget.task.stepsStatus);
                          }
                        },
                      ))
                ],
              ),
            ),
          ],
        ));
  }
}

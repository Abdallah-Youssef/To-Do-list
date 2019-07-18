import 'package:flutter/material.dart';
import 'package:to_do_app/ToDo.dart';
import 'package:to_do_app/storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              margin: EdgeInsets.fromLTRB(13,13,13,0),
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

            Card(
              margin: EdgeInsets.fromLTRB(13,0,13,0),
              child: Row(
                children: <Widget>[
                  Container(margin: EdgeInsets.fromLTRB(30,25,10,25),child : Icon(FontAwesomeIcons.plus))
                  ,
                  Container(
                      width: 250,
                      child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Add Step'),
                    autofocus: true,
                    controller: txtCtrl,
                    onSubmitted: (String txt) {
                      txtCtrl.clear();
                      if (txt != '') {
                        widget.task.steps.add(txt);
                        saveIndexedToDo(widget.task, widget.index);
                        print(widget.task.steps);
                      }
                    },
                  ))
                ],
              ),
            )
          ],
        ));
  }
}

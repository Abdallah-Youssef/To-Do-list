import 'package:flutter/material.dart';
import 'package:to_do_app/SubTask.dart';

class ToDo {
  String text;
  bool status;
  bool fav = false;
  List<String> steps = [];
  List<String> stepsStatus = [];
  List<SubTask> subtasks;
  ToDo(String text, bool status,bool fav, List<SubTask> subtasks) {
    this.text = text;
    this.status = status;
    this.fav = fav;
    this.steps = steps;
    this.stepsStatus = stepsStatus;

    this.subtasks = subtasks;
  }


  Map<String, dynamic> toJson() {
    List<dynamic> _subtasks = [];
    for (int i = 0;i < subtasks.length;i++)
      _subtasks.add(subtasks[i].toJson());

    return {
      'text': text,
      'status': status,
      'fav': fav,
      'subtasks': _subtasks
    };
  }


  ToDo.fromJson(Map<String, dynamic> json){
    text = json['text'];
    fav = json['fav'];
    status = json['status'];

    List<SubTask> _subtasks = [];
    for(int i = 0;i < json["subtasks"].length;i++) {
      _subtasks.add(SubTask.fromJson(json["subtasks"][i]));
    }
    subtasks = _subtasks;
  }



}
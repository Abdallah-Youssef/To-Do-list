import 'package:flutter/material.dart';

class ToDo {

  String text;
  bool status;
  bool fav = false;
  List<String> steps = [];
  List<String> stepsStatus = [];
  ToDo(String text, bool status,bool fav, List<String> steps) {
    this.text = text;
    this.status = status;
    this.fav = fav;
    this.steps = steps;
  }

}
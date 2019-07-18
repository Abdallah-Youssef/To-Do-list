import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  bool v = false;



  
  

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing'),
      ),
      body:  Card(
        child: ListTile(

          title: Text('ggg',
              style: TextStyle(
                  fontSize: 20,
                  decoration: v
                      ? TextDecoration.lineThrough
                      : null)),
          subtitle: Text('Insert file name and step progress'),
          trailing: IconButton(icon: Icon(Icons.favorite), onPressed: null),
        )
      )
    );
  }
}

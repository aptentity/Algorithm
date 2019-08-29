import 'package:flutter/material.dart';
class RowDemoPage extends StatelessWidget{
  static const String routeName = '/page/row_demo';
  static const String name = "RowDemoPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("RowDemoPage"),),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("default:"),
              Text("register:"),
              Text('forget password'),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("start:"),
              Text("register:"),
              Text('forget password'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text("end:"),
              Text("register:"),
              Text('forget password'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("center:"),
              Text("register:"),
              Text('forget password'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("spaceBetween:"),
              Text("register:"),
              Text('forget password'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("spaceAround:"),
              Text("register:"),
              Text('forget password'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("spaceEvenly:"),
              Text("register:"),
              Text('forget password'),
            ],
          ),
        ],
      ),
    );
  }
}
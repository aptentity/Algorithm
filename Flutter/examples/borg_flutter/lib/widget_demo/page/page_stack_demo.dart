import 'package:flutter/material.dart';

class StackDemoPage extends StatelessWidget{
  static const String routeName = '/page/stack_demo';
  static const String name = "StackDemoPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StackDemoPage'),
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text('centerLeft'),
          ),
          Align(
            alignment: Alignment.center,
            child: Text('center'),
          ),
          Align(
            alignment: Alignment.center,
            child: Text('center'),
          ),
          Center(

          ),
        ],
      ),
    );
  }
}
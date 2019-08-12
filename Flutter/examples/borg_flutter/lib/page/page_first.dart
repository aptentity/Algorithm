import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FirstPageState();
}

class FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    print("FirstPageState");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("First"),
      ),
      body: new Center(
        child: new Text("我是第一页"),
      ),
    );
  }
}

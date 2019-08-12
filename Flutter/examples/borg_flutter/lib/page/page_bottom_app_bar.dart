import 'package:flutter/material.dart';
import 'package:borg_flutter/page/page_first.dart';
import 'package:borg_flutter/page/page_second.dart';
import 'package:borg_flutter/page/page_third.dart';

class BottomAppBarPage extends StatefulWidget{
  static const String routeName = '/page/bottom app bar';
  static const String name = "BottomAppBar";

  @override
  _BottomAppBarState createState() => _BottomAppBarState();

}

class _BottomAppBarState extends State<BottomAppBarPage>{
  int _index = 0;
  Color _tabColor = Colors.white;
  final List<Widget> _children = [FirstPage(), SecondPage(), ThirdPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_index],
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlue,
        shape: CircularNotchedRectangle(),
        child: tabs(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return ThirdPage();
          }));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Row tabs() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        new Container(
          child: IconButton(
            icon: Icon(Icons.near_me),
            color: _tabColor,
            onPressed: () {
              setState(() {
                _tabColor = Colors.orangeAccent;
                _index = 0;
              });
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit_location),
          color: Colors.white,
          onPressed: () {
            setState(() {
              _tabColor = Colors.white;
              _index = 1;
            });
          },
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:borg_flutter/page/page_first.dart';
import 'package:borg_flutter/page/page_second.dart';
import 'package:borg_flutter/page/page_third.dart';

class BottomNavigationBarPage extends StatefulWidget {
  static const String routeName = '/page/bottom_navigation_bar';
  static const String name = "BottomNavigationBar";

  @override
  _BottomNavigationBarState createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBarPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [FirstPage(), SecondPage(), ThirdPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      //CupertinoTabBar
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              title: new Text("Home"), icon: new Icon(Icons.home)),
          BottomNavigationBarItem(
              title: new Text("List"), icon: new Icon(Icons.list)),
          BottomNavigationBarItem(
              title: new Text("Message"), icon: new Icon(Icons.message)),
        ],
        currentIndex: _currentIndex,
        onTap: onTabTapped,
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

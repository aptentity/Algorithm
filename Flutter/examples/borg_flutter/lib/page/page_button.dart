import 'package:flutter/material.dart';

class ButtonsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buttons"),
      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              color: Colors.green,
              textColor: Colors.white,
              disabledColor: Colors.deepOrange,
              disabledTextColor: Colors.grey,
              splashColor: Colors.purple,
              child: Text("Raised button"),
              onPressed: clickButton,
            ),
            RaisedButton(
              color: Colors.green,
              textColor: Colors.white,
              disabledColor: Colors.deepOrange,
              disabledTextColor: Colors.grey,
              splashColor: Colors.purple,
              elevation: 15.0,
              highlightElevation: 5.0,
              child: Text("Raised button"),
              onPressed: clickButton,
            ),
          ],
        ),
      ),
    );
  }

  void clickButton(){
    print("click button");
  }
}
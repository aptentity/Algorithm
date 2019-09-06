import 'package:flutter/material.dart';
import 'package:borg_flutter/widget/widget_demo.dart';
import 'package:borg_flutter/widget/widget_my_custom_painter.dart';

class ButtonsPage extends StatelessWidget {
  final BaseData book1 = BaseData(name: '书籍A', num: 5000);
  final BaseData book2 = BaseData(name: '书籍B', num: 2000);
  final BaseData book3 = BaseData(name: '书籍C', num: 3000);
  final List<BaseData> dataList = List();

  ButtonsPage() {
    dataList.add(book1);
    dataList.add(book2);
    dataList.add(book3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buttons"),
      ),
      body: Column(
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
          DemoWidget(
            iconData: Icons.add,
            title: "test",
            onTap: () {
              print("onTap DemoWidget!!!!!!!!!!!!");
            },
          ),
          CustomPaint(
            painter: MyCustomPainter(dataList),
          ),
          Image.asset("assets/images/status_finish.png"),
        ],
      ),
    );
  }

  void clickButton() {
    print("click button");
  }
}

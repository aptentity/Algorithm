import 'package:borg_flutter/utils/toast_util.dart';
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
    print("ButtonsPage!!!!!!!!!!!!!!!");
    return Scaffold(
      appBar: AppBar(
        title: Text("Buttons"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: 375,
            child:RaisedButton(
              color: Colors.green,
              textColor: Colors.white,
              disabledColor: Colors.deepOrange,
              disabledTextColor: Colors.grey,
              splashColor: Colors.purple,
              child: Text("Raised button"),
              onPressed: clickButton,
            ),
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
          TestWidget(),
        ],
      ),
    );
  }

  void clickButton() {
    print("click button");
    showLongToast('click button');
  }
}

class TestWidget extends StatefulWidget{
  @override
  TestState createState() => TestState();
}

class TestState extends State<StatefulWidget>{
  int count = 0;

  @override
  Widget build(BuildContext context) {
    print("TestState build!!!!!!!!!!!!!!!");
    return Column(
      children: <Widget>[
        Text(count.toString()),
        MyTest(count.toString()),
        MyButton(clickButton),
      ],
    );
  }

  void clickButton() {
    print("clickButton!!!!!!!!!!!!!!!");
    setState(() {
      count ++;
    });
  }

}

class MyButton extends StatelessWidget{
  final VoidCallback onPressed;
  const MyButton(this.onPressed);
  @override
  Widget build(BuildContext context) {
    print("MyButton build!!!!!!!!!!!!!!! ");
    return RaisedButton(child: Text('Add'),onPressed: ()=>clickButton(),);
  }

  void clickButton() {
    print("MyButton clickButton!!!!!!!!!!!!!!!");
    onPressed();
  }
}

class MyTest extends StatelessWidget{
  final String title;

  const MyTest(this.title);

  @override
  Widget build(BuildContext context) {
    print("MyTest build!!!!!!!!!!!!!!!");
    return Text(title);
  }
}

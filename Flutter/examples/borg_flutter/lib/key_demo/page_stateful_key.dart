import 'package:flutter/material.dart';
import 'dart:math';
import 'package:annotation_route/route.dart';
import 'package:borg_flutter/router/routers.dart';
import 'package:borg_flutter/router/borg_router.dart';
import 'package:borg_flutter/fluro/application.dart';
import 'package:borg_flutter/fluro/routes.dart';

/// 使用StatefulWidget无法交互，color顺序没有改变
@ARoute(url:BorgRouters.SwapColorPage)
class SwapColorPage2 extends StatefulWidget {
  static const String routeName = '/page/swap_color_page2';
  static const String name = "SwapColorPage2";

  SwapColorPage2(MyRouteOption option): super();

  @override
  _SwapColor2State createState() => _SwapColor2State();
}

class _SwapColor2State extends State<SwapColorPage2> {
  List<Widget> widgets;

  @override
  void initState() {
    super.initState();
//    widgets = [
//      //设置key后可以交换，_ColorfulTileState的build不会被调用
////      StatefulColorfulTile(key: UniqueKey(),),
////      StatefulColorfulTile(key: UniqueKey(),),
//      StatefulColorfulTile(),
//      StatefulColorfulTile(),
//    ];
    widgets = [
      Padding(
        key: UniqueKey(),
        padding: const EdgeInsets.all(8.0),
        child: StatefulColorfulTile(key: UniqueKey()),
      ),
      Padding(
        key: UniqueKey(),
        padding: const EdgeInsets.all(8.0),
        child: StatefulColorfulTile(key: UniqueKey()),
      ),
      RaisedButton(
        child: Text('go to'),
        onPressed: gotoPage,
      ),
    ];
  }

  gotoPage(){
    Application.router.navigateTo(context, Routes.demoSimple);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('_SwapColor2State build');
    return Scaffold(
      appBar: AppBar(
        title: Text('SwapColorPage2'),
      ),
      body: Column(
        children: widgets,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: swapTile,
        child: Icon(Icons.account_box),
      ),
    );
  }

  swapTile() {
    setState(() {
      widgets.insert(1, widgets.removeAt(0));
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    print('------------------deactivate--------------');
  }
}

class StatefulColorfulTile extends StatefulWidget {
  StatefulColorfulTile({Key key}):super(key:key);

  @override
  _ColorfulTileState createState(){
    debugPrint('StatefulColorfulTile createState $key');
    return _ColorfulTileState();
  }
}

class _ColorfulTileState extends State<StatefulColorfulTile> {
  final Color color = UniqueColorGenaretor.getColor();
  @override
  Widget build(BuildContext context){
    debugPrint('_ColorfulTileState build $color');
    return buildColorfulTile(color);
  }
}

class UniqueColorGenaretor {
  static List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.black,
    Colors.blue,
    Colors.teal,
    Colors.purpleAccent
  ];
  static Random random = Random();

  static Color getColor() {
    final i = random.nextInt(colors.length);
    return colors[i];
  }
}

Widget buildColorfulTile(Color color) =>
    Container(width: 60, height: 60, color: color);
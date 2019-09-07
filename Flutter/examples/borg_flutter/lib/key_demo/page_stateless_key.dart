import 'package:flutter/material.dart';
import 'dart:math';
import 'package:borg_flutter/router/borg_router.dart';
import 'package:borg_flutter/router/routers.dart';

/// 使用Stateless的widget可以正常交换
class SwapColorPage extends StatefulWidget {
  static const String routeName = '/page/swap_color_page';
  static const String name = "SwapColorPage";

  @override
  _SwapColorState createState() => _SwapColorState();
}

class _SwapColorState extends State<SwapColorPage> {
  List<Widget> widgets;

  @override
  void initState() {
    super.initState();
//    widgets = [
//      StatelessColorfulTile(),
//      StatelessColorfulTile(),
//    ];

    widgets = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: StatelessColorfulTile(key: UniqueKey()),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: StatelessColorfulTile(key: UniqueKey()),
      ),
      RaisedButton(
        child: Text('go to'),
        onPressed: gotoPage,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    print('_SwapColorState build');
    return Scaffold(
      appBar: AppBar(
        title: Text("SwapColorPage"),
      ),
      body: SafeArea(
        child: Row(
          children: widgets,
        ),
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

  gotoPage(){
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
      return Router.getPage(BorgRouters.SwapColorPage,{});
    }));
  }
}

class StatelessColorfulTile extends StatelessWidget {
  final Color color = UniqueColorGenaretor.getColor();

  StatelessColorfulTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    print('StatelessColorfulTile build $color');
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

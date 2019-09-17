import 'package:flutter/material.dart';
import 'package:borg_flutter/page/page_first.dart';
import 'package:borg_flutter/page/page_second.dart';
import 'package:borg_flutter/page/page_third.dart';

class TabBarPage extends StatefulWidget {
  static const String routeName = '/page/tab_bar';
  static const String name = "Tab Bar";

  @override
  _TabBarState createState() => _TabBarState();
}

class _TabBarState extends State<TabBarPage>
    with SingleTickerProviderStateMixin,WidgetsBindingObserver {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);

    controller.addListener((){
      if (controller.index.toDouble() == controller.animation.value){
        print('-------------------page change ${controller.index}');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new TabBarView(
        children: <Widget>[
          new SecondPage(),
          new SecondPage(),
          new ThirdPage(),
        ],
        controller: controller,
      ),
      bottomNavigationBar: new Material(
        color: Colors.blue,
        child: new TabBar(controller: controller, tabs: <Tab>[
          new Tab(text: "首页", icon: new Icon(Icons.home)),
          new Tab(text: "列表", icon: new Icon(Icons.list)),
          new Tab(text: "信息", icon: new Icon(Icons.message)),
        ]),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('-------------TabBarPage didChangeAppLifecycleState:$state');
  }
}

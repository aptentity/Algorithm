import 'package:flutter/material.dart';
import 'package:borg_flutter/page/page_second.dart';
import 'package:borg_flutter/page/page_third.dart';

class FirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FirstPageState();
}

class FirstPageState extends State<FirstPage>
    with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin{
  TabController controller;
  @override
  void initState() {
    print("FirstPageState");
    super.initState();
    controller = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: TabBar(
          isScrollable: true,
          controller: controller,
          unselectedLabelColor:Color.fromARGB(0xff, 0xad, 0xb4, 0xc2),
          labelColor: Color.fromARGB(0xff, 0x32, 0x74, 0xf9),
          indicatorColor: Color.fromARGB(0xff, 0x32, 0x74, 0xf9),
          indicatorSize: TabBarIndicatorSize.label,
          tabs: <Widget>[
            new Tab(text:"蛋壳资讯"),
            new Tab(text:"公司大事件"),
            new Tab(text:"公司制度"),
            new Tab(text:"蛋壳英雄榜"),
            new Tab(text:"企业"),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: new TabBarView(
        children: <Widget>[
          new ThirdPage(),
          new SecondPage(),
          new ThirdPage(),
          new SecondPage(),
          new ThirdPage(),
        ],
        controller: controller,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

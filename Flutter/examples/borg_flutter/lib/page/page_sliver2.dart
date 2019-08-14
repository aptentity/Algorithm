import 'package:flutter/material.dart';

class SliverAppBarPage extends StatelessWidget {
  static const String routeName = '/page/sliver_page2';
  static const String name = "Sliver Page2";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("随内容一起滑动的头部"),
              centerTitle: true,
              collapseMode: CollapseMode.pin,
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 150.0,
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: new Text("List item $index"),
              ),
            ),
          )
        ],
      ),
    );
  }
}

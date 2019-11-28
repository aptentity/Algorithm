import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_template/business/home/banner.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  EasyRefreshController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  int _count = 20;
  List<BannerItem> list = [
    BannerItem(
        "http:\/\/minimg.hexun.com\/i7.hexun.com\/2015-11-16\/180596378_c324x234.jpg",
        'http://www.1.com'),
    BannerItem(
        "http:\/\/minimg.hexun.com\/i6.hexun.com\/2014-11-19\/170564509_c324x234.jpg",
        'http://www.2.com'),
    BannerItem(
        "http:\/\/minimg.hexun.com\/i7.hexun.com\/2014-09-02\/168105362_c324x234.jpg",
        'http://www.3.com'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.custom(
        controller: _controller,
        header: ClassicalHeader(),
        footer: ClassicalFooter(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: AptBanner(
              list: list,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  width: 60.0,
                  height: 60.0,
                  child: Center(
                    child: Text('$index'),
                  ),
                  color: index % 2 == 0 ? Colors.grey[300] : Colors.transparent,
                );
              },
              childCount: _count,
            ),
          ),
        ],
        onRefresh: () async {
          print('onRefresh');
          setState(() {
            _count = 10;
            if (list.length == 1) {
              list.add(BannerItem(
                  "http:\/\/minimg.hexun.com\/i7.hexun.com\/2015-11-16\/180596378_c324x234.jpg",
                  'http://www.${list.length+1}.com'));
            } else {
              list.removeLast();
            }
          });
          _controller.resetLoadState();
        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:annotation_route/route.dart';
import 'package:flutter_template/router/borg_router.dart';
import 'package:flutter_template/router/routers.dart';
import 'package:cached_network_image/cached_network_image.dart';

@ARoute(url: PageRouters.UserPage)
class UserPage extends StatefulWidget {
  UserPage(MyRouteOption option) : super();

  @override
  UserState createState() => UserState();
}

class UserState extends State<UserPage> {
  List<_ImageItem> list = [
    _ImageItem(
        '111',
        'http://g.hiphotos.baidu.com/zhidao/pic/item/622762d0f703918f3e078430553d269758eec472.jpg',
        'http://www.1.com'),
    _ImageItem(
        '111',
        'http://g.hiphotos.baidu.com/zhidao/pic/item/622762d0f703918f3e078430553d269758eec472.jpg',
        'http://www.1.com'),
    _ImageItem(
        '111',
        'http://g.hiphotos.baidu.com/zhidao/pic/item/622762d0f703918f3e078430553d269758eec472.jpg',
        'http://www.1.com'),
    _ImageItem(
        '111',
        'http://g.hiphotos.baidu.com/zhidao/pic/item/622762d0f703918f3e078430553d269758eec472.jpg',
        'http://www.1.com'),
    _ImageItem(
        '111',
        'http://g.hiphotos.baidu.com/zhidao/pic/item/622762d0f703918f3e078430553d269758eec472.jpg',
        'http://www.1.com'),
    _ImageItem(
        '111',
        'http://g.hiphotos.baidu.com/zhidao/pic/item/622762d0f703918f3e078430553d269758eec472.jpg',
        'http://www.1.com'),
    _ImageItem(
        '111',
        'http://g.hiphotos.baidu.com/zhidao/pic/item/622762d0f703918f3e078430553d269758eec472.jpg',
        'http://www.1.com'),
    _ImageItem(
        '111',
        'http://g.hiphotos.baidu.com/zhidao/pic/item/622762d0f703918f3e078430553d269758eec472.jpg',
        'http://www.1.com'),
    _ImageItem(
        '111',
        'http://g.hiphotos.baidu.com/zhidao/pic/item/622762d0f703918f3e078430553d269758eec472.jpg',
        'http://www.1.com'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人中心'),
      ),
      body: Column(
        children: <Widget>[
          _ImageGrid(list),
        ],
      ),
    );
  }
}

class _ImageGrid extends StatelessWidget {
  final List<_ImageItem> list;
  _ImageGrid(this.list);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 2,
      runSpacing: 5,
      children: getItems(),
    );
  }

  List<Widget> getItems() {
    List<Widget> widgetList = List();
    for (_ImageItem item in list) {
      widgetList.add(
        GestureDetector(
          child: Container(
            child: Column(
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: item.imgUrl,
                  fit: BoxFit.fill,
                  width: 50,
                  height: 50,
                ),
                Text(item.title),
              ],
            ),
          ),
        ),
      );
    }
    return widgetList;
  }
}

class _ImageItem {
  final String imgUrl;
  final String schema;
  final String title;
  _ImageItem(this.title, this.imgUrl, this.schema);
}

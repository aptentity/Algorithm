import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:annotation_route/route.dart';
import 'package:flutter_template/router/borg_router.dart';
import 'package:flutter_template/router/routers.dart';

@ARoute(url:PageRouters.UserPage)
class UserPage extends StatefulWidget{
  UserPage(MyRouteOption option) : super();

  @override
  UserState createState() => UserState();
}

class UserState extends State<UserPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('个人中心'),),
      body: Text('user'),
    );
  }
}
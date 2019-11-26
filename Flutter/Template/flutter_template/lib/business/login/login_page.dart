import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:annotation_route/route.dart';
import 'package:flutter_template/router/borg_router.dart';
import 'package:flutter_template/router/routers.dart';

@ARoute(url:PageRouters.LoginPage)
class LoginPage extends StatefulWidget{
  LoginPage(MyRouteOption option) : super();

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('登录'),),
      body: Text('login'),
    );
  }
}
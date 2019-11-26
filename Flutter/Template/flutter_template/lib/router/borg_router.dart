import 'dart:core';

import 'package:annotation_route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/router/routers.dart';
import 'borg_router.internal.dart';

@ARouteRoot()
class Router {
  static Widget getPage(String urlString, Map<String, dynamic> query) {
    // http、https走WebView
    if (urlString.startsWith('http')) {
      if(query == null){
        query = Map();
      }
      query['url'] = urlString;
      urlString = PageRouters.WebViewPage;
      debugPrint('http-----------------$query');
    } else if (needLoginPageList.contains(urlString) && !isLogin()) {
      urlString = PageRouters.LoginPage;
    }
    ARouterInternalImpl internal = ARouterInternalImpl();
    ARouterResult routeResult = internal.findPage(
        ARouteOption(urlString, query), MyRouteOption(urlString, query));
    if (routeResult.state == ARouterResultState.FOUND) {
      return routeResult.widget;
    }
    return Scaffold(
      // 这里只是例子，返回的是未匹配路径的控件
      appBar: AppBar(),
      body: Center(
        child: Text('NOT FOUND'),
      ),
    );
  }

  static push(BuildContext context, String schema,
      {Map<String, dynamic> para}) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return getPage(schema, para);
    }));
  }

  static bool isLogin() {
    return true;
  }
}

class MyRouteOption {
  String pageName;
  Map<String, dynamic> params;
  MyRouteOption(this.pageName, this.params);
}

/// 需要登录的白名单
List<String> needLoginPageList = [PageRouters.UserPage];

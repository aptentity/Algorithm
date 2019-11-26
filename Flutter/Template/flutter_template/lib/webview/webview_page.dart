import 'package:flutter/material.dart';
import 'package:annotation_route/route.dart';
import 'package:flutter_template/router/borg_router.dart';
import 'package:flutter_template/router/routers.dart';

@ARoute(url: PageRouters.WebViewPage)
class WebViewPage extends StatefulWidget {
  final String url;
  WebViewPage(MyRouteOption option) :this.url = (option?.params['url']), super();

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebViewPage'),
      ),
      body: Text(widget.url),
    );
  }
}

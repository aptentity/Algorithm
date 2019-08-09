import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class FlutterWebviewPluginPage extends StatefulWidget{
  static const String routeName = '/page/flutter_webview_plugin';
  static const String name = "Flutter Webview Plugin";

  @override
  _FlutterWebviewPluginState createState() => _FlutterWebviewPluginState();
}

class _FlutterWebviewPluginState extends State<FlutterWebviewPluginPage> with SingleTickerProviderStateMixin{

  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  var title = "WebView组件";
  var tabs;
  TabController controller;
  var choiceIndex = 0;

  /// 获取h5页面标题
  Future<String> getWebTitle() async{
    String script = "window.document.title";
    var title = await flutterWebviewPlugin.evalJavascript(script);
    setState(() {
      this.title = title;
    });
  }

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged webViewState) async{
      switch(webViewState.type){
        case WebViewState.finishLoad:
          getWebTitle();
          break;
        case WebViewState.shouldStart:
          break;
        case WebViewState.startLoad:
          break;
        case WebViewState.abortLoad:
          break;
      }
    });

    flutterWebviewPlugin.onUrlChanged.listen((String url){
      print("flutterWebviewPlugin onUrlChanged: $url");
    });

    tabs = <Widget>[
      Tab(
        child: GestureDetector(
          child: Text("刷新"),
          onTap: (){
            flutterWebviewPlugin.reload();
          },
        ),
      ),
      Tab(
        child: GestureDetector(
          child: Text("返回"),
          onTap: (){
            flutterWebviewPlugin.goBack();
          },
        ),
      ),
      Tab(
        child: GestureDetector(
          child: Text("加载制定url"),
          onTap: (){
            flutterWebviewPlugin.reloadUrl("https://www.163.com");
          },
        ),
      ),
    ];

    controller = TabController(initialIndex:0,length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: "https://www.danke.com",
      
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.grey,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: (){
            Navigator.pop(context);
          },
        ),
        bottom: TabBar(
          tabs: tabs,
          controller: controller,
          indicatorColor: Colors.red,
        ),
        actions: <Widget>[
        ],
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("首页"),
            activeIcon: Icon(
              Icons.home,
              color: Colors.red,
            ),
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.devices_other),
            title: Text("其他"),
            activeIcon: Icon(
              Icons.devices_other,
              color: Colors.red,
            ),
            backgroundColor: Colors.red,
          ),
        ],
        currentIndex: choiceIndex,
        fixedColor: Colors.red,
        onTap: (index){
          if(index == 0){
            setState(() {
              choiceIndex = 0;
              flutterWebviewPlugin.reloadUrl("https://www.qq.com/");
            });
          }else{
            setState(() {
              choiceIndex = 1;
              flutterWebviewPlugin.reloadUrl("https://www.alipay.com/");
            });
          }
        },
      ),
      
      scrollBar: false,
      withZoom: true,
      withLocalStorage: true,
      hidden: true,

      ///显示加载过程
//      initialChild: Container(
//        color: Colors.redAccent,
//        child: const Center(
//          child: Text('Waiting'),
//        ),
//      ),
    );
  }

  @override
  void dispose() {
    flutterWebviewPlugin.dispose();
    super.dispose();
  }
}

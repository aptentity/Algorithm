import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class FlutterWebviewPluginController{

  final flutterWebviewPlugin = FlutterWebviewPlugin();

  void init(){
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      print("flutterWebviewPlugin onUrlChanged: $url");
    });

    flutterWebviewPlugin.onScrollXChanged.listen((double offsetX){
      print("flutterWebviewPlugin onScrollXChanged: $offsetX");
    });

    flutterWebviewPlugin.onScrollYChanged.listen((double offsetY){
      print("flutterWebviewPlugin onScrollYChanged: $offsetY");
    });
  }
}
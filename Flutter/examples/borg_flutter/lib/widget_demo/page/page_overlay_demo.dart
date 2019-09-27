import 'package:flutter/material.dart';
import 'package:borg_flutter/overlay/toast.dart';

class OverlayDemoPage extends StatelessWidget{
  static const String routeName = '/page/overlay_page';
  static const String name = "OverlayDemoPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OverlayDemoPage'),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('Toast'),
            onPressed: (){
              Toast.show(context: context, message: 'haha');
            },
          ),
        ],
      ),
    );
  }
}
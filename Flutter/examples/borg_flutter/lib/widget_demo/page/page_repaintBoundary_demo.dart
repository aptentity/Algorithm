import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:borg_flutter/utils/screen_short_util.dart';

class RepaintBoundaryDemo extends StatefulWidget {
  static const String routeName = '/page/repaintBondary_demo';
  static const String name = "RepaintBoundaryDemoPage";

  @override
  _RepaintBoundaryState createState() => _RepaintBoundaryState();
}

class _RepaintBoundaryState extends State<RepaintBoundaryDemo> {
  GlobalKey rootWidgetKey = GlobalKey();
  List<Uint8List> images = List();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: rootWidgetKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('RepaintBoundaryDemo'),
        ),
        body: Column(
          children: <Widget>[
            Image.network(
              'http://qiniu.nightfarmer.top/test.gif',
              width: 300,
              height: 300,
            ),
            FlatButton(
              child: Text("全屏截图"),
              onPressed: () {
                _capturePng();
              },
            ),
            FlatButton(
              child: Text("全屏截图2"),
              onPressed: () {
                _capturePng2();
              },
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Image.memory(
                    images[index],
                    fit: BoxFit.cover,
                  );
                },
                itemCount: images.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          rootWidgetKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      images.add(pngBytes);
      setState(() {

      });
      return pngBytes;
    } catch (e) {
      print(e);
    }

    return null;
  }

  void _capturePng2(){
    ScreenShotUtil.saveScreenShot(ScreenShotOption(
      ScreenShotRenderOption.withGlobalKey(
        rootWidgetKey,
        pixelRatio: 1.0,
        imageFormatType: ImageByteFormat.png,
      ),
      ScreenShotFileOption.withDefault('11111.jpg'),
      success: (String fullPath){
        print("saveScreenShot success");
      },
      fail: (){
        print("saveScreenShot fail");
      }
    ));
  }


  static Future<Uint8List> captureImage2List(RenderRepaintBoundary boundary,
      double pixelRatio, ImageByteFormat imageFormatType) async {
    try{
      ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      ByteData byteData = await image.toByteData(format: imageFormatType);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      return pngBytes;
    }catch(e){
      print(e);
    }
    return null;
  }
}

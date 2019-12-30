import 'dart:math';

import 'package:borg_flutter/mobx/multi_counter/multi_counter_store.dart';
import 'package:borg_flutter/mobx/settings/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'examples.dart';
import 'settings/preferences_service.dart';
import 'connectivity/connectivity_store.dart';

class MobxDemo extends StatelessWidget {
  static const String routeName = '/page/mobx';
  static const String name = "MobxDemo";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('haha'),
      ),
      body:HomeContent(),
    );
  }



//  @override
//  Widget build(BuildContext context) {
//    return MultiProvider(
//      providers: [
//        Provider<MultiCounterStore>(
//          builder: (_) => MultiCounterStore(),
//        ),
//        Provider<PreferencesService>(
//          builder: (_) => PreferencesService(),
//        ),
//        ProxyProvider<PreferencesService, SettingsStore>(
//            builder: (_, preferencesService, __) =>
//                SettingsStore(preferencesService)),
//        Provider<ConnectivityStore>(
//          builder: (_) => ConnectivityStore(),
//        )
//      ],
//      child: Consumer<SettingsStore>(
//        builder: (_, store, __) => Observer(
//          builder: (_) => MaterialApp(
//            initialRoute: '/',
//            theme: ThemeData(
//              primarySwatch: Colors.blue,
//              brightness:
//              store.useDarkMode ? Brightness.dark : Brightness.light,
//            ),
//            routes: {
//              '/': (_) => ExampleList(),
//            }..addEntries(
//                examples.map((ex) => MapEntry(ex.path, ex.widgetBuilder))),
//          ),
//        ),
//      ),
//    );
//  }
}


class HomeContent extends StatefulWidget {
  HomeContent({Key key}) : super(key: key);

  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  double _width = 60;
  double _height = 60;
  Color _color = Colors.pink;
  Matrix4 _transform = null;
  BorderRadius _borderRadius = BorderRadius.circular(8);
  double opacity=0;

  void _onTapHandle() {
    Random random = new Random();
    setState(() {
      _width = random.nextInt(300).toDouble();
      _height = random.nextInt(300).toDouble();
      _borderRadius = BorderRadius.circular(random.nextInt(300).toDouble());
      _color = Color.fromARGB(
          255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
      _transform = Matrix4.translationValues(random.nextInt(50).toDouble(),
          random.nextInt(50).toDouble(), random.nextInt(50).toDouble());
      opacity = opacity<0.5?1:0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: AnimatedContainer(
            width: _width,
            height: _height,
            transform: _transform,
            duration: Duration(
              milliseconds: 500,
            ),
            child: AnimatedOpacity(
              duration: Duration(
                milliseconds: 5000,
              ),
              opacity: opacity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: _borderRadius,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 1,
          right: 1,
          child: GestureDetector(
            child: Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.pink,
              ),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
            ),
            onTap: _onTapHandle,
          ),
        )
      ],
    );
  }
}

class Example extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Listener(
        child: AbsorbPointer(
          absorbing: true,
          child: Listener(
            child: Container(
              width: 200,
              height: 200,
              color: Colors.red,
            ),
            onPointerDown: (event) =>
                debugPrint("内层点击事件"),
            onPointerMove: (event) =>
                debugPrint("onPointerMove:  " + event.delta.toString()),
            onPointerUp: (event) =>
                debugPrint("onPointerUp:  " + event.toString()),
          ),
        ),
        onPointerDown: (event){
          debugPrint('外层点击事件');
          showModalBottomSheet(context: context, builder: (BuildContext context){
            return Container(
              height: 200,
              color: Colors.amberAccent,
              child: GestureDetector(
                child: ButtonBar(
                    alignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        child: Text("111"),
                        onPressed: () => {},
                      ),
                      RaisedButton(
                        child: Text("222"),
                        onPressed: () => {},
                      ),
                    ],
                ),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
            );
          });
        },
      ),
    );
  }
}

class ExampleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Flutter MobX Examples'),
      ),
      body: ListView.builder(
        itemCount: examples.length,
        itemBuilder: (_, int index) {
          final ex = examples[index];

          return ListTile(
            title: Text(ex.title),
            subtitle: Text(ex.description),
            trailing: const Icon(Icons.navigate_next),
            onTap: () => Navigator.pushNamed(context, ex.path),
          );
        },
      ));
}

import 'package:flutter/material.dart';
import 'package:flutter_template/network/http_client_manager.dart';
import 'package:flutter_template/config/env.dart';
import 'package:flutter_template/router/borg_router.dart';
import 'package:flutter_template/router/routers.dart';

void main() async{
  await Env().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() async{
    setState(() {
      _counter++;
    });

    Router.push(context, 'http://www.baidu.com');
  }

  @override
  void initState() {
    super.initState();
    HttpClientManager().get('http://www.baidu.com', null, ((data){
      print(data);
    }), (code,msg){
      print('code=$code msg=$msg');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

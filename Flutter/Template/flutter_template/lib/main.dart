import 'package:flutter/material.dart';
import 'package:flutter_template/network/http_client_manager.dart';
import 'package:flutter_template/config/env.dart';
import 'package:flutter_template/router/borg_router.dart';
import 'package:flutter_template/utils/toast_util.dart';
import 'package:oktoast/oktoast.dart';
import 'page/error_page.dart';
import 'dart:async';
import 'screen_adapter/Inner_widgets_flutter_binding.dart';

void main() async {
  await Env().init();
  var isInDebugMode = false;

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return ErrorPage(details);
  };

  //全局的异常捕获
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
  runZoned<Future<Null>>(() async {
    InnerWidgetsFlutterBinding.ensureInitialized()
      ..attachRootWidget(MyApp())
      ..scheduleForcedFrame();
  }, onError: (error, stackTrace) async {
    _handleError(error, stackTrace);
  });
  runApp(MyApp());
}

void _handleError(error, stackTrace) async {
  debugPrint("--------------_handleError begin---------------");
  debugPrint(error);
  debugPrint(stackTrace);
  debugPrint("--------------_handleError end-----------");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
      textStyle: TextStyle(fontSize: 19.0, color: Colors.white),
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

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });

    Router.push(context, 'http://www.baidu.com');
  }

  @override
  void initState() {
    super.initState();
    HttpClientManager().get('http://www.baidu.com', null, ((data) {
      print(data);
    }), (code, msg) {
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

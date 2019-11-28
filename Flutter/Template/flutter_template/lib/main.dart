import 'package:flutter/material.dart';
import 'package:flutter_template/business/main/main_page.dart';
import 'package:flutter_template/config/env.dart';
import 'package:oktoast/oktoast.dart';
import 'page/error_page.dart';
import 'dart:async';
import 'screen_adapter/Inner_widgets_flutter_binding.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    return ExcludeSemantics(
      excluding: true,
      child: OKToast(
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MainPage(),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('zh', 'CH'),
          ],
        ),
        textStyle: TextStyle(fontSize: 19.0, color: Colors.white),
      ),
    );
  }
}

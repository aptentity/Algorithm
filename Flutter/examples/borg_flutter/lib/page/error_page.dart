import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final FlutterErrorDetails details;
  ErrorPage(this.details) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('错误'),
        ),
        body: SingleChildScrollView(
          child: Text(details.stack.toString()),
        )
    );
  }
}

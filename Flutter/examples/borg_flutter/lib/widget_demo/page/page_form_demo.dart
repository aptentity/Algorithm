import 'package:flutter/material.dart';

class FormDemoPage extends StatefulWidget {
  static const String routeName = '/page/form_demo_page';
  static const String name = "FormDemoPage";

  @override
  _FormDemoState createState() => _FormDemoState();
}

class _FormDemoState extends State<FormDemoPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name;
  String _password;
  String _common;

  void _forSubmitted() {
    var _form = _formKey.currentState;

    if (_form.validate()) {
      _form.save();
      print(_name);
      print(_password);
      print(_common);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter data',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Form'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _forSubmitted,
          child:  Text('提交'),
        ),
        body:  Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child:  Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                  ),
                  onSaved: (val) {
                    _name = val;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: (val) {
                    return val.length < 4 ? "密码长度错误" : null;
                  },
                  onSaved: (val) {
                    _password = val;
                  },
                ),
                Container(
                  child: TextFormField(
                    autovalidate: true,
                    decoration: InputDecoration(
                      labelText: 'Common',
                    ),
                    obscureText: true,
                    validator: (val) {
                      return val.length < 4 ? "密码长度错误" : null;
                    },
                    onSaved: (val) {
                      _common = val;
                    },
                    onFieldSubmitted: (val){
                      print(val);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'dart:convert';

import 'package:borg_flutter/widget/dk_form.dart';
import 'package:borg_flutter/widget/widget_dk_check_box_form_field.dart';
import 'package:flutter/material.dart';

class DkFormFieldDemoPage extends StatefulWidget {
  static const String routeName = '/page/dkformfeild_demo_page';
  static const String name = "DkFormFieldDemoPage";

  @override
  DkFormFieldDemoState createState() => DkFormFieldDemoState();
}

class DkFormFieldDemoState extends State<DkFormFieldDemoPage> {
  GlobalKey<DkFormState> _formKey = GlobalKey<DkFormState>();
  void _forSubmitted() {
    var _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      print(json.encode(_form.value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DkFormFieldDemoPage'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('Save'),
        onPressed: _forSubmitted,
      ),
      body: SingleChildScrollView(
        child:DkForm(
          key: _formKey,
          child: Column(
            children: <Widget>[
              DkCheckBoxFormField(
                attribute: 'agree',
                secondary: const Icon(Icons.shutter_speed),
                title: const Text('同意协议'),
                validator: (bool b){
                  return !b?'must agree':null;
                },
                onChanged: (bool b){
                  print('agree state is $b');
                },
                valueTransformer: (value){
                  return value?1:0;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

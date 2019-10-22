import 'dart:convert';

import 'package:borg_flutter/widget/dk_form.dart';
import 'package:borg_flutter/widget/widget_dk_check_box_form_field.dart';
import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';

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

  void _forResert(){
    var _form = _formKey.currentState;
    _form.reset();
  }

  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();
    childButtons.add(UnicornButton(
      hasLabel: true,
      labelText: 'reset',
      currentButton: FloatingActionButton(
        heroTag: 'reset',
        backgroundColor: Colors.redAccent,
        mini: true,
        child: Icon(Icons.train),
        onPressed: _forResert,
      ),
    ));
    childButtons.add(UnicornButton(
      currentButton: FloatingActionButton(
        child: Text('Save'),
        onPressed: _forSubmitted,
      ),
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text('DkFormFieldDemoPage'),
      ),
      floatingActionButton: UnicornDialer(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
          parentButtonBackground: Colors.redAccent,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.add),
          childButtons: childButtons
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

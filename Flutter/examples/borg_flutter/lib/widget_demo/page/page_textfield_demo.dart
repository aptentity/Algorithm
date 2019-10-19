import 'package:flutter/material.dart';

class TextFieldDemoPage extends StatelessWidget {
  static const String routeName = '/page/TextField_demo_page';
  static const String name = "TextFieldDemoPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TextFieldDemoPage'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(),
            TextField(
              decoration: null,
            ),
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'labelText',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'labelText',
                labelStyle: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 20,
                ),
                helperText: 'help text',
                helperStyle: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'labelText',
                labelStyle: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 20,
                ),
                helperText: 'help text',
                helperStyle: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                ),
                errorText: 'error Text',
                errorStyle: TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontSize: 15,
                ),
                hintText: 'hint Text',
                hasFloatingPlaceholder: false,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.perm_identity),
                prefixText: 'prefixText',
                labelText: 'labelText',
                helperText: 'help text',
                hintText: 'hint Text',
                suffixIcon: Icon(Icons.remove_red_eye),
                suffixText: 'suffixText',
                counterText: 'counterText',
                fillColor: Colors.grey,
                filled: true,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.perm_identity),
                prefixText: 'prefixText',
                labelText: 'labelText',
                helperText: 'help text',
                hintText: 'hint Text',
                suffixIcon: Icon(Icons.remove_red_eye),
                suffixText: 'suffixText',
                counterText: 'counterText',
                //border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30), //边角为30
                  ),
                  borderSide: BorderSide(
                    color: Colors.amber, //边线颜色为黄色
                    width: 2, //边线宽度为2
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.green, //边框颜色为绿色
                  width: 5, //宽度为5
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

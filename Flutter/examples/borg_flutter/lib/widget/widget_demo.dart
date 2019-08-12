import 'package:flutter/material.dart';

class DemoWidget extends StatefulWidget {
  final IconData iconData;
  final String title;
  final GestureTapCallback onTap;

  const DemoWidget({Key key, this.iconData, this.title, this.onTap})
      : super(key: key);

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<DemoWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.widget.onTap,
      child: Column(
        children: <Widget>[
          Icon(
            this.widget.iconData,
            size: 45.0,
          ),
          Text(
            this.widget.title == null ? "" : this.widget.title,
            style: TextStyle(fontSize: 14.0, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}

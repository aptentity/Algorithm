import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new SecondPageState();
}

class SecondPageState extends State<SecondPage> with WidgetsBindingObserver{
  @override
  void initState() {
    print("SecondPageState");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Secone"),
      ),
      body: new Center(
        child: new Text("我是第二页"),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('-------------SecondPageState didChangeAppLifecycleState:$state');
  }

  @override
  void deactivate() {
    super.deactivate();
    print('+++++++++++++SecondPageState deactivate');
  }


}

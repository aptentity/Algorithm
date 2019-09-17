import 'package:flutter/material.dart';

class ThirdPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ThirdPageState();
}

class ThirdPageState extends State<ThirdPage>{
  @override
  void initState() {
    print("@@@@@@@@@@ThirdPageState initState");
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
    print('@@@@@@@@@@ThirdPageState deactivate');
  }

  @override
  Widget build(BuildContext context) {
    return ThirdInPage();
  }
}

class ThirdInPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new ThirdInPageState();
}

class ThirdInPageState extends State<ThirdInPage> with WidgetsBindingObserver,AutomaticKeepAliveClientMixin{
  @override
  void initState() {
    print("ThirdInPageState");
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
    print('+++++++++++++ThirdInPageState build');
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Third"),
      ),
      body: new Center(
        child: new Text("我是第三页"),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('-------------ThirdInPageState didChangeAppLifecycleState:$state');
  }

  @override
  void deactivate() {
    super.deactivate();
    print('+++++++++++++ThirdInPageState deactivate');
  }

  @override
  bool get wantKeepAlive => true;
}

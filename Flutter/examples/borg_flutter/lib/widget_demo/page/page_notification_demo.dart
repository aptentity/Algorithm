import 'package:flutter/material.dart';
//0.自定义一个Notification。
class MyNotification extends Notification {}

class NotificationPage extends StatefulWidget{
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //2.在Scaffold的层级进行事件的监听。创建`NotificationListener`,并在`onNotification`就可以得到我们的事件了。
    return NotificationListener(
        onNotification: (event) {
          if (event is MyNotification) {
            print("event= Scaffold MyNotification");
          }
        },
        child: new Scaffold(
            appBar: new AppBar(
              title: new Text('MyNotification'),
            ),
            //3.注意，这里是监听不到事件的。这里需要监听到事件，需要在body自己的`BuildContext`发送事件才行！！！！
            body: new NotificationListener<MyNotification>(
                onNotification: (event) {
                  //接受不到事件，因为`context`不同
                  print("body event=" + event.toString());
                },
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        'appState.isLoading = ',
                      ),
                      new Text(
                        'appState.canListenLoading.value',
                      ),
                    ],
                  ),
                )),
            floatingActionButton: Builder(builder: (context) {
              return FloatingActionButton(
                onPressed: () {
                  //1.创建事件，并通过发送到对应的`BuildContext`中。注意，这里的`context`是`Scaffold`的`BuildContext`
                  new MyNotification().dispatch(context);
                },
                tooltip: 'ChangeState',
                child: new Icon(Icons.add),
              );
            })));
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class AnimationDemoPage extends StatefulWidget {
  static const String routeName = '/page/animation_page';
  static const String name = "AnimationDemoPage";

  @override
  _AnimationDemoState createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemoPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    animation = new Tween(begin: 0.0, end: 300.0).animate(controller)
      ..addListener(() {
        debugPrint("animation listener");
        setState(() {});
      })
      ..addStatusListener((state) {
        print("$state");
        if (state == AnimationStatus.completed) {
          controller.reverse();
        } else if (state == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AnimationDemoPage"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.blue,
            height: animation.value,
            width: animation.value,
            child: Center(
              child: Text("啦啦"),
            ),
          ),
          AnimatedLogo(animation: animation),
          GrowTransition(
            child: FlutterLogo(),
            animation: animation,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Center(
      child: new Container(
        margin: new EdgeInsets.symmetric(vertical: 10.0),
        height: animation.value,
        width: animation.value,
        child: FlutterLogo(),
      ),
    );
  }
}

class GrowTransition extends StatelessWidget {
  GrowTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) {
          return Container(
            height: animation.value,
            width: animation.value,
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}

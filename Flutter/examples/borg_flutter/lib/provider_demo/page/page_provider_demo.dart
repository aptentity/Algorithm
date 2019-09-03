import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class ProviderDemoPage extends StatelessWidget {
  static const String routeName = '/page/provider_demo_page';
  static const String name = "ProviderPage";

  @override
  Widget build(BuildContext context) {
    return ProviderPage0();
  }
}

class ProviderPage0 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<ProviderBloc>(
      builder: (context) => ProviderBloc(),
      dispose: (context, bloc) => bloc.dispose(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('ProviderPage'),
        ),
        body: CounterLabel(),
        floatingActionButton: CounterButton(),
      ),
    );
  }
}

class CounterLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<int>(
        builder: (context, sanpshot) {
          return Text('you have push ${sanpshot.data} times');
        },
        initialData: 0,
        stream: Provider.of<ProviderBloc>(context).stream,
      ),
    );
  }
}

class CounterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: Provider.of<ProviderBloc>(context).increment(),
      child: const Icon(Icons.add),
    );
  }
}

class ProviderBloc {
  int _count = 0;
  var _countController = StreamController<int>.broadcast();

  Stream<int> get stream => _countController.stream;
  int get count => _count;

  increment() {
    _countController.sink.add(++_count);
  }

  dispose() {
    _countController.close();
  }
}

///-----------------------------------------------
class ProviderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<String>.value(
      value: 'FirstPage Provider',
      child: ProviderChild(),
    );
  }
}

class ProviderChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('${Provider.of<String>(context)}');
  }
}

///------------------end-------------------------

/// 聚合方式
class ProviderWidget1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<int>.value(value: 200),
        Provider<bool>.value(value: false),
        Provider<String>.value(value: 'lala'),
        Provider<String>.value(value: '-----'),
      ],
      child: ProviderChild1(),
    );
  }
}

class ProviderChild1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('${Provider.of<String>(context)}\n'
        '${Provider.of<int>(context)}\n'
        '${Provider.of<bool>(context)}\n'
        '${Provider.of<String>(context)}');
  }
}

///-------------------end------------------------

/// 嵌套绑定
class ProviderWidget2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<String>.value(
      value: 'kakaka',
      child: Provider<int>.value(
        value: 3000,
        child: Provider<bool>.value(
          value: true,
          child: ProviderChild1(),
        ),
      ),
    );
  }
}

///-------------------end------------------------

class ProviderPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Counter>(
      builder: (context) => Counter(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("ProviderPage1"),
        ),
        body: CounterLabel1(),
        floatingActionButton: CounterButton1(),
      ),
    );
  }
}

class Counter with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class CounterButton1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: Provider.of<Counter>(context, listen: false).increment,
      child: const Icon(Icons.add),
    );
  }
}

class CounterLabel1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<Counter>(
        builder: (BuildContext context, Counter counter, Widget child) {
          return Text('you have push ${counter.count} times');
        },
      ),
    );
  }
}

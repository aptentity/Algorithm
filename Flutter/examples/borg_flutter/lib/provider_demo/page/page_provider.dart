import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderPage extends StatelessWidget {
  static const String routeName = '/page/provider_page';
  static const String name = "Provider Page";

  @override
  Widget build(BuildContext context) {
//    return Provider<int>.value(
//      value: 1,
//      child: ChangeNotifierProvider.value(
//        value: Counter(2),
//        child: Scaffold(
//          appBar: AppBar(title: const Title()),
//          body: const Center(child: CounterLabel()),
//          floatingActionButton: const IncrementCounterButton(),
//        ),
//      ),
//    );

    return ChangeNotifierProvider.value(
      value: Counter(2),
      child: Scaffold(
        appBar: AppBar(title: Text("${Provider.of<Counter>(context).count}")),
        body: const Center(child: CounterLabel()),
        floatingActionButton: const IncrementCounterButton(),
      ),
    );
//    return MultiProvider(
//      providers: [
//        ChangeNotifierProvider(builder: (_) => Counter(1)),
//      ],
//      child: Consumer<Counter>(
//        builder: (context, counter, _) {
//          return Scaffold(
//            appBar: AppBar(title: const Title()),
//            body: const Center(child: CounterLabel()),
//            floatingActionButton: const IncrementCounterButton(),
//          );
//        },
//      ),
//    );
  }
}

class Counter with ChangeNotifier {
  int _count;

  Counter(this._count);

  void add() {
    _count++;
    notifyListeners();
  }

  get count => _count;
}

class IncrementCounterButton extends StatelessWidget {
  const IncrementCounterButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // `listen: false` is specified here because otherwise that would make
        // `IncrementCounterButton` rebuild when the counter updates.
        Provider.of<Counter>(context, listen: false).add();
      },
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}

class CounterLabel extends StatelessWidget {
  const CounterLabel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'You have pushed the button this many times:',
        ),
        Text(
          '${counter.count}',
          style: Theme.of(context).textTheme.display1,
        ),
      ],
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("${Provider.of<Counter>(context).count}");
  }
}

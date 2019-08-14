import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'dart:async';

class BlocPage extends StatelessWidget {
  static const String routeName = '/page/bloc_page';
  static const String name = "BlocPage";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (BuildContext context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Counter'),
        ),
        body: BlocPage1(),
      ),
    );
  }
}

class BlocPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CounterBloc counterBloc = BlocProvider.of<CounterBloc>(context);

    return BlocBuilder<CounterBloc, int>(
      builder: (context, count) {
        return Center(
          child: Column(
            children: <Widget>[
              Text(
                '$count',
                style: TextStyle(fontSize: 24.0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    counterBloc.dispatch(CounterEvent.increment);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: FloatingActionButton(
                  child: Icon(Icons.remove),
                  onPressed: () {
                    counterBloc.dispatch(CounterEvent.decrement);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

enum CounterEvent { increment, decrement }

class CounterBloc extends Bloc<CounterEvent, int> {
  @override
  int get initialState => 2;

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    switch (event) {
      case CounterEvent.decrement:
        yield currentState - 1;
        break;
      case CounterEvent.increment:
        yield currentState + 1;
        break;
    }
  }
}

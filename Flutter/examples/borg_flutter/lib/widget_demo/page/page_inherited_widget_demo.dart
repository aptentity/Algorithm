import 'package:flutter/material.dart';

class AppState {
  bool isLoading;

  AppState({this.isLoading = true});

  factory AppState.loading() => AppState(isLoading: true);

  @override
  String toString() {
    return 'AppState {isLoading:$isLoading}';
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final AppState data;

  _InheritedStateContainer(
      {Key key, @required this.data, @required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer oldWidget) {
    return data != oldWidget.data;
  }

  static AppState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }
}

class InheritedPage extends StatelessWidget {
  static const String routeName = '/page/inherited_page';
  static const String name = "InheritedPage";

  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: AppState.loading(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('InheritedPage'),
        ),
        body: Column(
          children: <Widget>[
            InheritedOnePage(),
            InheritedTwoPage(),
          ],
        ),
      ),
    );
  }
}

class InheritedOnePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppState data = _InheritedStateContainer.of(context);
    return Text(data.toString());
  }
}

class InheritedTwoPage extends StatefulWidget {
  @override
  InheritedTwoState createState() => InheritedTwoState();
}

class InheritedTwoState extends State<InheritedTwoPage> {
  AppState appState;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appState = _InheritedStateContainer.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        appState.isLoading
            ? CircularProgressIndicator()
            : Text(appState.toString()),
        InheritedOnePage(),
        RaisedButton(
          child: Icon(Icons.swap_horiz),
          onPressed: (){
            appState.isLoading = !appState.isLoading;
            setState(() {
            });
          },
        ),
      ],
    );
  }
}

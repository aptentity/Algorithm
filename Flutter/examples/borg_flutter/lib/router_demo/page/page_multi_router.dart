import 'package:flutter/material.dart';
import 'package:borg_flutter/widget_demo/page/page_paint_demo.dart';

class MultiRouterPage extends StatefulWidget{
  static const String routeName = '/page/multi_router_page';
  static const String name = "MultiRouterPage";
  @override
  _MultiRouterState createState() => _MultiRouterState();
}

class _MultiRouterState extends State<MultiRouterPage>{
  int _currentIndex =0;
  final List<Widget> _children =[
    //PlaceholderWidget('Home'),
    HomeNavigator(),
    PlaceholderWidget('Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(icon: Icon(Icons.home),title: Text('Home')),
          new BottomNavigationBarItem(icon: Icon(Icons.person),title: Text('Profile')),
        ],
        onTap: onTabTapped,
      ),
    );
  }

  void onTabTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }
}

class PlaceholderWidget extends StatelessWidget{
  final String text;
  PlaceholderWidget(this.text);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}

class HomeNavigator extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'home',
      onGenerateRoute: (RouteSettings settings){
        WidgetBuilder builder;
        switch(settings.name){
          case 'home':
            builder = (BuildContext context)=> HomePage();
            break;
          case 'demo':
            builder = (BuildContext context) => SignatureDemoPage();
            break;
          default:
            throw new Exception('Invalid router:${settings.name}');
        }

        return new MaterialPageRoute(builder: builder,settings: settings);
      },
    );
  }
}


class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('demo'),
          onPressed: (){
            Navigator.of(context).pushNamed('demo');
          },
        ),
      ),
    );
  }
}
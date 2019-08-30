import 'package:flutter/material.dart';

class HeroSourcePage extends StatelessWidget {
  static const String routeName = '/page/hero_page';
  static const String name = "HeroSourcePage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HeroSourcePage"),
      ),
      body: InkWell(
        child: Hero(
          tag: "DemoTag",
          child: Icon(
            Icons.add,
            size: 70,
          ),
          placeholderBuilder: (context,heroSize,widget){
            return Container(
              height: 150,
              width: 150,
              child: CircularProgressIndicator(),
            );
          },
          flightShuttleBuilder: (flightContext, animation, direction,
              fromContext, toContext){
            if(direction == HeroFlightDirection.push) {
              return Icon(
                Icons.favorite,
                size: 150.0,
              );
            } else if (direction == HeroFlightDirection.pop){
              return Icon(
                Icons.favorite,
                size: 70.0,
              );
            }
            return Icon(Icons.favorite, size: 150.0,);
          },
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return HeroDesPage();
          }),
        ),
      ),
    );
  }
}

class HeroDesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HeroDesPage"),
      ),
      body: InkWell(
        child: Center(
          child: Hero(
            tag: "DemoTag",
            child: Icon(
              Icons.subway,
              size: 150,
            ),
          ),
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}

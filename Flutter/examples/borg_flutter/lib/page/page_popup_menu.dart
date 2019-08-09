import 'package:flutter/material.dart';

class PopupMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PopupMenuButtonPage'),
        actions: <Widget>[
          PopupMenuButton<WhyFarther>(
            elevation: 15.0,
            offset: Offset(-100, -10),
            onSelected: (WhyFarther result) {},
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
              const PopupMenuItem<WhyFarther>(
                value: WhyFarther.harder,
                child: Text('Working a lot harder'),
              ),
              const PopupMenuItem<WhyFarther>(
                value: WhyFarther.smarter,
                child: Text('Being a lot smarter'),
              ),
              const PopupMenuItem<WhyFarther>(
                value: WhyFarther.selfStarter,
                child: Text('Being a self-starter'),
              ),
              const PopupMenuItem<WhyFarther>(
                value: WhyFarther.tradingCharter,
                child: Text('Placed in charge of trading charter'),
              ),
            ],
          )
        ],
      ),
      body: Theme(///控制颜色
        data: ThemeData(cardColor: Colors.red, canvasColor: Colors.amberAccent),
        child: Column(
          children: <Widget>[
            PopupMenuButton<WhyFarther>(
              onSelected: (WhyFarther result) {},
              icon: Icon(Icons.more_vert),
              tooltip: 'haha',
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<WhyFarther>>[
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.harder,
                  child: Text('Working a lot harder'),
                ),
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.smarter,
                  child: Text('Being a lot smarter'),
                ),
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.selfStarter,
                  child: Text('Being a self-starter'),
                ),
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.tradingCharter,
                  child: Text('Placed in charge of trading charter'),
                ),
              ],
            ),
            Text('lalala'),
          ],
        ),
      ),
    );
  }
}

enum WhyFarther {
  harder,
  smarter,
  selfStarter,
  tradingCharter,
}

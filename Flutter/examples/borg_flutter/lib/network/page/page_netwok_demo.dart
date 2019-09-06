import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class NetworkPage extends StatelessWidget {
  static const String routeName = '/page/network_page';
  static const String name = "NetworkPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NetworkPage'),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('get'),
            onPressed: () => getHttp(),
          ),
        ],
      ),
    );
  }

  void getHttp() async{
    Response response = await Dio().get('http://www.baidu.com',queryParameters: {'id':123});
    print('-----------response');
    print(response);
    print('-----------headers');
    print(response.headers);
    print('-----------data');
    print(response.data.toString());
    print('-----------request');
    print(response.request);
    print('-----------extra');
    print(response.extra);
    print('-----------isRedirect');
    print(response.isRedirect);
    print('-----------redirects');
    print(response.redirects);
    print('-----------statusCode');
    print(response.statusCode);
    print('-----------statusMessage');
    print(response.statusMessage);
    print('-----------realUri');
    //print(response.realUri??'no realUrl');
  }
  
  
  void getMultiHttp() async{
    Dio dio = new Dio();
    List<Response> responses = await Future.wait([dio.get("http://www.baidu.com"),dio.get('http://www.163.com')]);
    for(Response response in responses){
      print(response.data.toString());
    }
  }
}

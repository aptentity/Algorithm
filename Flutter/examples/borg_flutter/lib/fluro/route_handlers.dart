import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:borg_flutter/key_demo/page_stateless_key.dart';

var homeHandle = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return StatelessColorfulTile();
});

var demoHandle = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return SwapColorPage();
});

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_template/config/env.dart';

class HeaderInterceptor extends Interceptor{
  @override
  onRequest(RequestOptions options) async {
    Map<String,dynamic> header = Map();
    Map<String,String> xDevice = Map();
    xDevice..addAll(Env().packageInfo.toMap())..addAll(Env().deviceInfo.toMap());

    header[HEADER_X_DEVICE_ID] = json.encode(xDevice);
    options.headers.addAll(header);
  }

  static const String HEADER_X_APP_ID = "X-App-ID";
  static const String HEADER_X_DEVICE_ID = "X-Device-ID";
  static const String HEADER_X_DEVICE_INFO = "X-Device-Info";
}
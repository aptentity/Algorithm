import 'package:dio/dio.dart';
import 'package:flutter_template/config/env.dart';
import 'package:quiver/strings.dart';
import 'dart:io';
import 'dart:convert';

/// 网络请求client（单例）
///
class HttpClientManager {
  static final HttpClientManager _clientManager = HttpClientManager._internal();
  factory HttpClientManager() {
    return _clientManager;
  }

  Dio dio;
  HttpClientManager._internal() {
    dio = Dio();
    // 配置信息
    dio.options.connectTimeout = Env().netWorkConfig.connectTimeout;
    dio.options.receiveTimeout = Env().netWorkConfig.receiveTimeout;

    switch (Env().type) {
      case EnvType.RELEASE:
        break;
      case EnvType.DEBUG:
      case EnvType.TEST:
      case EnvType.PRE_RELEASE:
        dio.interceptors.add(LogInterceptor());
    }

    // 代理信息
    if (isNotEmpty(Env().netWorkConfig.localProxyPort)) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.findProxy = (uri) {
          return "PROXY ${Env().netWorkConfig?.localProxyIPAddress}:${Env().netWorkConfig?.localProxyPort}";
        };

        //信任https证书
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
  }

  /// 添加拦截器
  addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
  }

  get(String url, FormData params, Function successCallBack,
      Function errorCallBack) async {
    Response response;
    try {
      response = await dio.get(url, queryParameters: params);
    } on DioError catch (error) {
      _dioError(errorCallBack, error);
    }
    _success(response, successCallBack, errorCallBack);
  }

  post(String url, FormData params, Function successCallBack,
      Function errorCallBack) async {
    Response response;
    try {
      response = await dio.post(url, data: params);
    } on DioError catch (error) {
      _dioError(errorCallBack, error);
    }
    _success(response, successCallBack, errorCallBack);
  }

  _dioError(Function errorCallBack, DioError error) {
    Response errorResponse;
    if (error.response != null) {
      errorResponse = error.response;
    } else {
      errorResponse = new Response(statusCode: 666);
    }
    String msg;
    switch (error.type) {
      case DioErrorType.CANCEL:
        msg = '请求被取消';
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        msg = '服务器连接超时';
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        msg = '服务器请求超时';
        break;
      case DioErrorType.SEND_TIMEOUT:
        msg = '数据发送超时';
        break;
      case DioErrorType.RESPONSE:
        msg = '网络请求错误 ${errorResponse.statusCode}';
        break;
      case DioErrorType.DEFAULT:
        msg = '默认错误';
        break;
    }
    _error(errorCallBack, '-100', msg);
  }

  _error(Function errorCallBack, String code, String msg) {
    if (errorCallBack != null) {
      errorCallBack(code, msg);
    }
  }

  _success(
      Response response, Function successCallBack, Function errorCallBack) {
    String dataStr = json.encode(response.data);
    Map<String, dynamic> dataMap = json.decode(dataStr);
    if (dataMap == null || dataMap['code'] != 0) {
      _error(errorCallBack, dataMap['code'], dataMap['msg']);
    } else {
      if (successCallBack != null) {
        successCallBack(dataMap['data']);
      }
    }
  }
}

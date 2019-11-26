import 'package:flutter/cupertino.dart';
import 'package:flutter_template/config/network_config.dart';
import 'package:flutter_template/utils/device_info.dart';
import 'package:flutter_template/utils/package_info.dart';
import 'package:flutter_template/network/http_client_manager.dart';
import 'package:flutter_template/network/header_interceptor.dart';

class Env{
  static final Env _env = Env._internal();

  factory Env(){
    return _env;
  }

  EnvType type = EnvType.DEBUG;
  NetWorkConfig netWorkConfig;
  DeviceInfo deviceInfo;
  PackageInfo packageInfo;

  Env._internal(){
    netWorkConfig = NetWorkConfig();
  }

  init() async{
    // 获取设备信息
    deviceInfo = await DeviceInfoUtil.getDeviceInfo();
    debugPrint(deviceInfo.toString());

    //获取应用信息
    packageInfo = await PackageInfoUtil.getPackageInfo();
    debugPrint(packageInfo.toString());

    HttpClientManager().addInterceptor(HeaderInterceptor());
  }
}


///app运行环境标识
///* DEBUG 开发环境
///* TEST 测试环境
///* PRE_RELEASE 预发布环境
///* RELEASE 线上环境
enum EnvType {
  DEBUG,
  TEST,
  PRE_RELEASE,
  RELEASE,
}
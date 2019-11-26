import 'package:device_info/device_info.dart';
import 'dart:io';

class DeviceInfoUtil{
  static Future<DeviceInfo> getDeviceInfo() async{
    DeviceInfo info = DeviceInfo();

    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if(Platform.isIOS){
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      info.brand = 'iPhone';
      info.model = iosInfo.name;
      info.version = iosInfo.systemVersion;
      info.deviceId = iosInfo.identifierForVendor;
      info.system = 'iOS';
    }else if(Platform.isAndroid){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      info.brand = androidInfo.brand;
      info.model = androidInfo.model;
      info.version = androidInfo.version.release;
      info.deviceId = androidInfo.androidId;
      info.system = 'Android';
    }
    return info;
  }
}

class DeviceInfo{
  String brand;
  String model;
  String version;
  String deviceId;
  String system;

  @override
  String toString() {
    return 'system=$system brand=$brand model=$model version=$version deviceId=$deviceId';
  }

  Map<String,String> toMap(){
    Map<String,String> map = Map();
    map['brand'] = brand;
    map['model'] = model;
    map['version'] = version;
    map['deviceId'] = deviceId;
    map['system'] = system;
    return map;
  }
}
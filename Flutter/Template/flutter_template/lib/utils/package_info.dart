import 'package:package_info/package_info.dart' as package;

class PackageInfoUtil{
  static Future<PackageInfo> getPackageInfo() async{
    package.PackageInfo packageInfo=await package.PackageInfo.fromPlatform();
    return PackageInfo(packageInfo.packageName,packageInfo.version);
  }
}

class PackageInfo{
  String version;
  String packageName;

  @override
  String toString() {
    return 'packageName=$packageName version=$version';
  }

  Map<String,String> toMap(){
    Map<String,String> map = Map();
    map['version'] = version;
    map['packageName'] = packageName;
    return map;
  }

  PackageInfo(this.packageName,this.version);
}
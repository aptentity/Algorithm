import 'package:flutter/material.dart';

class FlutterLifeCycle extends StatefulWidget {
  static const String routeName = '/page/flutter_lifecycle';
  static const String name = "FlutterLifeCycle";

  @override
  State<StatefulWidget> createState() {
    return FlutterLifeCycleState();
  }
}

class FlutterLifeCycleState extends State<FlutterLifeCycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); //添加观察者
  }

  ///生命周期变化时回调
//  resumed:应用可见并可响应用户操作
//  inactive:用户可见，但不可响应用户操作
//  paused:已经暂停了，用户不可见、不可操作
//  suspending：应用被挂起，此状态IOS永远不会回调
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("@@@@@@@@@  didChangeAppLifecycleState: $state");
  }

  ///当前系统改变了一些访问性活动的回调
  @override
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
    print("@@@@@@@@@ didChangeAccessibilityFeatures");
  }

  /// Called when the system is running low on memory.
  ///低内存回调
  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
    print("@@@@@@@@@ didHaveMemoryPressure");
  }

  /// Called when the system tells the app that the user's locale has
  /// changed. For example, if the user changes the system language
  /// settings.
  ///用户本地设置变化时调用，如系统语言改变
  @override
  void didChangeLocales(List<Locale> locale) {
    super.didChangeLocales(locale);
    print("@@@@@@@@@ didChangeLocales");
  }

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  ///应用尺寸改变时回调，例如旋转
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    Size size = WidgetsBinding.instance.window.physicalSize;
    print("@@@@@@@@@ didChangeMetrics  ：宽：${size.width} 高：${size.height}");
  }

  /// {@macro on_platform_brightness_change}
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    print("@@@@@@@@@ didChangePlatformBrightness");
  }

  ///文字系数变化
  @override
  void didChangeTextScaleFactor() {
    super.didChangeTextScaleFactor();
    print(
        "@@@@@@@@@ didChangeTextScaleFactor  ：${WidgetsBinding.instance.window.textScaleFactor}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("flutter"),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this); //销毁观察者
  }
}

//屏幕旋转
//竖屏切横屏
//2019-05-22 09:04:58.350 27881-27901/com.yourcompany.test1 I/flutter: @@@@@@@@@ didChangeLocales
//2019-05-22 09:04:58.353 27881-27901/com.yourcompany.test1 I/flutter: @@@@@@@@@ didChangeTextScaleFactor  ：1.0
//2019-05-22 09:04:58.354 27881-27901/com.yourcompany.test1 I/flutter: @@@@@@@@@ didChangePlatformBrightness
//2019-05-22 09:04:58.401 27881-27901/com.yourcompany.test1 I/flutter: @@@@@@@@@ didChangeLocales
//2019-05-22 09:04:58.402 27881-27901/com.yourcompany.test1 I/flutter: @@@@@@@@@ didChangeTextScaleFactor  ：1.0
//2019-05-22 09:04:58.402 27881-27901/com.yourcompany.test1 I/flutter: @@@@@@@@@ didChangePlatformBrightness
//2019-05-22 09:04:58.404 27881-27901/com.yourcompany.test1 I/flutter: @@@@@@@@@ didChangeMetrics  ：宽：1080.0 高：2280.0
//2019-05-22 09:04:58.405 27881-27901/com.yourcompany.test1 I/flutter: @@@@@@@@@ didChangeMetrics  ：宽：2198.0 高：1080.0
//横屏切竖屏
//2019-05-22 09:05:05.714 27881-27901/com.yourcompany.test1 I/flutter: @@@@@@@@@ didChangeLocales
//2019-05-22 09:05:05.715 27881-27901/com.yourcompany.test1 I/flutter: @@@@@@@@@ didChangeTextScaleFactor  ：1.0
//2019-05-22 09:05:05.715 27881-27901/com.yourcompany.test1 I/flutter: @@@@@@@@@ didChangePlatformBrightness
//2019-05-22 09:05:05.766 27881-27901/com.yourcompany.test1 I/flutter: @@@@@@@@@ didChangeLocales
//2019-05-22 09:05:05.767 27881-27901/com.yourcompany.test1 I/flutter: @@@@@@@@@ didChangeTextScaleFactor  ：1.0
//2019-05-22 09:05:05.767 27881-27901/com.yourcompany.test1 I/flutter: @@@@@@@@@ didChangePlatformBrightness
//2019-05-22 09:05:05.768 27881-27901/com.yourcompany.test1 I/flutter: @@@@@@@@@ didChangeMetrics  ：宽：2198.0 高：1080.0
//2019-05-22 09:05:05.769 27881-27901/com.yourcompany.test1 I/flutter: @@@@@@@@@ didChangeMetrics  ：宽：1080.0 高：2280.0

//改变系统语言，回到应用才调用以下方法
//2019-05-22 09:08:04.428 27881-27901/com.yourcompany.test1 I/flutter: @@@@@@@@@ didChangeLocales
//2019-05-22 09:08:04.429 27881-27901/com.yourcompany.test1 I/flutter: @@@@@@@@@ didChangeTextScaleFactor  ：1.0
//2019-05-22 09:08:04.429 27881-27901/com.yourcompany.test1 I/flutter: @@@@@@@@@ didChangePlatformBrightness


//  inactive:用户可见，但不可响应用户操作
//  resumed:应用可见并可响应用户操作
//  paused:已经暂停了，用户不可见、不可操作
//  suspending：应用被挂起，此状态IOS永远不会回调

//  Home键退出，锁屏
//  2019-05-22 08:29:26.321 27526-27546/com.yourcompany.test1 I/flutter: AppLifecycleState: AppLifecycleState.inactive
//  2019-05-22 08:29:26.378 27526-27546/com.yourcompany.test1 I/flutter: AppLifecycleState: AppLifecycleState.paused
//  Home键退出后再点击应用图标启动，解锁屏幕
//  2019-05-22 08:30:37.533 27526-27546/com.yourcompany.test1 I/flutter: AppLifecycleState: AppLifecycleState.inactive
//  2019-05-22 08:30:37.535 27526-27546/com.yourcompany.test1 I/flutter: AppLifecycleState: AppLifecycleState.resumed
//  进入该页面或者back键退出该页面，没有调用didChangeAppLifecycleState方法

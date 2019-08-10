# flutter_webview_plugin

- 不能在JS中调用Flutter方法
- 不能在H5进入某个URL之前拦截
- 单例，无法打开多个webview





# webview_flutter

iOS报错Trying to embed a platform view but the PrerollContext does not support embedding

解决方法：
Currently apps need to opt-in for the UIViews embedding preview on iOS by adding a boolean property to the Info.plist (key=io.flutter.embedded_views_preview value=YES).
在iOS工程的info.plist文件中添加键值对key=io.flutter.embedded_views_preview value=YES



JS调用Flutter有两种方法：`使用javascriptChannels发送消息`和`使用路由委托（navigationDelegate）拦截url`
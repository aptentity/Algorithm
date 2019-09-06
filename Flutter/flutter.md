# Flutter工程化改造

## 开发环境

## 代码管理

## 编译打包

## 混合开发

集成到现有app中

# 路由及多页面管理

对原生页面和 flutter 页面实现了集中路由管理，可以双向传参、跳转并且进行了共享内存优化



# 扩展UI组件库

官方支持的 Material 和 Cupertino 样式不能满足需求，我们内部实现了自定义样式的组件库。



# 原生能力扩展

对官方原生能力进行了扩展，封装了包括网络、登陆、埋点等等基础能力的打通并提供了 50+ 原生扩展 API

# 屏幕适配

https://cloud.tencent.com/developer/article/1419027

https://github.com/genius158/FlutterTest/tree/master/lib

https://github.com/OpenFlutter/flutter_screenutil

## 资源

图片等资源在 Flutter 中被放到了 assets 文件夹中。assets 可以是任意类型的文件，而不仅仅是图片。例如，你可以把 json 文件放置到 my-assets 文件夹中`my-assets/data.json`。

在 pubspec.yaml 文件中声明 assets：

```
assets:
 - my-assets/data.json
```

然后在代码中使用 [`AssetBundle`](https://docs.flutter.io/flutter/services/AssetBundle-class.html)来访问它：

```
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString('my-assets/data.json');
}
```

图片资源：Flutter遵循像iOS这样简单的3种分辨率格式: 1x, 2x, and 3x。

举个例子，要把一个叫 my_icon.png 的图片放到 Flutter 工程中，你可能想要把存储它的文件夹叫做 images。把基础图片（1.0x）放置到 images 文件夹中，并把其他变体放置在子文件夹中，并接上合适的比例系数：

```
images/my_icon.png       // Base: 1.0x image
images/2.0x/my_icon.png  // 2.0x image
images/3.0x/my_icon.png  // 3.0x image
```

接着，在 pubspec.yaml 文件夹中声明这些图片：

```
assets:
 - images/my_icon.jpeg
```

你可以用 AssetImage 来访问这些图片：

```
return AssetImage("images/a_dot_burr.jpeg");
```

或者在 Image widget 中直接使用：

```
@override
Widget build(BuildContext context) {
  return Image.asset("images/my_image.png");
}
```



## 横屏、竖屏？

# 国际化



# 动态化

在 Android 端实现了动态化支持，可以线上热更新业务。iOS 端暂不支持动态化。



# 框架设计

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaiceSaDEob5Iia1Tj9R7JeVv9MzluBwLjHVNEnXdvarLF3ZSRS7G2NoBtg/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

## 基础框架

提供组件管理，状态管理，异常监控，开发调试，flutter和原生混合开发等基础功能。

分为三层架构，包含 JDFlutter 基础层，通用业务层，业务层。

- **基础层：**提供了 Flutter 的基础组件支持，包括组件管理，状态管理等；基础层完全独立，对业务没有依赖。
- **通用业务层：**提供了通用型业务组件支持，例如登录组件，支付组件等；通用业务层依赖于基础层。
- **业务层：**即具体业务逻辑实现层，根据业务需要进行不同组件的组合，实现业务页面的快速开发。

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaicRyrFmLiaWhlLU83RGGPafoib0gfhfNNmWQSYlWibcfP4Jy68SPNBQxF5A/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

## 组件

- **组件管理：**组件之间通过标准的协议接口进行通信，降低组件耦合，便于维护及组件升级；
- **状态管理：**实现数据和界面分离，统一状态管理，以数据的变化来驱动界面的改变，更有利于数据的持久化和保存，同时也有利于 UI 组件的复用；
- **Hybrid Router：**主要解决 Flutter 和 Native 之间交叉跳转的问题，减少内存开销，共享同一个 Flutter Engine。

## 工具

- **编译发布：**优化 Flutter 原有的编译逻辑，管理依赖 Flutter 原生依赖关联，打包 Flutter 和原生代码，实现自动化构建发布。
- **资源管理：**管理图片资源，将资源转换成 Flutter 类，便于资源的读取操作，类似 Andorid 的 R 类；
- **模版代码生成：**减少 Flutter 的代码编写，自动生成 Flutter 组件的框架模板代码，提升代码编写效率；
- **JSON 转换：**将 JSON 数据转换成 Flutter code，并提供 json 转 Flutter 对象的 API，减少动手编写 Flutter code 及解析。

业务研发团队提供了全流程的开发解决方案：

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaicCnwN0gWb62DnbvPnjIfX1jCLCicTwibBAM70fz6cR4KTNvJvcsiarSqPw/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)



# 性能优化

## 图片

1：内存问题 --- 连续push flutter界面内存累积

2：安装包问题 --- 过渡时期两份重复资源文件。

3：寻址缓存问题 --- 原有的寻址缓存策略无法复用。

4：图片复用问题 --- Native和Flutter重复下载相同图片。







1、图片的问题。与native复用

2、动态化：https://www.jianshu.com/p/e392533a157a

3、屏幕适配：分辨率、横竖屏


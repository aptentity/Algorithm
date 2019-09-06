Flutter 和原生混合开发有两种情况，其一，开发 Flutter 业务的同学，需要和原生做交互，因此需要有 Flutter 和原生的混合编译环境；其二，使用原生 SDK 开发业务的同学，需要和 Flutter 业务一起集成打包，此时需对 Flutter 透明，以减少对 Flutter 编译环境的依赖，并且，只依赖原生编译环境即可，此时我们将 Flutter 编译成 aar 依赖，放入原生项目中即可。接下来，我们将重点介绍 Android 和 iOS 的混合编译环境配置。

# Android 平台配置

创建一个 flutter module

```
 flutter create -t module --org com.example my_flutter
```

在原生根项目的 settings.gradle 加入如下配置信息

```
// MyApp/settings.gradle
include ':app'                        // assumed existing content
setBinding(new Binding([gradle: this]))              // new
evaluate(new File(                                   // new
settingsDir.parentFile,                              // new
  'my_flutter/.android/include_flutter.groovy'       // new
))
```

在原生 App 模块中加入 flutter 依赖

```
dependencies {
  implementation project(':flutter')
}
```

这样就可以原生项目一起编译了。

具体可以参照官方文档: https://github.com/flutter/flutter/wiki/Add-Flutter-to-existing-apps

这样的方式虽可以满足混编需求，但还不是特别方便，开发完项目后，还需要去 Android Studio 项目中进行编译，比较麻烦，所以我们也可以把 Flutter 项目 settings.gradle 改造，在 Flutter 开发环境下直接运行包含原生代码的混合项目，改造方式如下：

```
// MyApp/settings.gradle
//projectName 原生模块名称
//projectPath 原生项目路径
include ":$projectName"
project(":$projectName").projectDir = new File("$projectPath")
```

这样改造之后即可在 Flutter IDE 中直接编译 Flutter 混合工程，并进行调试，也可以运行 futter run 来启动 Flutter 混合工程，不过在配置的时候，需要注意 Flutter 中 gradle 编译环境和原生编译环境的一致性，如果不一致可能会导致编译错误。

# iOS 平台配置

创建 flutter module

```
flutter create -t module my_flutter
```

进入 iOS 工程目录，初始化 pod 环境（如果项目工程已经使用 Cocoapods，跳过此步骤）

```
pod init
```

编辑 Podfile 文件

```
## 在 Podfile 文件添加的新代码
flutter_application_path = '/{flutter module 目录}/my_flutter'
eval(File.read(File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')), binding)
```

安装 pod

```
pod install
```

打开工程 (***.xcworkspace) 配置 build phase，为编译 Dart 代码添加编译选项

打开 iOS 项目，选中项目的 Build Phases 选项，点击左上角 + 号按钮，选择 New Run Script Phase，将下面的 shell 脚本添加到输入框中：

"$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" build"$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" embed

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaictB4IicOcUlgg93wdAZBDrLNKLldVliceWmZlKibic9SSEA1W6JSuk01cJw/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

# Flutter 业务的开发与调试

在 Flutter IDE 中编译代码调试会很方便，直接点击 debug 按钮即可进行代码调试，如果是混合工程在 Android studio 或者 xcode 中运行的工程，则没办法这么做，但也可以实现调试：

将要调试的 App 安装到手机中（安装 debug 版本），连接电脑，执行如下命令，同步 Flutter 代码到设备的宿主 App 中

```
$ cd flutterProjectPath/
$ flutter attach
```

执行完命令后会进行等待设备连接状态，然后打开宿主 App，进入 Flutter 页面，看到如下信息提示则表示同步成功。

```
zbdeMacBook-Pro:example zb$ flutter attach
Waiting for a connection from Flutter on MI 5X...
Done.
Syncing files to device MI 5X...                             1.2s

🔥  To hot reload changes while running, press "r". To hot restart (and rebuild state), press "R".
An Observatory debugger and profiler on MI 5X is available at: http://127.0.0.1:54422/
For a more detailed help message, press "h". To detach, press "d"; to quit, press "q".
```

打开 http://127.0.0.1:54422 可以查看调试信息，如有代码改动可以按 r 来实时同步界面，如果改动没有实时生效可以按 R 重新启动 Flutter 应用。


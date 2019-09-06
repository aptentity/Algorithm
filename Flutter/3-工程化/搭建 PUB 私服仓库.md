Flutter 开发中使用的组件，一般公司内部会采用共享的方式，以避免重复开发，而 Flutter 组件共享，即需要使用 pub 仓库。由于公司内部的业务组件不适合上传到 pub 官方仓库，因此，需要搭建私服仓库，以解决各个业务研发团队，对 Flutter 组件共享需要。

感兴趣的同学可以研究下官方 pub 仓库的源码: https://pub.dartlang.org/，其对 Google Cloud 环境有很大的依赖 ， 也可以基于 https://github.com/kahnsen/pub_server 来搭建一个简易版本的私服仓库，以满足上传和下载功能，pub 协议相对比较简单，我们可以在源码增加协议接口来实现更多功能。

运行 pub_server

```
~ $ git clone https://github.com/dart-lang/pub_server.git
~ $ cd pub_server
~/pub_server $ pub get
...

~/pub_server $ dart example/example.dart -d /tmp/package-db
Listening on http://localhost:8080

To make the pub client use this repository configure your shell via:

    $ export PUB_HOSTED_URL=http://localhost:8080
```

发布一个 Flutter 组件需要修改 pubspec.yaml，增加以下内容：

```
name: hello_plugin //plugin 名称
description: A new Flutter plugin. // 介绍
version: 0.0.1// 版本号
author: xxx <xxx@xxx.com>// 作者和邮箱
homepage: https://localhost:8080 // 组件的介绍页面
publish_to: http://localhost:8080// 仓库上传地址
```

上传时可以使用如下命令检查代码错误，并显示出上传的目录结构

```
pub publish --dry-run
```

如果有不想上传的文件，可以在根目录增加一个.gitignore 文件来忽略如下：

```
/build
```

Flutter 组件的依赖配置，在项目的 pubspec.yaml 中 dependencies: 下增加如下信息

```
dependencies:
hello_plugin:
  hosted:
    name: hello_plugin
    url: http://localhost:8080
    version: 0.0.2
```

这样可以在公司内部实现 Flutter 组件共享，如果不想搭建自己的 pub 仓库，也可以采用 git 依赖，配置如下

```
dependencies:
  hello_plugin:
    git:
      url: git://github.com/hello_plugin.git //git 地址
      ref: dev-branch // 分支
```
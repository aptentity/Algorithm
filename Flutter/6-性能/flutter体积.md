# Flutter瘦身大作战

## **背景**

闲鱼技术团队于2018年上半年率先引入了Flutter技术实现客户端开发，到目前为止成功改造并上线了复杂的商品详情和发布业务。随着改造业务的增多，安装包体积急剧上增。安装包体积决定了用户等待下载的时间和可能会耗费的流量，如何控制安装包体积，减小flutter产物的大小成为当务之急。本文从闲鱼客户端项目实践角度给出了一些通用的包大小检测以及优化方案，希望为对Flutter感兴趣的团队提供参考。

闲鱼客户端采用的Flutter和Native混合开发的模式，下面我们以ios端为例分析项目中flutter产物的大小（ipa包瘦身需求更为急切）。

ios工程对Flutter有如下依赖：

- Flutter.framework : Flutter库和引擎
- App.framework: dart业务源码相关文件
- Flutter Plugin：编译出来的各种plugin的framework
- flutter_assets：Flutter依赖的静态资源，如字体，图片等

第一次引入flutter版本改造详情页后，ipa包大小增加近20M，其中包括flutter引擎代码+被改造业务代码，继续发布页flutter改造后，ipa增加4M+。进一步分析解压ipa文件后发现Flutter.framework稳定保持在20M+的大小, 增加新的flutter业务——发布页之后，App.framework增幅近10M!

Flutter.framework是Flutter库和引擎的代码，我们能做的优化空间有限，先把目标放在dart业务相关的文件App.framework上。

## **Flutter产物大小分析**

执行如下命令编译出一个release模式下的App.framework，并使用print-snapshot-sizes参数打印出产物具体大小

```
flutter build aot --release --extra-gen-snapshot-options=--print-snapshot-sizes
```

结果如下：

![img](https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=3914253335,945810180&fm=173&app=49&f=JPEG?w=640&h=157&s=E2B013C34FA4BF600CC95C870000A0C1)

Instructions：代表AOT编译后生成的二进制代码大小

ReadOnlyData：代表生成二进制代码的元数据（例如PcDescriptor， StackMap，CodeSourceMap等）和字符串大小

VMIsolate/Isolate：代表剩下的对象的大小总和（例如代码中定义的常量和虚拟机特定元数据）

具体到业务层，想要分析各个业务模块所占用的大小该怎么办呢？

1、执行如下命令编译出一个arm64架构的App.framework,并将它的包组成结构放到指定目录build/aot.json文件中

```
flutter --suppress-analytics build aot --output-dir=build/aot --target-platform=ios --target=lib/main.dart --release --ios-arch=arm64 --extra-gen-snapshot-options="--dwarf_stack_traces,--print-snapshot-sizes,--print_instructions_sizes_to=build/aot.json"
```

2、使用dart命令将上一步生成的aot.json文件转化成结构可视化的网页

```
dart ./bin/run_binary_size_analysis.dart  build/aot.json path_to_webpage_dir
```

rn_binary_size_analysis.dart是dart提供的一个分析工具，在flutter引擎源码中路径如下:(https://github.com/dart-lang/sdk)

![img](https://oscimg.oschina.net/oscnet/1b6bbc80ea282f0d6058ba79317b6d12cfe.jpg)



1、打开生成文件夹中的index.html即可分析具体业务所占用的大小，右上角的Large Symbols和Large Files按钮可以直接定位体积占比从大到小的方法/文件。

![img](https://oscimg.oschina.net/oscnet/9f0212ce05bb483269e3d8921589fc5d066.jpg)

![img](https://oscimg.oschina.net/oscnet/f0048153f27c7b5d84c32a8532c7646878e.jpg)

举个例子，上面的分析显示PItemInfoInternal.fromJson方法占用了大量体积，跟踪发现这个方法主要的操作是将Map数据转化成对象

![img](https://oscimg.oschina.net/oscnet/850cee7093917b842e330e0478725dc7e9d.jpg)

由此我们可以推断这种类型转换的操作会导致编译生成一些体积很大的代码。



## **优化措施**

1、减少显示类型转换操作

按照上述分析发现显示的类型转换 as String/Bool/Int 这类操作会导致App.framework体积显著增加，主要是它会增加类型检查以及抛出异常的处理逻辑:

```
if (x.classId < A && x.classId > B) throw "x is not subtype of String";
```

通过提取静态公用方法的方式可以成功减少400k+体积。

2、通过编译参数 --dwarf_stack_trace和--obfuscate减小生成代码的体积dwarf_stack_trace表示在生成的动态库文件中，不使用堆栈跟踪符号

obfuscate表示混淆，通过减少变量名/方法名的方式减小代码体积 

```
//编译release包并打印size
flutter build aot --release --extra-gen-snapshot-options=--print-snapshot-sizes
//--dwarf_stack_traces， -->减少6.2%大小
flutter build aot --release --extra-gen-snapshot-options="--dwarf_stack_traces,--print-snapshot-sizes"
//--obsfuscation， -->减少2.5%大小
flutter build aot --release --extra-gen-snapshot-options="--dwarf_stack_traces,--print-snapshot-sizes,--obfuscate"//总大小减少8.7%
```

3、通过修改ios打包脚本xcode_backend.sh，删除dSYM符号表信息文件，App.framework成功减小20%的大小。dSYM 是保存 16 进制函数地址映射信息的中转文件，包含我们调试的 symbols，用来分析 crash report 文件，解析出正确的错误函数信息。

使用xcrun命令将dSYM从framework中剥离出来，可以大大减小App.framework的体积。

```
RunCommand xcrun dsymutil -o "${build_dir}/aot/App.dSYM" "${app_framework}/App"
RunCommand xcrun strip -x -S "${derived_dir}/App.framework/App"
```

4、减少flutter和native资源重复造成的体积增大

利用桥接的方式，flutter直接使用Platform端资源文件，避免因为资源文件重复导致的包大小增加问题。

主要方式是通过BasicMessageChannel在Flutter和Platform端传递信息。Flutter端将资源名AssetName传递给Platform端，Platform端接收到AssetName后，根据name定位到资源文件，并将该文件以二进制数据格式，通过BasicMessageChannel传递回Flutter端。



![img](https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=2339993167,340984366&fm=173&app=49&f=JPEG?w=600&h=304&s=E170A472B6FA5F8828D78DDD0200C0B9)





## **总结**

引入Flutter带来的安装包体积问题会给很多技术团队带来困扰。通过以上措施，Flutter产物App.framework的大小减少30%+，闲鱼技术团队后续也会考虑采取下载并懒加载等方式减少资源占用的体积；继续代码生成中的各种对比，排查避免较大产物的写法，同时也会和Google一起进一步寻找优化空间。



集成flutter模块后如何给app瘦身：https://www.jianshu.com/p/b16ff23363c0

Flutter 体积压缩：https://blog.csdn.net/u010479969/article/details/90899738

Flutter Android/iOS包大小分析：https://juejin.im/post/5c0dd22ce51d455fc5426bb2

关于Flutter iOS安装包大小的解读：https://juejin.im/post/5b2c72ad51882574b629fb2f

https://github.com/dart-lang/sdk
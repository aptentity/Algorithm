# Android

Flutter 页面显示到 Android 端，实际就是用的 FlutterView 填充到 Activity或者 Fragment上的。

public static FlutterView createView(@NonNull final Activity activity, @NonNull final Lifecycle lifecycle, final String initialRoute) {
    FlutterMain.startInitialization(activity.getApplicationContext());
    FlutterMain.ensureInitializationComplete(activity.getApplicationContext(), null);
    final FlutterNativeView nativeView = new FlutterNativeView(activity);
    final FlutterView flutterView = new FlutterView(activity, null, nativeView);
    ......
    return flutterView;
  }

FlutterMain.startInitialization 主要做了初始化配置信息、初始化AOT编译和初始化资源，最后一部分则是加载Flutter的Native环境。跟热修复相关的主要是第三步，初始化资源 initResources()

public class FlutterMain {
   ......
   private static final String SHARED_ASSET_DIR = "flutter_shared";
   private static final String SHARED_ASSET_ICU_DATA = "icudtl.dat";
   private static String sAotVmSnapshotData = "vm_snapshot_data";
   private static String sAotVmSnapshotInstr = "vm_snapshot_instr";
   private static String sAotIsolateSnapshotData = "isolate_snapshot_data";
   private static String sAotIsolateSnapshotInstr = "isolate_snapshot_instr";
   private static String sFlutterAssetsDir = "flutter_assets";
   public static void startInitialization(Context applicationContext, FlutterMain.Settings settings) {
       ......
       // 初始化配置信息
       initConfig(applicationContext);
       // 初始化AOT编译
       initAot(applicationContext);
       // 初始化资源
       initResources(applicationContext);
       // 加载Flutter的Native环境
       System.loadLibrary("flutter");
       ......
   }
   private static void initResources(Context applicationContext) {
       ......
       sResourceExtractor = new ResourceExtractor(applicationContext);
       String icuAssetPath = "flutter_shared" + File.separator + "icudtl.dat";
       sResourceExtractor.addResource(icuAssetPath);
       sIcuDataPath = PathUtils.getDataDirectory(applicationContext) + File.separator + icuAssetPath;
       sResourceExtractor.addResource(fromFlutterAssets(sFlx)).addResource(fromFlutterAssets(sAotVmSnapshotData)).addResource(fromFlutterAssets(sAotVmSnapshotInstr)).addResource(fromFlutterAssets(sAotIsolateSnapshotData)).addResource(fromFlutterAssets(sAotIsolateSnapshotInstr)).addResource(fromFlutterAssets("kernel_blob.bin"));
       if (sIsPrecompiledAsSharedLibrary) {
           sResourceExtractor.addResource(sAotSharedLibraryPath);
       } else {
           sResourceExtractor.addResource(sAotVmSnapshotData).addResource(sAotVmSnapshotInstr).addResource(sAotIsolateSnapshotData).addResource(sAotIsolateSnapshotInstr);
       }
       sResourceExtractor.start();
   }
}

# 热更新实践

大部分跨端框架，诸如 React Native / Weex / H5 等，基本都能做到随时进行热修复，并随时上线，用于及时修复突发的在线问题，架构非常灵活。Flutter 因其 AOT 的设计，预想会很难达到这种灵活度，但技术上仍具有一定的可行性，正如我们在之前的 Flutter 介绍文章中提到的，按照先有的 API 设计，是可以支持热修复的，但仅限于 Android。官方最新的架构上已经支持了热修复架构，大家可以更新到 1.2.1 版本查看，但是官方的功能还比较弱，无法做到版本控制和回滚的灵活性，所以 JDFlutter 并没有采用。

我们可以首先一起看一下 Google 官方热修复方案的设计原理：

**Flutter1.2.1 版本引入了 Dynamic Patch**

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaic56mqrZ6NsyLvAOwMhCwj6J504ZqO5zK8zMSV639IDqiaTT7qbicSx7lg/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

为了更清楚的了解官方热修复的原理和过程，我们需要首先深入了解 Flutter 的业务包结构和整体运行过程：

## Flutter App 的包结构

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaicMkfsedUJWiaRoiaBGICy9zZxYztQSYAMylMrSicIc76HYPgicMiahfY7Viaw/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

可以看到主体代码集中在 asset 目录中，除此之外还有少量 Android 端的框架 java 代码及 flutter so 引擎库外：

1. icudtl.dat
2. isolate_snapshot_data
3. isolate_snapshot_instr

## Flutter 包的初始化流程

Flutter 页面启动时是如何加载这些代码的呢？那就要从 Flutter 的初始化说起了，在页面启动前需要调用 FlutterMain.startInitialization 来做初始化：

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaicBnhgd8j1cvgjaJLwSszA1Wly8TPzPptDhjOWAONvYDrfkov4gqJAzA/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

可以看到该初始化是要求在主线程完成的，另外主要完成了以下三点：

- 配置了一些环境数据，比如各个核心包的路径，主要是提供给其他一些模块全局调用

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaicfAft3FbHIZx91ibTbxnPQJjicgAKKiaoZFMglg85TsFSGre2YvZgdxp1A/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

- 检查 asset 下 Flutter 包的完整性，主要是上面介绍的一些核心包，一旦缺少核心的一些库，就会直接抛异常。开发过程中我们经常因为配置导致有些文件没有打包进去，然后会直接 crash，就是在这里触发的，具体代码如下：

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaic2bzGZFC2qB4bBokRGACnpccKHBGrVtibkXbrloiaOFvgyYkf2vYDUYWA/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

- 解压部分 asset 下的资源到 data 分区，以下是一些片段的代码，那为什么要解压呢？放在 asset 下也是可以通过 assetManager 读取的。这里 google 应该是从性能角度要求解压的，因为频繁的使用 assetManager 读取 asset 是很容易造成多线程阻塞的，一旦阻塞了将会导致整个 Flutter 业务全部无法渲染，所以需要解压一些核心的资源库，而不是解压了所有的资源 (例如图片就没有解压)

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaickkHL18TxnzNMDz9iawQj7SWCqgB28BvH8bh7qU5TMwqHDY0ryKedJKQ/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaic3TcaXK5quflib3dXkmapoYZKZJGIWw8sDnc4l0CP7ziazk3ooaLtnxwg/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

从代码来看，先增加要解压的核心库的目录，然后启动 task 从 asset 中解压库到 data 分区对应 app 数据下的 app_flutter 目录，以下是解压后的目录结构：

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaic49cxuutJvjSkxbQLAibbEorsQsvCX766aXticLyiaZDYVBPs8gMeXSCmQ/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

其中 res_timestamp 文件用于标记一些时间戳，算法比较固定，根据客户端的安装时间及 app 的 version code 生成，也就是说当用户打开 Flutter 页面后这个值就是固定的，如果有任何修改引擎会默认有变化，删除现有 app_flutter 的包，重新解压

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaiccFI3Mtobu32FVjNjPx1D3ekcFicEGqOXUp2WibXPQ9lz6ujQUkqBOicLQ/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

## 运行原理

上面是对 Flutter 程序加载的分析，最终 Flutter 页面显示是需要呈现在原生组件 Flutter View 中的，这个组件会和底层 Flutter Native View 进行绑定，并最终运行上面说到的 data 分区的 Dart 代码来渲染 UI。如果使用的是 Flutter Activity，则默认 Flutter View 是全屏显示，如需要定制页面，需要自己设计 Activity

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaicVQEJgMNeqdsPhPibbdKTX0dyfL1ibuGb0L3b5BsI4MviaupwddpPe7BLw/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

## 热修复实验

了解了这些，其实热修复方案已经呼之欲出，替换原有解压后的 app_flutter 包，杀进程，然后重新加载 Flutter 页面即可。这里我们可以做个简单的实验：

采用 adb 命令 push 一些修改过的并编译的 dart 代码到 app_flutter 目录：

- 先打开 Flutter 页面，默认会加载 asset 下的包，并解压到 data 分区。

- 修改一个 Flutter 工程，并编译代码，最终在工程目录 my_flutter/.android/Flutter/build/intermediates/flutter/release ，可以看到打包生成的文件。

  ![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaic9J45tZgc923GZr4loG9N4Gjqdj4nQBcI4GdhSApydoFcgcrCdGjrbA/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

- 这么文件目录中只有 flutter_assets 目录和 isolate_snapshot_data 文件是包含业务代码和图片的，其他部分基本不会变化，所以我们这里要替换的目录也就是这两个，大家可以使用 adb push 命令将资源文件 push 到对应的 data 分区来做个实验。

```
adb push my_flutter/.android/Flutter/build/intermediates/flutter/release/isolate_snapshot_data /data/data/app 包名  /app_flutter
```

- 关闭 Flutter 页面，在 Task 中杀掉进程，回来后重新打开 Flutter 页面，就能看到改动的效果，图片资源是存放在 flutter_asset 目录的，将图片放到这个目录，同样能更新图片

上面这个实验，验证了方案基本是可行的，但这里只是简单替换，实际使用中替换还是有很多问题的。那 Google 官方是如何设计的呢？

## Google 热修复设计

Flutter SDK 1.2.1 中，Google 提供了 ResourceUpdater，用来做包的检查和下载解压。升级步骤如下：

- 在页面初始化时，检查固定的下载更新目录有没有业务升级包，从代码来看，必须在 manifest 中打开该功能，设置 DynamicPatching

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaic9rbvzYt1Oam0Q3TC3PrCMzKfLic57kgiaS84h7mDSvo9TT4tudXwMtPw/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

从逻辑上来看，只有在页面 onResume 或者 App 重新开启的时候会下载升级包，整体下载是通过 http 请求完成的，整体实现代码大家可以参考 ResourceUpdater 中 DownloadTask 的实现部分，这里就不细说了。

- 每次 init 的时候都会触发检查 data 分区的 app_flutter 包，如果不存在就会从 aaset 目录解压出来，而升级包的替换就是在这步完成的，按照逻辑会优先检查升级目录有没有包存在，如果存在则优先从升级目录解压，如果不存在还是从 asset 目录解压；

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaiccGphoEIhomdRV3qiashtgT27lcdZcKC1Z9BZRghLRgtib16MiaiaUgM3Lg/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

- 当然在检查到有升级包时，会对升级包的一些配置做校验，主要是 manifest.json 文件，里面会包含 buildNumber/baselineChecksum 字段，同时也会对"isolate_snapshot_data", "isolate_snapshot_instr", "flutter_assets/isolate_snapshot_data"等文件做 CRC32 校验

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaicpGdNdkMdO3fsg6FpZtq6DcwfSne9dP5LHmNY3e86cmdKkPppnEOniaA/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

- 升级后的版本时间戳是从配置的 manifest.json 文件中读取 patchNumber 和文件下载时间确定的，完成文件覆盖后会重新生成。

以下是升级包的大概路径如下

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaicS2XgC1vkFNTUUibcN9VN6R1NVeFHLoUSMMoUhPXqjflMXQZ82qaT2lA/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

如何配置服务器

文章上部分介绍了怎么打开升级 patch 的功能，因升级涉及到服务端，那 Google 是怎么做到关联到服务器的呢？其实原理比较简单，需要配置客户端的 manifest 文件的 meta 属性，增加 PatchServerURL，也就是我们服务的地址，以及下载模式 PatchDownloadMode 和加载模式 PatchInstallMode，默认是 ON_NEXT_RESTART（下次初始化时）

整体流程

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaicmR3F9r5fOuGXI5SSUw4ECibXvkMNgQAAzALVT3iaRSxichluwYBzP87JA/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

![img](https://mmbiz.qpic.cn/mmbiz_png/XIibZ0YbvibkVnVdL8BzoLuSZsvtUuTdiaic2Owuib5ZsHMu8UmFM3mUtY3icNpHC1jrwQbQnjZTIsNwgR8FEpkHWFyA/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

存在的缺陷

- 过于定制化，全部在引擎完成，很难适配一些特殊的需求定制；
- 不支持现在比较主流的升级流程，诸如灰度和白名单等功能；
- 版本号的维度不好控制，同时不能做版本回滚等操作。

## JDFlutter 如何实现热修复

JDFlutter 的整体实现原理，其实和 Google 是一样的，目前来看不修改引擎的前提下，只有这种方案最简单，但是我们没有使用 Google 的这套升级架构，默认关闭了 patch 功能，并框架之外实现了替换包和加载的逻辑，优点是整体兼容性更强、更灵活。

1. 服务端根据客户端的唯一标识支持了白名单和灰度下发升级包；
2. 优化下载和替换流程。Flutter 的升级包一般有 4-5M，而且从网络端获取，失败率较高，替换过程又涉及到文件操作，操作不当容易产生 UI 阻塞或者包异常。接入 JDFlutter 的客户端下载包后，并不会直接替换文件，而是修改名称后解压到 app_flutter 目录，等待业务页面重新打开或者重新初始化时再修改成 Flutter 标准名称的文件。这种操作不存在性能问题，另外会把旧版的文件备份，以便回滚代码；
3. 同时并发运行的 Flutter 页面较多，需避免因为升级出现一些中间状态，使得业务或者页面无法打开的情况；
4. 升级失败或者下载后业务包有问题，出现无法加载的情况或者文件丢失的情况可以控制回滚代码；
5. 线上出现大量异常后，可以指定对应的 Flutter 业务执行降级策略，让该业务迅速降级到 H5 页面。

热修复规划

未来，JDFlutter 会继续在热修复方面进行探索和验证，以满足京东业务的快速发展需要。而针对目前的方案，我们思考了如下的优化点：

- Flutter 业务包差量升级：现有的升级模式都是全量包覆盖，即使压缩后升级包还是很大，影响升级成功率及用户流量，后续会采用一些 diff 工具，对比生成差量的 patch，通过服务端下发后，在客户端合并成完整包，但升级次数较多后会导致最终版本碎片化，需要做好版本之前的维护关系，难度较大。
- 升级后及时更新页面：现有方案（包括标准 google 升级方案）没有办法做到下载业务包或者替换业务包后及时刷新页面，需要 restart 进程后重新开启才能刷新页面。未来我们会优化引擎，通过释放底层资源并重新加载，来完成随时刷新页面的功能。


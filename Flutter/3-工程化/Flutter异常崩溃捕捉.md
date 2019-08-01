Java和OC都是多线程模型的编程语言，任意一个线程触发异常且没被捕获时，整个进程就退出了。但Dart和JavaScript不会，它们都是单线程模型，运行机制很相似(但有区别)

看一个Flutter App的运行机制图

![img](https://cdn.jsdelivr.net/gh/flutterchina/flutter-in-action/docs/imgs/both-queues.png)

Dart 是采用单线程的语言，通过消息的循环机制来进行运行，其中包含两个任务队列。

microtask queue  （通常Dart内部事件 可以通过Future.microtask(…)方法向微任务队列插入一个任务）

event  queue   （所有的外部事件任务都在事件队列中，如IO、计时器、点击、以及绘制事件等）

首先 microtask queue 优先级 高于 event queue 

在事件循环中，当某个任务发生异常并没有被捕获时，程序并不会退出，而直接导致的结果是当前任务的后续代码就不会被执行了，也就是说一个任务中的异常是不会影响其它任务执行的。

 Dart中可以通过try/catch/finally来捕获代码块异常，这个和其它编程语言类似

Flutter 框架为我们在很多关键的方法进行了异常捕获。这里举一个例子，当我们布局发生越界或不合规范时，Flutter就会自动弹出一个错误界面，这是因为Flutter已经在执行build方法时添加了异常捕获，最终的源码如下：

```
@override
void performRebuild() {
 ...
  try {
    //执行build方法  
    built = build();
  } catch (e, stack) {
    // 有异常时则弹出错误提示  
    built = ErrorWidget.builder(_debugReportException('building $this', e, stack));
  } 
  ...
}
```

_debugReportException()方法看看：

```
FlutterErrorDetails _debugReportException(
  String context,
  dynamic exception,
  StackTrace stack, {
  InformationCollector informationCollector
}) {
  //构建错误详情对象  
  final FlutterErrorDetails details = FlutterErrorDetails(
    exception: exception,
    stack: stack,
    library: 'widgets library',
    context: context,
    informationCollector: informationCollector,
  );
  //报告错误 
  FlutterError.reportError(details);
  return details;
}
```


我们发现，错误是通过FlutterError.reportError方法上报的，继续跟踪：

```
static void reportError(FlutterErrorDetails details) {
  ...
  if (onError != null)
    onError(details); //调用了onError回调
}
```


我们发现onError是FlutterError的一个静态属性，它有一个默认的处理方法 dumpErrorToConsole，到这里就清晰了，如果我们想自己上报异常，只需要提供一个自定义的错误处理回调即可，如：

```
void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    reportError(details);
  };
 ...
}
```


这样我们就可以处理那些Flutter为我们捕获的异常了，接下来我们看看如何捕获其它异常。

# 其它异常捕获与日志收集

Flutter 中的 异常 分为 同步异常捕捉 和 异步异常捕捉，同步异常捕捉  通过 try/catch/finally即可，异步异常捕捉那么需要

用到 Dart 中的 runZoned(...) 的方法，指定一个代码执行的环境空间，在这里可以捕获所有产生的异常问题。

```
R runZoned<R>(R body(), {
    Map zoneValues, 
    ZoneSpecification zoneSpecification,
    Function onError,
})
```


zoneValues: Zone 的私有数据，可以通过实例zone[key]获取，可以理解为每个“沙箱”的私有数据。

zoneSpecification：Zone的一些配置，可以自定义一些代码行为，比如拦截日志输出行为等

```
runZoned(() {
    runApp(MyApp());
}, onError: (Object obj, StackTrace stack) {
    var details=makeDetails(obj,stack);
    reportError(details);
});
```

开发者提供了onError回调或者通过ZoneSpecification.handleUncaughtError指定了错误处理回调，那么这个zone将会变成一个error-zone，该error-zone中发生未捕获异常(无论同步还是异步)时都会调用开发者提供的回调

开发者提供了onError回调或者通过ZoneSpecification.handleUncaughtError指定了错误处理回调，那么这个zone将会变成一个error-zone，该error-zone中发生未捕获异常(无论同步还是异步)时都会调用开发者提供的回调

 

```
void collectLog(String line){
    ... //收集日志
}
void reportErrorAndLog(FlutterErrorDetails details){
    ... //上报错误和日志逻辑
}

FlutterErrorDetails makeDetails(Object obj, StackTrace stack){
    ...// 构建错误信息
}

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    reportErrorAndLog(details);
  };
  runZoned(
    () => runApp(MyApp()),
    zoneSpecification: ZoneSpecification(
      print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
        collectLog(line); // 收集日志
      },
    ),
    onError: (Object obj, StackTrace stack) {
      var details = makeDetails(obj, stack);
      reportErrorAndLog(details);
    },
  );
}
```

# Flutter异常收集最佳实践

```
Future<Null> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZoned<Future<Null>>(() async {
    runApp(new HomeApp());
  }, onError: (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
```



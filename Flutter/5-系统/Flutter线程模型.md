接触过Flutter的人都知道，Flutter是用Dart来写的，Dart没有进程和线程的概念，所有的Dart代码都是在isolate上运行的，那么isolate到底是什么？

# 0x00 同步代码和异步代码

我们对Dart代码进行分类：同步代码和异步代码； 我们在写Dart代码的时候，就只有两种代码，

- 同步代码：就是一行行写下来的代码
- 异步代码：就是以Future等修饰的代码

这两类代码是不同的：

### 1.运行顺序不同

同步代码和异步代码运行的顺序是不同的：

```
先运行同步代码，在运行异步代码
```

就是，即使我异步代码写在最前面，同步代码写在最后面，不好意思，我也是先运行后面的同步代码，同步代码都运行完后，在运行前面的异步代码。

### 2.运行的机制不同

异步代码是运行在`event loop`里的，这是一个很重要的概念，这里可以理解成Android里的Looper机制，是一个死循环，`event loop`不断的从事件队列里取事件然后运行。

# 0x01 event loop 架构

下面是event loop大致的运行图：

![img](https://user-gold-cdn.xitu.io/2019/1/8/168297301229dbb9?imageView2/0/w/1280/h/960/ignore-error/1)

这个很好理解，事件events加到Event queue里，Event loop循环从Event queue里取Event执行。

这个理解后，在看event loop详细的运行图：

![img](https://user-gold-cdn.xitu.io/2019/1/8/1682974dd5b630bf?imageView2/0/w/1280/h/960/ignore-error/1)



从这里看到，启动app（start app）后：

1. 先查看MicroTask queue是不是空的，不是的话，先运行microtask
2. 一个microtask运行完后，会看有没有下一个microtask，直到Microtask queue空了之后，才会去运行Event queue 3.在Evnet queue取出一个event task运行完后，又会跑到第一步，去运行microtask

这里多了两个名词：`MicroTask`和`Event`，这代表了两个不同的异步task

而且可以看出：

- 如果想让任务能够尽快执行，就用`MicroTask`

### 1. MicroTask

这个大家应该不太清楚，但是这个也是`dart:async`提供的异步方法，使用方式：

```
// Adds a task to the 先查看MicroTask queue.
scheduleMicrotask((){
  // ...code goes here...
}); 
```

或者：

```
new Future.microtask((){
    // ...code goes here...
});
```

### 2.Event

Event我们就很清楚了，就是Future修饰的异步方法，使用方式：

```
// Adds a task to the Event queue.
new Future(() {
  // ...code goes here...
});
复制代码
```

# 0x02 实例

纯粹讲理论知识不太好理解，我们直接上代码，讲一个例子，看如下的代码，请问打印顺序是什么样的？

```
import 'dart:async';
void main() {
  print('main #1 of 2');
  scheduleMicrotask(() => print('microtask #1 of 3'));

  new Future.delayed(new Duration(seconds:1),
      () => print('future #1 (delayed)'));

  new Future(() => print('future #2 of 4'))
      .then((_) => print('future #2a'))
      .then((_) {
        print('future #2b');
        scheduleMicrotask(() => print('microtask #0 (from future #2b)'));
      })
      .then((_) => print('future #2c'));

  scheduleMicrotask(() => print('microtask #2 of 3'));

  new Future(() => print('future #3 of 4'))
      .then((_) => new Future(
                   () => print('future #3a (a new future)')))
      .then((_) => print('future #3b'));

  new Future(() => print('future #4 of 4'))
  .then((_){
    new Future(() => print('future #4a'));
  })
  .then((_) => print('future #4b'));
  scheduleMicrotask(() => print('microtask #3 of 3'));
  print('main #2 of 2');
}
复制代码
```

1. 首先运行同步代码

   所以是:

   ```
   main #1 of 2
   main #2 of 2
   复制代码
   ```

2. 接下来是异步代码

   Dart的Event Loop是先判断 `microtask queue`里有没有task，有的话运行`microtask`，`microtask`运行完后，在运行`event queue`里的`event task`,一个`event task`运行完后，再去运行 `microtask queue`，然后在运行`event queue`。

3. microtask queue

   这里就是：

   ```
   microtask #1 of 3
   microtask #2 of 3
   ```

4. event queue event queue还有有特殊的情况需要考虑：

   - Future.delayed

     需要延迟执行的，Dart是怎么执行的呢，是在延迟时间到了之后才将此task加到`event queue`的队尾，所以万一前面有很耗时的任务，那么你的延迟task不一定能准时运行

   - Future.then

     Future.then里的task是不会加入到`event queue`里的，而是当前面的Future执行完后立即掉起，所以你如果想保证异步task的执行顺序一定要用then，否则Dart不保证task的执行顺序

   - scheduleMicrotask

   一个`event task`运行完后，会先去查看`Micro queue`里有没有可以执行的`micro task`。没有的话，在执行下一个`event task`

   ```
   这里就是：
   ​```
   future #2 of 4
   future #2a
   future #2b
   future #2c
   microtask #0 (from future #2b)
   future #3 of 4
   future #4 of 4
   future #4b
   future #3a (a new future)
   future #3b
   future #4a
   future #1 (delayed)
   ​```
   ```

这里你肯定好奇为啥`future #3 of 4`后面是`future #4 of 4`，而不是`future #3a (a new future)`，因为 `future #3 of 4`的then里又新建了一个Future:`future #3a (a new future)`，所以`future #3a (a new future)`这个task会加到`event queue`的最后面。

最后的结果就是：

```
main #1 of 2
main #2 of 2
microtask #1 of 3
microtask #2 of 3
microtask #3 of 3
future #2 of 4
future #2a
future #2b
future #2c
microtask #0 (from future #2b)
future #3 of 4
future #4 of 4
future #4b
future #3a (a new future)
future #3b
future #4a
future #1 (delayed)
```



Flutter的代码都是默认跑在root isolate上的,那么Flutter中能不能自己创建一个isolate呢？当然可以！，接下来我们就自己创建一个isolate！

# 0x03 dart:isolate

有关isolate的代码，都在`isolate.dart`文件中，里面有一个生成isolate的方法：

```
  external static Future<Isolate> spawn<T>(
      void entryPoint(T message), T message,
      {bool paused: false,
      bool errorsAreFatal,
      SendPort onExit,
      SendPort onError});
```

`spawn`方法，必传参数有两个，函数entryPoint和参数message,其中

1. 函数

   函数必须是顶级函数或静态方法

2. 参数

   参数里必须包含`SendPort`

# 0x04 isolate实例

创建的步骤，写在代码的注释里

```
import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//一个普普通通的Flutter应用的入口
//main函数这里有async关键字，是因为创建的isolate是异步的
void main() async{
  runApp(MyApp());
  
  //asyncFibonacci函数里会创建一个isolate，并返回运行结果
  print(await asyncFibonacci(20));
}

//这里以计算斐波那契数列为例，返回的值是Future，因为是异步的
Future<dynamic> asyncFibonacci(int n) async{
  //首先创建一个ReceivePort，为什么要创建这个？
  //因为创建isolate所需的参数，必须要有SendPort，SendPort需要ReceivePort来创建
  final response = new ReceivePort();
  //开始创建isolate,Isolate.spawn函数是isolate.dart里的代码,_isolate是我们自己实现的函数
  //_isolate是创建isolate必须要的参数。
  await Isolate.spawn(_isolate,response.sendPort);
  //获取sendPort来发送数据
  final sendPort = await response.first as SendPort;
  //接收消息的ReceivePort
  final answer = new ReceivePort();
  //发送数据
  sendPort.send([n,answer.sendPort]);
  //获得数据并返回
  return answer.first;
}

//创建isolate必须要的参数
void _isolate(SendPort initialReplyTo){
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听
  port.listen((message){
    //获取数据并解析
    final data = message[0] as int;
    final send = message[1] as SendPort;
    //返回结果
    send.send(syncFibonacci(data));
  });
}

int syncFibonacci(int n){
  return n < 2 ? n : syncFibonacci(n-2) + syncFibonacci(n-1);
}
```

直接运行程序就会在log里看到如下的打印：

```
flutter: 6765
```

# 0x05 isolate有什么用？

说了这么久，为什么要创建自己的isolate？有什么用？

因为Root isolate会负责渲染，还有UI交互，如果我们有一个很耗时的操作呢？前面知道isolate里是一个event loop（事件循环），如果一个很耗时的task一直在运行，那么后面的UI操作都被阻塞了，所以如果我们有耗时的操作，就应该放在isolate里！

# 0x06 Flutter的task runners的分类

上面讲了task runners要运行的线程上，这里的task runners有四种，而且都是运行在不同的线程上（可以运行在同一个线程上，但是出于性能的因素，不建议这么做）。

task runners分为四种：

1. Platform Task Runner
2. UI Task Runner
3. GPU Task Runner
4. IO Task Runner

#### 1. Platform Task Runner

- Platform Task Runner运行所在的线程 对应 平台的线程

  | Android | iOS    |
  | ------- | ------ |
  | 主线程  | 主线程 |

- 功能 嵌入层和Engine层的交互，处理平台（Android/iOS）的消息

- 为什么一定要是平台的主线程？ 因为Platform Task Runner的功能是要处理平台的消息，但是平台的API都是只能在主线程调用，所以Platform Task Runner运行所在的平台的线程必须是主线程

- 一个Flutter Engine对应一个Platform Thread（一个Flutter应用启动的时候会创建一个Engine实例，Engine创建的时候会创建一个Platform线程供Platform Task Runner使用）

- 阻塞Platform Thread不会直接导致Flutter应用的卡顿（跟iOS android主线程不同）。尽管如此，也不建议在这个Runner执行繁重的操作，长时间卡住Platform Thread应用有可能会被系统Watchdog强杀。

#### 2. UI Task Runner

- UI Task Runner运行所在的线程 对应到 平台的线程

  | Android | iOS    |
  | ------- | ------ |
  | 子线程  | 子线程 |

  这里很容易让大家误会，因为一看名字，UI Task Runner，第一反应，UI ? 那肯定是在主线程里的，其实并不是，UI Task Runner运行所在的线程 对应到 平台的线程，其实是子线程

- 功能

  1）用于执行Dart root isolate代码

  2）渲染逻辑，告诉Engine最终的渲染

  3）处理来自Native Plugins的消息

  4）timers

  5）microtasks

  6）异步 I/O 操作(sockets, file handles, 等)

- Root isolate就是运行在这个线程上，所以isolate就可以理解为单线程，有event loop的架构

- 阻塞这个线程会直接导致Flutter应用卡顿掉帧

- 为了防止阻塞这个线程，我们可以创建其他的isolate，创建的isolate没有绑定Flutter的功能，只能做数据运算，不能调用Flutter的功能，而且创建的isolate的生命周期受Root isolate控制，Root isolate停止，其他的isolate也会停止，而且创建的isolate运行的线程，是DartVM里的线程池提供的

#### 3.GPU Task Runner

- GPU Task Runner运行所在的线程 对应到 平台的线程

  | Android | iOS    |
  | ------- | ------ |
  | 子线程  | 子线程 |

- 功能

  GPU Task Runner主要用于执行设备GPU的指令。在UI Task Runner 创建layer tree，在GPU Task Runner将Layer Tree提供的信息转化为平台可执行的GPU指令。

- UI Task Runner和GPU Task Runner跑在不同的线程。GPU Runner会根据目前帧执行的进度去向UI Task Runner要求下一帧的数据，在任务繁重的时候可能会告诉UI Task Runner延迟任务。这种调度机制确保GPU Task Runner不至于过载，同时也避免了UI Task Runner不必要的消耗。

- 在此线程耗时太久的话，会造成Flutter应用卡顿，所以在GPU Task Runner尽量不要做耗时的任务，例如加载图片的时候，去读取图片数据，就不应该放在GPU Task Runner，而是放在接下来要讲的IO Task Runner

- 建议为每一个Engine实例都新建一个专用的GPU Task Runner线程。

#### 4. IO Task Runner

- IO Task Runner运行所在的线程 对应到 平台的线程

  | Android | iOS    |
  | ------- | ------ |
  | 子线程  | 子线程 |

- 功能

  1）主要功能是从图片存储（比如磁盘）中读取压缩的图片格式，将图片数据进行处理为GPU Runner的渲染做好准备。IO Runner首先要读取压缩的图片二进制数据（比如PNG，JPEG），将其解压转换成GPU能够处理的格式然后将数据上传到GPU。 2）加载其他资源文件

- 在IO Task Runner不会阻塞Flutter，虽然在加载图片和资源的时候可能会延迟，但是还是建议为IO Task Runner单独开一个线程。

# 0x07 各个平台的线程配置

#### 1.iOS

为每个引擎实例的UI，GPU和IO任务运行程序创建专用线程。所有引擎实例共享相同的Platform Thread和Platform Task Runner。

#### 2.Android

为每个引擎实例的UI，GPU和IO任务运行程序创建专用线程。所有引擎实例共享相同的Platform Thread和Platform Task Runner。

#### 3.Fuchsia

每一个Engine实例都为UI，GPU，IO，Platform Runner创建各自新的线程。

#### 4.Flutter Tester (used by flutter test)

UI，GPU，IO和Platform任务运行器使用相同的主线程。

# 0x08 使用isolates的方法

使用isolates的方法种：

1. 高级API：Compute函数 (用起来方便)
2. 低级API：ReceivePort

## 0x01 Compute函数

Compute函数对isolate的创建和底层的消息传递进行了封装，使得我们不必关系底层的实现，只需要关注功能实现。

首先我们需要：

1. 一个函数：必须是顶级函数或静态函数
2. 一个参数：这个参数是上面的函数定义入参（函数没有参数的话就没有）

比如，还是计算斐波那契数列：

```
void main() async{
  //调用compute函数，compute函数的参数就是想要在isolate里运行的函数，和这个函数需要的参数
  print( await compute(syncFibonacci, 20));
  runApp(MyApp());
}

int syncFibonacci(int n){
  return n < 2 ? n : syncFibonacci(n-2) + syncFibonacci(n-1);
}
复制代码
```

运行后的结果如下：

```
flutter: 6765
复制代码
```

是不是很简单，接下来看下`compute`函数的源码，这里的代码有点复杂，会把分析的添加到代码的注释里，首先介绍一个`compute`函数里用到的函数别名：

`ComputeCallback<Q, R>`定义如下:

```
// Q R是泛型，ComputeCallback是一个有参数Q，返回值为R的函数
typedef ComputeCallback<Q, R> = R Function(Q message);
复制代码
```

正式看源码：

```
//compute函数 必选参数两个，已经讲过了
Future<R> compute<Q, R>(ComputeCallback<Q, R> callback, Q message, { String debugLabel }) async {
  //如果是在profile模式下,debugLabel为空的话，就取callback.toString()
  profile(() { debugLabel ??= callback.toString(); });
  final Flow flow = Flow.begin();
  Timeline.startSync('$debugLabel: start', flow: flow);
  final ReceivePort resultPort = ReceivePort();
  Timeline.finishSync();
  //创建isolate,这个和前面讲的创建isolate的方法一致
  //还有一个，这里传过去的参数是用_IsolateConfiguration封装的类
  final Isolate isolate = await Isolate.spawn<_IsolateConfiguration<Q, R>>(
    _spawn,
    _IsolateConfiguration<Q, R>(
      callback,
      message,
      resultPort.sendPort,
      debugLabel,
      flow.id,
    ),
    errorsAreFatal: true,
    onExit: resultPort.sendPort,
  );
  final R result = await resultPort.first;
  Timeline.startSync('$debugLabel: end', flow: Flow.end(flow.id));
  resultPort.close();
  isolate.kill();
  Timeline.finishSync();
  return result;
}

@immutable
class _IsolateConfiguration<Q, R> {
  const _IsolateConfiguration(
    this.callback,
    this.message,
    this.resultPort,
    this.debugLabel,
    this.flowId,
  );
  final ComputeCallback<Q, R> callback;
  final Q message;
  final SendPort resultPort;
  final String debugLabel;
  final int flowId;

  R apply() => callback(message);
}

void _spawn<Q, R>(_IsolateConfiguration<Q, R> configuration) {
  R result;
  Timeline.timeSync(
    '${configuration.debugLabel}',
    () {
      result = configuration.apply();
    },
    flow: Flow.step(configuration.flowId),
  );
  Timeline.timeSync(
    '${configuration.debugLabel}: returning result',
    () { configuration.resultPort.send(result); },
    flow: Flow.step(configuration.flowId),
  );
}

复制代码
```

## 0x03 ReceivePort

```
import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//一个普普通通的Flutter应用的入口
//main函数这里有async关键字，是因为创建的isolate是异步的
void main() async{
  runApp(MyApp());
  
  //asyncFibonacci函数里会创建一个isolate，并返回运行结果
  print(await asyncFibonacci(20));
}

//这里以计算斐波那契数列为例，返回的值是Future，因为是异步的
Future<dynamic> asyncFibonacci(int n) async{
  //首先创建一个ReceivePort，为什么要创建这个？
  //因为创建isolate所需的参数，必须要有SendPort，SendPort需要ReceivePort来创建
  final response = new ReceivePort();
  //开始创建isolate,Isolate.spawn函数是isolate.dart里的代码,_isolate是我们自己实现的函数
  //_isolate是创建isolate必须要的参数。
  await Isolate.spawn(_isolate,response.sendPort);
  //获取sendPort来发送数据
  final sendPort = await response.first as SendPort;
  //接收消息的ReceivePort
  final answer = new ReceivePort();
  //发送数据
  sendPort.send([n,answer.sendPort]);
  //获得数据并返回
  return answer.first;
}

//创建isolate必须要的参数
void _isolate(SendPort initialReplyTo){
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听
  port.listen((message){
    //获取数据并解析
    final data = message[0] as int;
    final send = message[1] as SendPort;
    //返回结果
    send.send(syncFibonacci(data));
  });
}

int syncFibonacci(int n){
  return n < 2 ? n : syncFibonacci(n-2) + syncFibonacci(n-1);
}
```











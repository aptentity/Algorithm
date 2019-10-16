# 沿着树的方向，从上向下传递数据、状态

按照Widgets Tree的方向，从上往子树和节点上传递状态。

## InheritedWidget & ValueNotifier

### InheritedWidget

这个既熟悉又陌生类可以帮助我们在Flutter中沿着树向下传递信息。这个类只是简单的保存了一个状态而已。
我们经常通过这样的方式，通过`BuildContext`,可以拿到`Theme`和`MediaQuery`

```
//得到状态栏的高度
var statusBarHeight = MediaQuery.of(context).padding.top;
//复制合并出新的主题
var copyTheme =Theme.of(context).copyWith(primaryColor: Colors.blue);
```

看到`of`的静态方法，第一反应是去通过这个`context`去构建新的类。然后从这个类中，去调用获取状态的方法。(Android开发的同学应该很熟悉的套路，类似Picasso、Glide)。但事实上是这样吗？

#### MediaQuery

##### 通过`context.inheritFromWidgetOfExactType`

```
static MediaQueryData of(BuildContext context, { bool nullOk: false }) {
    assert(context != null);
    assert(nullOk != null);
    final MediaQuery query = context.inheritFromWidgetOfExactType(MediaQuery);
    if (query != null)
      return query.data;
    if (nullOk)
      return null;
    throw new FlutterError(
      'MediaQuery.of() called with a context that does not contain a MediaQuery.\n'
      'No MediaQuery ancestor could be found starting from the context that was passed '
      'to MediaQuery.of(). This can happen because you do not have a WidgetsApp or '
      'MaterialApp widget (those widgets introduce a MediaQuery), or it can happen '
      'if the context you use comes from a widget above those widgets.\n'
      'The context used was:\n'
      '  $context'
    );
  }
```

- 首先，可以看到通过这个方法`context.inheritFromWidgetOfExactType`来查到`MediaQuery`。
  **MediaQuery是我们存在在BuildContext中的属性。**
- 其次，可以看到`MediaQuery`存储在的`BuildContext`中的位置是在`WidgetsApp`.(因为其实`MaterialApp`返回的也是它)

##### MediaQuery状态保存的原理

- **继承InheritedWidget**

  ![img](https://upload-images.jianshu.io/upload_images/1877190-6d4a6814ec0e7cd1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/382)

  

- **通过build方法中返回**

1. `MaterialApp`的`_MaterialAppState`中的`build`方法

   ![img](https://upload-images.jianshu.io/upload_images/1877190-80c0c82d3e98b9e7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/498)

   

2. `WidgetsApp`的`_WidgetsAppState`中的`build`方法

   ![img](https://upload-images.jianshu.io/upload_images/1877190-8d06bf343c88c7d7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/466)

   

- **获取**
  最后就是最上面看到的那段代码，通过`context.inheritFromWidgetOfExactType`来获取。
  然后在子树的任何地方，都可以通过这样的方式来进行获取。

#### 定义一个AppState

了解了`MediaQuery`的存放方式，我们可以实现自己的状态管理，这样在子组件中，就可以同步获取到状态值。

##### 0.先定义一个AppState

```
//0. 定义一个变量来存储
class AppState {
  bool isLoading;

  AppState({this.isLoading = true});

  factory AppState.loading() => AppState(isLoading: true);

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading}';
  }
}
```

##### 1. 继承InheritedWidget

```
//1. 模仿MediaQuery。简单的让这个持有我们想要保存的data
class _InheritedStateContainer extends InheritedWidget {
  final AppState data;

  //我们知道InheritedWidget总是包裹的一层，所以它必有child
  _InheritedStateContainer(
      {Key key, @required this.data, @required Widget child})
      : super(key: key, child: child);

  //参考MediaQuery,这个方法通常都是这样实现的。如果新的值和旧的值不相等，就需要notify
  @override
  bool updateShouldNotify(_InheritedStateContainer oldWidget) =>
      data != oldWidget.data;
}
```

##### 2. 创建外层的Widget

创建外层的`Widget`,并且提供静态方法`of`，来得到我们的`AppState`

```
/*
1. 从MediaQuery模仿的套路，我们知道，我们需要一个StatefulWidget作为外层的组件，
将我们的继承于InheritateWidget的组件build出去
*/
class AppStateContainer extends StatefulWidget {
  //这个state是我们需要的状态
  final AppState state;

  //这个child的是必须的，来显示我们正常的控件
  final Widget child;

  AppStateContainer({this.state, @required this.child});

  //4.模仿MediaQuery,提供一个of方法，来得到我们的State.
  static AppState of(BuildContext context) {
    //这个方法内，调用 context.inheritFromWidgetOfExactType
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  _AppStateContainerState createState() => _AppStateContainerState();
}

class _AppStateContainerState extends State<AppStateContainer> {

  //2. 在build方法内返回我们的InheritedWidget
  //这样App的层级就是 AppStateContainer->_InheritedStateContainer-> real app
  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: widget.state,
      child: widget.child,
    );
  }
}
```

##### 3. 使用

- 包括在最外层

```
class MyInheritedApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //因为是AppState，所以他的范围是全生命周期的，所以可以直接包裹在最外层
    return AppStateContainer(
      //初始化一个loading
      state: AppState.loading(),
      child: new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
```

- 在任何你想要的位置中，使用。
  文档里面推荐，在`didChangeDependencies`中查询它。所以我们也

```
class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState() {}

   AppState appState;
  //在didChangeDependencies方法中，就可以查到对应的state了
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies');
    if(appState==null){
      appState= AppStateContainer.of(context);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Center(
          //根据isLoading来判断，显示一个loading，或者是正常的图
          child: appState.isLoading
              ? CircularProgressIndicator()
              : new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      'appState.isLoading = ${appState.isLoading}',
                    ),
                  ],
                ),
        ),
        floatingActionButton: new Builder(builder: (context) {
          return new FloatingActionButton(
            onPressed: () {
              //点击按钮进行切换
              //因为是全局的状态，在其他页面改变，也会导致这里发生变化
              appState.isLoading = !appState.isLoading;
              //setState触发页面刷新
              setState(() {});
            },
            tooltip: 'Increment',
            child: new Icon(Icons.swap_horiz),
          );
        }));
  }
}
```

##### 运行效果1-当前页面

点击按钮更改状态。

![img](https://upload-images.jianshu.io/upload_images/1877190-c10b1d18d53084b9.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/360)



##### 4. 在另外一个页面修改AppState

因为上面代码是在一个页面内的情况，我们要确定是否全局的状态是保持一致的。所以
让我们再改一下代码，点击push出新的页面，在新页面内改变appState的状态，看看就页面会不会发生变化。
代码修改如下：

```
//修改floatingButton的点击事件
  floatingActionButton: new Builder(builder: (context) {
          return new FloatingActionButton(
            onPressed: () {
              //push出一个先的页面              
              Navigator.of(context).push(
                  new MaterialPageRoute<Null>(builder: (BuildContext context) {
                return MyHomePage(
                    title: 'Second State Change Page');
              }));
            //注释掉原来的代码
//              appState.isLoading = !appState.isLoading;
//              setState(() {});
            },
            tooltip: 'Increment',
            child: new Icon(Icons.swap_horiz),
          );
        })
```

- 新增的`MyHomePage`
  基本上和上面的代码一致。同样让他修改`appState`

```
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _changeState() {
    setState(() {
      state.isLoading = !state.isLoading;
    });
  }

  AppState state;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(state ==null){
      state = AppStateContainer.of(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'appState.isLoading = ${state.isLoading}',
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _changeState,
        tooltip: 'ChangeState',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
```

##### 运行效果2-另外一个页面内修改状态

在push的页面修改AppState的状态，回到初始的页面，看状态是否发生变化。

![img](https://upload-images.jianshu.io/upload_images/1877190-03fb85018d138178.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/360)



#### 小结和思考

通过分析`MediaQuery`，我们了解到了`InheritedWidget`的用法，并且通过自定义的`AppState`等操作熟悉了整体状态控制的流程。
我们可以继续思考下面几个问题

- 为什么`AppState`能在整个App周期中，维持状态呢？
  因为我们将其包裹在了最外层。
  由此思考，每个页面可能也有自己的状态，维护页面的状态，可以将其包裹在页面的层级的最外层，这样它就变成了`PageScope`的状态了。
- 限制-like a EventBus
  当我们改变`state`并关闭页面后，因为`didChangeDependencies`方法和`build`方法的执行，我们打开这个页面时，总能拿到最新的`state`。所以我们的页面能够同步状态成功。
  那如果是像EventBus一样，push出一个状态，我们需要去进行一个耗时操作，然后才能发生的改变我们能监听和处理吗？

### ValueNotifier

继承至`ChangeNotifier`。可以注册监听事件。当值发生改变时，会给监听则发送监听。

```
/// A [ChangeNotifier] that holds a single value.
///
/// When [value] is replaced, this class notifies its listeners.
class ValueNotifier<T> extends ChangeNotifier implements ValueListenable<T> {
  /// Creates a [ChangeNotifier] that wraps this value.
  ValueNotifier(this._value);

  /// The current value stored in this notifier.
  ///
  /// When the value is replaced, this class notifies its listeners.
  @override
  T get value => _value;
  T _value;
  set value(T newValue) {
    if (_value == newValue)
      return;
    _value = newValue;
    notifyListeners();
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}
```

源码看到，只要改变值`value`值，相当于调用`set`方法，都会`notifyListeners`

#### 修改代码

##### AppState添加成员

```
//定义一个变量来存储
class AppState {
 //...忽略重复代码。添加成员变量
  ValueNotifier<bool> canListenLoading = ValueNotifier(false);
}
```

##### _MyHomeInheritedPageState 中添加监听

```
class _MyHomeInheritedPageState extends State<MyInheritedHomePage> {
 //...忽略重复代码。添加成员变量

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies');
    if (appState == null) {
      print('state == null');
      appState = AppStateContainer.of(context);
      //在这里添加监听事件
      appState.canListenLoading.addListener(listener);
    }
  }

  @override
  void dispose() {
    print('dispose');
    if (appState != null) {
      //在这里移除监听事件
      appState.canListenLoading.removeListener(listener);
    }
    super.dispose();
  }

  @override
  void initState() {
    print('initState');
    //初始化监听的回调。回调用作的就是延迟5s后，将result修改成 "From delay"
    listener = () {
      Future.delayed(Duration(seconds: 5)).then((value) {
        result = "From delay";
        setState(() {});
      });
    };
    super.initState();
  }

  //添加成员变量。 result参数和 listener回调
  String result = "";
  VoidCallback listener;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Center(
          child: appState.isLoading
              ? CircularProgressIndicator()
              : new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      'appState.isLoading = ${appState.isLoading}',
                    ),
                    //新增，result的显示在屏幕上
                    new Text(
                      '${result}',
                    ),
                  ],
                ),
        ),
       //...忽略重复代码
  }
}
```

##### 运行结果

运行结果和我们预想的一样。

- 显示打开一个新的页面。

- 在新的页面内改变`canListenLoading`的value。这样会触发上一个页面已经注册的监听事件（4s后改变值）。

- 然后我们退回来，等待后确实发现了数据发生了变化~~

  ![img](https://upload-images.jianshu.io/upload_images/1877190-85b2ad4caaf2b40b.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/360)

这样就感觉可以实现一个类似EventBus的功能了~~

## 总结

这边文章，主要说的是，利用Flutter自身的框架来实现，状态管理和消息传递的内容。

- 通过`InheritedWidget`来保存状态
- 通过`context.inheritFromWidgetOfExactType`来获取属性
- 使用`ValueNotifer`来实现属性监听。

#### 我们可以对状态管理做一个小结

- Key
  保存`Widget`的状态，我们可以通过给对应`Widget`的`key`,来保存状态，并通过Key来拿到状态。
  比如是 `ObjectKey`可以在列表中标记唯一的`Key`，来保存状态，让动画识别。
  `GlobalKey`，则可以保存一个状态，其他地方都可以获取。
- `InheritedWidget`
  可以持有一个状态，共它的子树来获取。
  这样子树本身可以不直接传入这个字段(这样可以避免多级的Widget时，要一层一层向下传递状态)
  还可以做不同`Widget`中间的状态同步
- `ChangeNofier`
  继承这里类，我们就可以实现`Flutter`中的观察者模式，对属性变化做观察。

另外，我们还可以通过`第三方库`，比如说 `Redux`和`ScopeModel``Rx`来做这个事情。但是其基于的原理，应该也是上方的内容。

------

# 从下往上传递分发数据、状态

## Notification

我们知道，我们可以通过`NotificationListener`的方式来监听`ScrollNotification`页面的滚动情况。Flutter中就是通过这样的方式，通过来从子组件往父组件的`BuildContext`中发布数据，完成数据传递的。
下面我们简单的来实现一个我们自己的。

- 代码

```
//0.自定义一个Notification。
class MyNotification extends Notification {}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //2.在Scaffold的层级进行事件的监听。创建`NotificationListener`,并在`onNotification`就可以得到我们的事件了。
    return NotificationListener(
        onNotification: (event) {
          if (event is MyNotification) {
            print("event= Scaffold MyNotification");
          }
        },
        child: new Scaffold(
            appBar: new AppBar(
              title: new Text(widget.title),
            ),
          //3.注意，这里是监听不到事件的。这里需要监听到事件，需要在body自己的`BuildContext`发送事件才行！！！！
            body: new NotificationListener<MyNotification>(
                onNotification: (event) {
                  //接受不到事件，因为`context`不同
                  print("body event=" + event.toString());
                },
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        'appState.isLoading = ',
                      ),
                      new Text(
                        'appState.canListenLoading.value',
                      ),
                    ],
                  ),
                )),
            floatingActionButton: Builder(builder: (context) {
              return FloatingActionButton(
                onPressed: () {
                  //1.创建事件，并通过发送到对应的`BuildContext`中。注意，这里的`context`是`Scaffold`的`BuildContext`
                  new MyNotification().dispatch(context);
                },
                tooltip: 'ChangeState',
                child: new Icon(Icons.add),
              );
            })));
  }
}
```

- 运行结果

  

  ![img](https://upload-images.jianshu.io/upload_images/1877190-e735b2bb6a0f4aba.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/527)

## 小结

我们可以通过Notification的继承类，将其发布到对应的`buildContext`中，来实现数据传递。

------

# 总结

通过这边Flutter数据传递的介绍，我们可以大概搭建自己的Flutter App的数据流结构。
类似闲鱼的界面的架构设计。

![img](https://upload-images.jianshu.io/upload_images/1877190-878238f9160fdac4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/773)

闲鱼flutter的界面框架设计.png

- 从上往下：
  通过自定义不同`Scope`的`InheritedWidget`来hold住不同`Scope`的数据，这样当前Scope下的子组件都能得到对应的数据，和得到对应的更新。
- 从下往上：
  通过自定义的`Notification`类。在子组件中通过`Notification(data).dispatch(context)`这样的方式发布，在对应的`Context`上，在通过`NotificationListener`进行捕获和监听。


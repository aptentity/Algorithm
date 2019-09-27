大部分应用程序都包含多个页面，并希望用户能从当前屏幕平滑过渡到另一个屏幕。移动应用程序通常通过被称为“屏幕”或“页面”的全屏元素来显示内容。在 Flutter 中，这些元素被称为[路由（Route）](https://docs.flutter.io/flutter/widgets/Route-class.html)，它们由[导航器（Navigator）](https://docs.flutter.io/flutter/widgets/Navigator-class.html)控件管理。导航器管理着路由对象的堆栈并提供管理堆栈的方法，如 `Navigator.push`和 `Navigator.pop`，通过路由对象的进出栈来使用户从一个页面跳转到另一个页面。

查看[示例代码](https://github.com/hezhii/flutter_demos/pull/1)。

## 基本用法

**Navigator**的基本用法，从一个页面跳转到另一个页面，通过第二页面上的返回按钮回到第一个页面。

### 创建两个页面

首先创建两个页面，每个页面包含一个按钮。点击第一个页面上的按钮将导航到第二个页面。点击第二个页面上的按钮将返回到第一个页面。初始时显示第一个页面。

```
// main.dart
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Navigation',
      home: new FirstScreen(),
    );
  }
}

// demo1_navigation.dart
class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('First Screen'),
      ),
      body: new Center(
        child: new RaisedButton(
          child: new Text('Launch second screen'),
          onPressed: null,
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Second Screen'),
      ),
      body: new Center(
        child: new RaisedButton(
          child: new Text('Go back!'),
          onPressed: null,
        ),
      ),
    );
  }
}
```

### 跳转到第二页面

为了导航到新的页面，我们需要调用 [Navigator.push](https://docs.flutter.io/flutter/widgets/Navigator/push.html)方法。该方法将添加 Route 到路由栈中！

我们可以直接使用 [MaterialPageRoute](https://docs.flutter.io/flutter/material/MaterialPageRoute-class.html)创建路由，它是一种模态路由，可以通过平台自适应的过渡效果来切换屏幕。默认情况下，当一个模态路由被另一个替换时，上一个路由将保留在内存中，如果想释放所有资源，可以将 `maintainState`设置为 `false`。

给第一个页面上的按钮添加 `onPressed`回调：

```
onPressed: () {
  Navigator.push(
    context,
    new MaterialPageRoute(builder: (context) => new SecondScreen()),
  );
},
```

### 返回第一个页面

`Scaffold`控件会自动在 `AppBar`上添加一个返回按钮，点击该按钮会调用 `Navigator.pop`。

现在希望点击第二个页面中间的按钮也能回到第一个页面，添加回调函数，调用 `Navigator.pop`：

```
onPressed: () {
  Navigator.pop(context);
}
```

## 页面跳转传值

在进行页面切换时，通常还需要将一些数据传递给新页面，或是从新页面返回数据。考虑此场景：我们有一个文章列表页，点击每一项会跳转到对应的内容页。在内容页中，有喜欢和不喜欢两个按钮，点击任意按钮回到列表页并显示结果。

我会接着上面的例子继续编写。

### 定义 Article 类

首先我们创建一个 Article 类，拥有两个属性：标题、内容。

```
class Article {
  String title;
  String content;

  Article({this.title, this.content});
}
```

### 创建列表页面和内容页面

列表页面中初始化 10 篇文章，然后使用 `ListView`显示它们。
内容页面标题显示文章的标题，主体部分显示内容。

```
class ArticleListScreen extends StatelessWidget {
  final List<Article> articles = new List.generate(
    10,
    (i) => new Article(
          title: 'Article $i',
          content: 'Article $i: The quick brown fox jumps over the lazy dog.',
        ),
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Article List'),
      ),
      body: new ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return new ListTile(
            title: new Text(articles[index].title),
          );
        },
      ),
    );
  }
}

class ContentScreen extends StatelessWidget {
  final Article article;

  ContentScreen(this.article);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('${article.title}'),
      ),
      body: new Padding(
        padding: new EdgeInsets.all(15.0),
        child: new Text('${article.content}'),
      ),
    );
  }
}
```

### 跳转到内容页并传递数据

接下来，当用户点击列表中的文章时将跳转到`ContentScreen`，并将 article 传递给 `ContentScreen`。
为了实现这一点，我们将实现 `ListTile`的 [onTap](https://docs.flutter.io/flutter/material/ListTile/onTap.html)回调。 在的 onTap 回调中，再次调用`Navigator.push`方法。

```
return new ListTile(
  title: new Text(articles[index].title),
  onTap: () {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new ContentScreen(articles[index]),
      ),
    );
  },
);
```

### 内容页返回数据

在内容页底部添加两个按钮，点击按钮时跳转会列表页面并传递参数。

```
Widget build(BuildContext context) {
  return new Scaffold(
    appBar: new AppBar(
      title: new Text('${article.title}'),
    ),
    body: new Padding(
      padding: new EdgeInsets.all(15.0),
      child: new Column(
        children: <Widget>[
          new Text('${article.content}'),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new RaisedButton(
                onPressed: () {
                  Navigator.pop(context, 'Like');
                },
                child: new Text('Like'),
              ),
              new RaisedButton(
                onPressed: () {
                  Navigator.pop(context, 'Unlike');
                },
                child: new Text('Unlike'),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
```

修改 `ArticleListScreen`列表项的 `onTap`回调，处理内容页面返回的数据并显示。

```
onTap: () async {
  String result = await Navigator.push(
    context,
    new MaterialPageRoute(
      builder: (context) => new ContentScreen(articles[index]),
    ),
  );

  if (result != null) {
    Scaffold.of(context).showSnackBar(
      new SnackBar(
        content: new Text("$result"),
        duration: const Duration(seconds: 1),
      ),
    );
  }
},
```

## 定制路由

通常，我们可能需要定制路由以实现自定义的过渡效果等。定制路由有两种方式：

- 继承路由子类，如：[PopupRoute](https://docs.flutter.io/flutter/widgets/PopupRoute-class.html)、[ModalRoute](https://docs.flutter.io/flutter/widgets/ModalRoute-class.html)等。
- 使用 [PageRouteBuilder](https://docs.flutter.io/flutter/widgets/PageRouteBuilder-class.html)类通过回调函数定义路由。

下面使用 PageRouteBuilder 实现一个页面旋转淡出的效果。

```
onTap: () async {
  String result = await Navigator.push(
      context,
      new PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1000),
        pageBuilder: (context, _, __) =>
            new ContentScreen(articles[index]),
        transitionsBuilder:
            (_, Animation<double> animation, __, Widget child) =>
                new FadeTransition(
                  opacity: animation,
                  child: new RotationTransition(
                    turns: new Tween<double>(begin: 0.0, end: 1.0)
                        .animate(animation),
                    child: child,
                  ),
                ),
      ));

  if (result != null) {
    Scaffold.of(context).showSnackBar(
      new SnackBar(
        content: new Text("$result"),
        duration: const Duration(seconds: 1),
      ),
    );
  }
},
```

## 命名导航器路由

通常，移动应用管理着大量的路由，并且最容易的是使用名称来引用它们。路由名称通常使用路径结构：“/a/b/c”，主页默认为 “/”。

创建 `MaterialApp`时可以指定 `routes`参数，该参数是一个映射路由名称和构造器的 Map。`MaterialApp`使用此映射为导航器的 [onGenerateRoute](https://docs.flutter.io/flutter/widgets/Navigator/onGenerateRoute.html)回调参数提供路由。

```
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Navigation',
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new ArticleListScreen(),
        '/new': (BuildContext context) => new NewArticle(),
      },
    );
  }
}
```

路由的跳转时调用 `Navigator.pushNamed`：

```
Navigator.of(context).pushNamed('/new');
```

这里有一个问题就是使用 `Navigator.pushNamed`时无法直接给新页面传参数，目前官方还没有标准解决方案，我知道的方案是在 `onGenerateRoute`回调中利用 URL 参数自行处理。

```
onGenerateRoute: (RouteSettings settings) {
  WidgetBuilder builder;
  if (settings.name == '/') {
    builder = (BuildContext context) => new ArticleListScreen();
  } else {
    String param = settings.name.split('/')[2];
    builder = (BuildContext context) => new NewArticle(param);
  }

  return new MaterialPageRoute(builder: builder, settings: settings);
},

// 通过 URL 传递参数
Navigator.of(context).pushNamed('/new/xxx');
```

## 嵌套路由

一个 App 中可以有多个导航器，将一个导航器嵌套在另一个导航器下面可以创建一个内部的路由历史。例如：App 主页有底部导航栏，每个对应一个 Navigator，还有与主页处于同一级的全屏页面，如登录页面等。接下来，我们实现这样一个路由结构。

### 添加 Home 页面

添加 Home 页面，底部导航栏切换主页和我的页面。

```
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    new PlaceholderWidget('Home'),
    new PlaceholderWidget('Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: new BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text('Profile'),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String text;

  PlaceholderWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text(text),
    );
  }
}
```

效果如下：

![img](https://upload-images.jianshu.io/upload_images/9619819-d1d9a0b067f0341c.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/312)

然后我们将 Home 页面组件使用 Navigator 代替，Navigator 中有两个路由页面：home 和 demo1。home 显示一个按钮，点击按钮调转到前面的 demo1 页面。

```
import 'package:flutter/material.dart';

import './demo1_navigation.dart';

class HomeNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Navigator(
      initialRoute: 'home',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'home':
            builder = (BuildContext context) => new HomePage();
            break;
          case 'demo1':
            builder = (BuildContext context) => new ArticleListScreen();
            break;
          default:
            throw new Exception('Invalid route: ${settings.name}');
        }

        return new MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Home'),
      ),
      body: new Center(
        child: new RaisedButton(
          child: new Text('demo1'),
          onPressed: () {
            Navigator.of(context).pushNamed('demo1');
          },
        ),
      ),
    );
  }
}
```

效果如下图：

![img](https://upload-images.jianshu.io/upload_images/9619819-0eaee7c338f254d1.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/312)

可以看到，点击按钮跳转到 demo1 页面后，底部的 tab 栏并没有消失，因为这是在子导航器中进行的跳转。要想显示全屏页面覆盖底栏，我们需要通过根导航器进行跳转，也就是 `MaterialApp`内部的导航器。

我们在 Profile 页面中添加一个登出按钮，点击该按钮会跳转到登录页面。

```
// profile.dart

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Profile'),
      ),
      body: new Center(
        child: new RaisedButton(
          child: new Text('Log Out'),
          onPressed: () {
            Navigator.of(context).pushNamed('/login');
          },
        ),
      ),
    );
  }
}

// main.dart

import './home.dart';
import './login.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demos',
      routes: {
        '/': (BuildContext context) => new Home(),
        '/login': (BuildContext context) => new Login()
      },
    );
  }
}
```

最后效果如下：

![img](https://upload-images.jianshu.io/upload_images/9619819-ab639df201eabbfa.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/312)



至此，Flutter 路由和导航器的内容就总结完毕，接下来，学习 Flutter 中如何进行布局。



```
/// Navigator 继承自 StatefulWidget，它也是小组件，它有很多相关静态函数，可以帮我们达到页面跳转和数据交互的功能：
/// 所有弹出窗口所使用的context不能是顶层Widget的context，同时顶层Widget必须是StatefulWidget。参考：https://www.jianshu.com/p/4c099e8c03c0
//
//push 将设置的router信息推送到Navigator上，实现页面跳转。
//of 主要是获取 Navigator最近实例的好状态。
//pop 导航到新页面，或者返回到上个页面。
//canPop 判断是否可以导航到新页面
//maybePop 可能会导航到新页面
//popAndPushNamed 指定一个路由路径，并导航到新页面。
//popUntil 反复执行pop 直到该函数的参数predicate返回true为止。
//pushAndRemoveUntil 将给定路由推送到Navigator，删除先前的路由，直到该函数的参数predicate返回true为止。
//pushNamed 将命名路由推送到Navigator。
//pushNamedAndRemoveUntil 将命名路由推送到Navigator，删除先前的路由，直到该函数的参数predicate返回true为止。
//pushReplacement 路由替换。
//pushReplacementNamed 这个也是替换路由操作。推送一个命名路由到Navigator，新路由完成动画之后处理上一个路由。
//removeRoute 从Navigator中删除路由，同时执行Route.dispose操作。
//removeRouteBelow 从Navigator中删除路由，同时执行Route.dispose操作，要替换的路由是传入参数anchorRouter里面的路由。
//replace 将Navigator中的路由替换成一个新路由。
//replaceRouteBelow 将Navigator中的路由替换成一个新路由，要替换的路由是是传入参数anchorRouter里面的路由。
```

# 高级用法

## 1.PushAndRemove

假设有这么一个场景：我们在开发一个商城项目，从选择商品到支付完成会经过主页面，商品列表页，商品详情页，支付页面，支付结果页。这时候来了一个需求，当跳转到支付结果页的时候将之前所有的页面都销毁，只留下主页面。如果是android可能会用到singletask或者自己写一个activity管理器之类的，但是这些实现方式都显得不那么优雅直接，而Flutter给出的跳转方案能完美地解决这类问题。

![img](https://img-blog.csdnimg.cn/20190911113205718.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTM4OTQ3MTE=,size_16,color_FFFFFF,t_70)



下面我们来看一下对于这类场景Flutter地解决方案

1.新建4个页面，Screen1，Screen2，Screen3，Screen4
2.在MaterialApp中添加这4个页面的路由
3.使用Navigator.of(context).pushAndRemoveUntil()或者Navigator.of(context).pushNamedAndRemoveUntil()进行跳转

### 1.1 新建页面

```
class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: RaisedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/screen2');
        },
        child: Text(
          'screen1',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
```

其它三个页面的样式和Screen1保持一致，点击按钮跳转到下一个页面

### 1.2 在MaterialApp中添加这4个页面的路由

```
@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    routes: {
      '/screen1': (context) => Screen1(),
      '/screen2': (context) => Screen2(),
      '/screen3': (context) => Screen3(),
      '/screen4': (context) => Screen4(),
    },
    initialRoute: '/screen1',
  );
}
```

### 1.3 进行跳转操作

本例中我们的跳转顺序是Screen1—>Screen2—>Screen3—>Screen4

当从Screen3跳转到Screen4的时候我们希望将Screen2，Screen3从栈里面移除掉，这样在Screen4点击返回就能直接回到Screen1

使用Navigator.pushAndRemoveUtil()或者Navigator.pushNamedAndRemoveUntil()实现，这个方法有两个必传参数newRoute和predicate，第一个参数表示将要加入栈中的页面，第二个参数表示栈中要保留的页面底线，意思就是在predicate和newRoute之间的页面都会被移除栈

```
class Screen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: RaisedButton(
        onPressed: () {
          //跳转到screen4，并且移除所有的页面直到screen1
//          Navigator.of(context).pushNamedAndRemoveUntil(
//              '/screen4', ModalRoute.withName('/screen1'));
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Screen4()),
              ModalRoute.withName('/screen1'));
 
        },
        child: Text(
          'screen3',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
```

![img](https://img-blog.csdnimg.cn/20190911115241687.gif)

## 2.pushReplacement

假设我们在做一个登录功能，在登录成功后需要跳转到一个新的页面并且销毁当前登录页，这时候就可以用pushReplacement来实现，从字面上的意思看push很好理解，把一个新页面压入栈中嘛，replacement到底是替代那个页面呢？答案是当前页，因为被替换的对象是固定的，所以该方法的必传参数只有被push的路由。

```

class Screen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: RaisedButton(
        onPressed: () {
          //打开Screen4页面，并销毁当前页
          Navigator.of(context).pushReplacementNamed('/screen4');
 
          //也可以使用以下方式
         //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Screen3()));
        },
        child: Text(
          'screen3',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
```

![img](https://img-blog.csdnimg.cn/20190911134745612.gif)



## 3.popUntil

这个比较简单，从字面意思上就可以看出是“一直退出直到某一个页面”，来看一下用法吧

```
class Screen4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: RaisedButton(
        onPressed: () {
          //当前在Screen4页面，点击回到Screen1，连带着Screen2，Screen3也一起退出
          Navigator.of(context).popUntil(ModalRoute.withName('/screen1'));
        },
        child: Text(
          'screen4',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
```

![img](https://img-blog.csdnimg.cn/20190911135802181.gif)

## 4.popAndPushNamed

这个方法和pushReplacement很相近，都是开启一个新的页面并且销毁之前的页面，只是在逻辑上的执行顺序不一样，popAndPushNamed是退出当前页面并且将新的页面放到它原来的位置上，所以在视觉效果上是先退出再进入

```
class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: RaisedButton(
        onPressed: () {
          //点击退出当前页面，并将Screen3压入栈中
          Navigator.of(context).popAndPushNamed('/screen3');
        },
        child: Text(
          'screen2',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
```

![img](https://img-blog.csdnimg.cn/20190911140727536.gif)

仔细看动图，Screen2到Screen3的时候是先将Screen2退出再显示Screen3，它不像pushReplacement那样无感知的就把页面给替换了。所以大家根据实际场景选择使用。

备注：以上所有的方法都可以传递相应的参数，涉及到pop的可以加入返回参数，涉及到push的可以添加传递到新页面的参数，这里没有做过多的赘述，大家可以自己尝试一下。

## 5.maybePop和canPop

Navigator.of(context).canPop()返回一个bool值，表示当前页面是否可以退出，那么判断的依据是啥呢？追溯到源码去看

```
/// Whether the navigator can be popped.
  ///
  /// {@macro flutter.widgets.navigator.canPop}
  ///
  /// See also:
  ///
  ///  * [Route.isFirst], which returns true for routes for which [canPop]
  ///    returns false.
  bool canPop() {
    assert(_history.isNotEmpty);
    return _history.length > 1 || _history[0].willHandlePopInternally;
  }
```

尤其是这句话哦： [Route.isFirst], which returns true for routes for which [canPop]，意思说的很明显了，判断依据就是看当前路由是否处在栈中“最底部”的位置。根据之前的例子，如果我们在Screen1调用canPop肯定返回false，因为它处在“最底部”的位置，而在其它页面调用则返回true

Navigator.of(context).maybePop()是一种很友善的退出方式，如果能退出就退出，不退出拉到。其实这个方法可以理解为
maybePop() => canPop() == true?pop() : do nothing

所以在首页调用maybePop()是不会退出的，如果在其它页面调用，效果和pop()一样



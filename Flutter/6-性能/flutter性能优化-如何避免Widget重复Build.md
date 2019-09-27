# **问题描述：**

在Flutter开发的过程中，当我们获取到新的数据或者数据发生变化，需要去执行setState进行页面刷新的时候，经常会出现不必要的子节点Widget也进行了build，但实际上我们是不想让它再次build，出现这些问题的典型情况是在使用FutureBuilder的时候，例如：

```
@override
Widget build(BuildContext context) {
  return FutureBuilder(
    future: httpCall(),
    builder: (context, snapshot) {
      // create some layout here
    },
  );
}
```

在上面这个示例中，如果再次调用Build方法，则会触发httpCall()的方法。
那么怎样才能避免不必要的部件构建呢？

**分析：**
在Flutter中，Build方法的设计方式是pure/without side effects，书面意思是无副作用的/纯粹的，简单点理解我们可以将其含义看作不会对外部的方法或者变量产生影响的。这是因为许多外部因素能够触发新的小部件的构建，例如这些情况：

- 路由的pop/push，用于进/出页面的动画
- 屏幕大小的调整，通常是由于键盘弹出或者屏幕方向改变、
- 父级Widget重新创建它的子Widget
- 窗口小部件依赖于（Class.of(context)模式）更改的InheritedWidget

但是，这也意味着Build方法可以不去触发httpCall()的方法或者不修改任何状态。



**解决**
回归问题，当前我们面临的问题是Build方法造成了副作用，也就是造成了无关的Build调用麻烦。
所以，只要我们使Build方法保持纯粹/无副作用，这样就算多少次调用它，也不会对其他Widget的Build方法产生影响。
在上面的示例中，我们将Widget转换为StatefulWidget，然后提取httpCall()到initState中，这样问题就解决了

```js
class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  Future<int> future;

  @override
  void initState() {
    future = Future.value(42);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        // create some layout here
      },
    );
  }
}
```

另外，还可以使一个Widget能够在不强迫其子部件也构建的情况下进行重新构建。
在Widget的实例保持不变时;Flutter会有意识的不去重建子部件。这意味着我们可以缓存Widget树的某些部分，以防止不必要的重新构建。

最简单的方法是使用const修饰构造函数:

```js
@override
Widget build(BuildContext context) {
  return const DecoratedBox(
    decoration: BoxDecoration(),
    child: Text("Hello World"),
  );
}
```

由于const的修饰，即使调用了数百次build，DecoratedBox的实例也将保持不变。

或者你可以这样使用以达到相同的结果:

```js
@override
Widget build(BuildContext context) {
  final subtree = MyWidget(
    child: Text("Hello World")
  );

  return StreamBuilder<String>(
    stream: stream,
    initialData: "Foo",
    builder: (context, snapshot) {
      return Column(
        children: <Widget>[
          Text(snapshot.data),
          subtree,
        ],
      );
    },
  );
}
```

在这个例子中，当StreamBuilder收到新值的通知时，即使StreamBuilder的Column进行了重构，subtree也不会进行重构。这是因为由于闭包，MyWidget的实例没有改变。

这种模式在动画中经常使用。典型的是使用AnimatedBuilder和所有的*Transition时，例如AlignTransition。

我们还可以将subtree存储到类的一个字段中，但是并不推荐你这样做，因为它会破坏Flutter的热重载。


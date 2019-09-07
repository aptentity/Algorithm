通过实际案列理解 Flutter 中 Key 在其渲染机制中起到的作用，从而达到能在合理的时间和地点使用合理的 Key.

# 概览

在 `Flutter`中，大概大家都知道如何更新界面视图: 通过修改 `State`去触发 `Widget`重建，触发和更新的操作是 `Flutter`框架做的。 但是有时即使修改了 `State`，`Flutter`框架好像也没有触发 `Widget`重建，
其中就隐含了 `Flutter`框架内部的更新机制，在某些情况下需要结合使用 `Key`，才能触发真正的“重建”。
下面将从 3 个方面 (When, Where, Which) 说明如何在合理的时间和地点使用合理的 Key。

首先，我们要明白Key的作用，*Keys preserve state when widgets move around in your widget tree. They can be used to preserve the user's scroll location, or keeping state when modifying a collection.*(当组件在组件树中移动时使用Key可以保持*组件*之前的状态，比如在用户滑动时或者集合改变时)

# When: 什么时候该使用Key

## 实战例子

需求: 点击界面上一个按钮，然后交换行中的两个色块。

## StatelessWidget 实现

使用 `StatelessWidget`(`StatelessColorfulTile`) 做 `child`(`tiles`):

```
class PositionedTiles extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PositionedTilesState();
}

class PositionedTilesState extends State<PositionedTiles> {
  List<Widget> tiles;

  @override
  void initState() {
    super.initState();
    tiles = [
      StatelessColorfulTile(),
      StatelessColorfulTile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: tiles))),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.sentiment_very_satisfied), onPressed: swapTiles));
  }
```

当点击按钮时，更新 `PositionedTilesState`中储存的 `tiles`:

```
void swapTiles() {
    setState(() {
      tiles.insert(1, tiles.removeAt(0));
    });
  }
}
class StatelessColorfulTile extends StatelessWidget {
  final Color color = UniqueColorGenaretor.getColor();

  StatelessColorfulTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => buildColorfulTile(color);
}
```

结果

![img](https://upload-images.jianshu.io/upload_images/2833342-2404d34ae309ac4f.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/433)

成功实现需求 _

## StatefulWidget 实现

使用 `StatefulWidget`(`StatefulColorfulTile`) 做 `child`(`tiles`):

```
class StatefulColorfulTile extends StatefulWidget {
  StatefulColorfulTile({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatefulColorfulTileState();
}

class StatefulColorfulTileState extends State<StatefulColorfulTile> {
  // 将 Color 储存在 StatefulColorfulTile 的 State StatefulColorfulTileState 中.
  Color color;

  @override
  void initState() {
    super.initState();
    color = UniqueColorGenaretor.getColor();
  }

  @override
  Widget build(BuildContext context) => buildColorfulTile(color);
}
```

修改外部容器 `PositionedTiles`中 `tiles`:

```
  @override
  void initState() {
    super.initState();
    tiles = [
      StatefulColorfulTile(),
      StatefulColorfulTile(),
    ];
  }
```

结果

![img](https://upload-images.jianshu.io/upload_images/2833342-480c3797af1b280e.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/229)

貌似没效果 -_-

为什么使用 `StatefulWidget`就不能成功更新呢？ 需要先了解下面的内容。

## Fluuter 对 Widget 的更新原理

在 Flutter 框架中，视图维持在树的结构中，我们编写的 Widget 一个嵌套一个，最终组合为一个 Tree。

### StatelessWidget

在第一种使用 `StatelessWidget`的实现中，当 Flutter 渲染这些 Widgets 时，`Row`Widget 为它的子 Widget 提供了一组有序的插槽。对于每一个 Widget，Flutter 都会构建一个对应的 `Element`。构建的这个 `Element`Tree 相当简单，仅保存有关每个 `Widget`类型的信息以及对子`Widget`的引用。你可以将这个 `Element`Tree 当做就像你的 Flutter App 的骨架。它展示了 App 的结构，但其他信息需要通过引用原始`Widget`来查找。

![img](https://upload-images.jianshu.io/upload_images/2833342-ad9eb327308fcea6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

StatelessWidget Tree & Element Tree"

当我们交换行中的两个色块时，Flutter 遍历 `Widget`树，看看骨架结构是否相同。它从 `Row`Widget 开始，然后移动到它的子 Widget，Element 树检查 Widget 是否与旧 Widget 是相同类型和 `Key`。 如果都相同的话，它会更新对新 widget 的引用。在我们这里，Widget 没有设置 Key，所以`Flutter`只是检查类型。它对第二个孩子做同样的事情。所以 Element 树将根据 Widget 树进行对应的更新。

![img](https://upload-images.jianshu.io/upload_images/2833342-061d6a73d1658c8b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

swap之后

当 Element Tree 更新完成后，Flutter 将根据 Element Tree 构建一个 Render Object Tree，最终开始渲染流程。

![img](https://upload-images.jianshu.io/upload_images/2833342-246cd6e561735576.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000)

类似这样的渲染流程

### StatefulWidget

当使用 `StatefulWidget`实现时，控件树的结构也是类似的，只是现在 color 信息没有存储控件自身了，而是在外部的 State 对象中。

![img](https://upload-images.jianshu.io/upload_images/2833342-dfc5dfa9df3c23f1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

StatefulWidget Tree & Element Tree

现在，我们点击按钮，交换控件的次序，Flutter 将遍历 Element 树，检查 Widget 树中 `Row`控件并且更新 Element 树中的引用，然后第一个 Tile 控件检查它对应的控件是否是相同类型，它发现对方是相同的类型; 然后第二个 Tile 控件做相同的事情，最终就导致 Flutter 认为这两个控件都没有发生改变。Flutter 使用 Element 树和它对应的控件的 State 去确定要在设备上显示的内容, 所以 Element 树没有改变，显示的内容也就不会改变。

![img](https://upload-images.jianshu.io/upload_images/2833342-aad8a81b7527d87d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

swap之后

### StatefullWidget 结合 Key

现在，为 `StatefulColorfulTile`传递一个 `Key`对象:

```
void initState() {
  super.initState();
  tiles = [
    // 使用 UniqueKey
    StatefulColorfulTile(key: UniqueKey()),
    StatefulColorfulTile(key: UniqueKey()),
  ];
}
```

再次运行:

![img](https://upload-images.jianshu.io/upload_images/2833342-7580a5aac9b228d0.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/433)

成功 swap!

添加了 `Key`之后的结构:

![img](https://upload-images.jianshu.io/upload_images/2833342-aabe215e9b229394.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

当现在执行 swap 时, Element 数中 StatafulWidget 控件除了比较类型外，还会比较 `key`是否相等:

![img](https://upload-images.jianshu.io/upload_images/2833342-1eb60ca896d8a6d3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

只有类型和`key`都匹配时，才算找到对应的 Widget。于是在 Widget Tree 发生交换后，Element Tree 中子控件和原始控件对应关系就被打乱了，所以 Flutter 会重建 Element Tree，直到控件们正确对应上。

![img](https://upload-images.jianshu.io/upload_images/2833342-5c56ed19d5069f1e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

所以，现在 Element 树正确更新了，最终就会显示交换后的色块。

![img](https://upload-images.jianshu.io/upload_images/2833342-355cd6d3c157722c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

### 使用场景

如果要修改集合中的控件的顺序或数量，`Key`会很有用。

# Where: 在哪设置 Key

*正常情况下应该在当前 Widget 树的顶级 Widget 中设置。*

回到 `StatefulColorfulTile`例子中，为每个色块添加一个 `Padding`，同时 `key`还是设置在相同的地方:

```
@override
void initState() {
  super.initState();
  tiles = [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: StatefulColorfulTile(key: UniqueKey()),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: StatefulColorfulTile(key: UniqueKey()),
    ),
  ];
}
```

![img](https://upload-images.jianshu.io/upload_images/2833342-98f909aad981c906.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/544)

交换时

当点击按钮发生交换之后，可以看到两个色块的颜色会随机改变，但是我的预期是两个固定的颜色彼此交换。

## 为什么产生问题

当Widget 树中两个 `Padding`发生了交换，它们包裹的色块也就发生了交换:

![img](https://upload-images.jianshu.io/upload_images/2833342-532c37d600d77f69.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

然后 Flutter 将进行检查，以便对 Element 树进行对应的更新: Flutter 的 `Elemetn to Widget`匹配算法将一次只检查树的一个层级:

![img](https://upload-images.jianshu.io/upload_images/2833342-871124d2ca728415.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

1.在第一级，`Padding`Widget 都正确匹配。

![img](https://upload-images.jianshu.io/upload_images/2833342-fe28943cb823c0d5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)



2.在第二级，Flutter 注意到 Tile 控件的 `Key`不匹配，就停用该 Tile Element，删除 Widget 和 Element 之间的连接

![img](https://upload-images.jianshu.io/upload_images/2833342-8e06cbf075c21ec8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

3.我们这里使用的 `Key`是 `UniqueKey`， 它是一个 `LocalKey`

`LocalKey`的意思是: 当 Widget 与 Element 匹配时，Flutter 只在树中特定级别内查找匹配的 Key。因此 Flutter 无法在同级中找到具有该 Key 的 Tile Widget，所以它会创建一个新 Element 并初始化一个新 State。 就是这个原因，造成色块颜色发生随机改变，每次交换相当于生成了两个新的 Widget。

4.解决这个问题: 将 `Key`设置到上层 Widget `Padding`上

当 Widget 树中两个 `Padding`发生交换之后，Flutter 就能根据 `Padding`上 `Key`的变化，更新 `Element`树中的两个 `Padding`，从而实现交换。

```
 @override
 void initState() {
   super.initState();
   tiles = [
     Padding(
       key: UniqueKey(),
       padding: const EdgeInsets.all(8.0),
       child: StatefulColorfulTile(),
     ),
     Padding(
       key: UniqueKey(),
       padding: const EdgeInsets.all(8.0),
       child: StatefulColorfulTile(),
     ),
   ];
 }
```

![img](https://upload-images.jianshu.io/upload_images/2833342-d58898638392c201.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/425)



# Which: 该使用哪种类型的 Key

`Key`的目的在于为每个 Widget 指明一个唯一的身份，使用何种 `Key`就要依具体的使用场景决定。

- ValueKey

例如在一个 `ToDo`列表应用中，每个 `Todo`Item 的文本是恒定且唯一的。这种情况，适合使用 `ValueKey`，value 是文本。

- ObjectKey

假设，每个子 Widget 都存储了一个更复杂的数据组合，比如一个用户信息的地址簿应用。任何单个字段（如名字或生日）可能与另一个条目相同，但每个数据组合是唯一的。在这种情况下， `ObjectKey`最合适。

- UniqueKey

如果集合中有多个具有相同值的 Widget，或者如果您想确保每个 Widget 与其他 Widget 不同，则可以使用 `UniqueKey`。 在我们的例子中就使用了 `UniqueKey`，因为我们没有将任何其他常量数据存储在我们的色块上，并且在构建 Widget 之前我们不知道颜色是什么。

不要在 `Key`中使用随机数，如果你那样设置，那么当每次构建 Widget 时，都会生成一个新的随机数，Element 树将不会和 Widget 树做一致的更新。

- GlobalKeys

Global Keys有两种用途。

- 它们允许 Widget 在应用中的任何位置更改父级而不会丢失 State ，或者可以使用它们在 Widget 树 的完全不同的部分中访问有关另一个 Widget 的信息。

  - 比如: 要在两个不同的屏幕上显示相同的 Widget，同时保持相同的 State，则需要使用 GlobalKeys。

  ![img](https://upload-images.jianshu.io/upload_images/2833342-988cabb624942c1c.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

  

- 在第二种情况下，您可能希望验证密码，但不希望与树中的其他 Widget 共享该状态信息，可以使用 `GlobalKey<FromState>`持有一个表单 `Form`的 `State`。 Flutter.dev 上有这个例子[Building a form with validation](https://links.jianshu.com/go?to=https%3A%2F%2Fflutter.dev%2Fdocs%2Fcookbook%2Fforms%2Fvalidation)。

其实 GlobalKeys 看起来有点像全局变量。有也其他更好的方法达到 GlobalKeys 的作用，比如 InheritedWidget、Redux 或 Block Pattern。

## 总结

如何合理适当的使用 `Key`:

1. When: 当您想要保留 Widget 树的状态时，请使用 `Key`。例如: 当修改相同类型的 Widget 集合（如列表中）时
2. Where: 将 `Key`设置在要指明唯一身份的 Widget 树的顶部
3. Which: 根据在该 Widget 中存储的数据类型选择使用的不同类型的`Key`
# SingleChildScrollView

SingleChildScrollView类似于Android中的ScrollView，它只能接收一个子Widget。

```
SingleChildScrollView({
  this.scrollDirection = Axis.vertical, //滚动方向，默认是垂直方向
  this.reverse = false, // 设置显示方式
  this.padding, // 内边距
  bool primary, // 是否使用默认的controller
  this.physics, // 设置可滚动Widget如何响应用户操作
  this.controller,
  this.child,
})
```



# Scrollbar

`Scrollbar`是一个`Material`风格的滚动指示器（滚动条），如果要给可滚动`widget`添加滚动条，只需将`Scrollbar`作为可滚动`widget`的父`widget`即可

CupertinoScrollbar`是`iOS`风格的滚动条，如果你使用的是`Scrollbar`，那么在`iOS`平台它会自动切换为`CupertinoScrollbar

`Scrollbar`和`CupertinoScrollbar`都是通过`ScrollController`来监听滚动事件来确定滚动条位置

```
const Scrollbar({
    Key key,
    @required this.child,
})

const CupertinoScrollbar({
    Key key,
    @required this.child,
})
```



# ListView

ListView`是最常用的可滚动`widget`，它可以沿一个方向线性排布所有子`widget



# NestedScrollView

支持嵌套滑动的 ScrollView。




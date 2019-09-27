在React Native跨平台开发框中，我们经常会看到，当界面组件层次嵌套深，组件交互涉及业务逻辑时，为了代码层次简洁、清晰，都会将组件拆分到方法中，然后在主布局中引入，例如：

```
render() {	
  return (	
      &lt;View style={{ flex: 1, backgroundColor: Color.white }}&gt;	
           &lt;NavBar /&gt;	
         { this. this._renderContent() }	
      &lt;/View&gt;	
  )	
}
```

由于内容涉及复杂，我们将业务逻辑和UI展示抽离到了方法中。

很多朋友在接触Flutter开发后，都有一个共同的抱怨，那就是这布局太难写了，随便一个简单的布局都要嵌套很多层。于是很多开发者都会将其拆分到方法中，并且之前看到一些开源项目同样使用了这种方式，那么在Flutter中这种方式是否适用呢？

### 问题展示

例如有如下一段代码：

```
@override	
Widget build(BuildContext context) {	
  return Scaffold(	
  body: Center(	
    child: Column(	
      mainAxisAlignment: MainAxisAlignment.center,	
      children: &lt;Widget&gt;[	
        Text(	
          widget.title,	
        ),	
        Center(	
          child: Text(result,)	
        ),	
        Row(	
          children: [	
          MaterialButton(	
            color: Theme.of(context).primaryColor,	
            child: Text("1", style: TextStyle(color: Colors.white)),	
            onPressed: () =&gt; onPressCallback('startActivity'),	
          ),	
          ......	
          ]	
        )	
      ],	
    ),	
  ),	
  );	
}
```

初次看到 Flutter 的 UI 代码，有些朋友可能觉的嵌套级别有点疯狂。 由于小部件可能有点模板化，因此首先想到的解决方案是将嵌套部分拆分为单独的方法。此时就会有了下面这段代码：

```
 
	
@override	
Widget build(BuildContext context) {	
  return Scaffold(	
  body: Center(	
    child: Column(	
      mainAxisAlignment: MainAxisAlignment.center,	
      children: &lt;Widget&gt;[	
        Text(	
          widget.title,	
        ),	
        Center(	
          child: Text(result,)	
        ),	
        this._buildRowBtnWidget() // 拆分为组件方法	
      ],	
    ),	
  ),	
  );	
}	
 	
/**	
 * 组件方法模块	
 */	
Widget _buildRowBtnWidget() {	
  return Row(	
  children: [	
    MaterialButton(	
    color: Theme.of(context).primaryColor,	
    child: Text("1", style: TextStyle(color: Colors.white)),	
    onPressed: () =&gt; onPressCallback('startActivity'),	
    ),	
    ......	
  ]	
  )	
}

```

此时看上去很优美了，那这样写会不会存在问题呢？

将小部件拆分为方法的方式，乍一看，将长构建方法拆分为小函数非常有意义。其实我们不应该这样做。假设当前有一个state状态值 num，每当我们通过 setState() 去触发 num 数据更新，都会调用 _buildRowBtnWidget()，这会造成一次又一次地重建小部件树。而 _buildRowBtnWidget() 中的组件并不需要做任何更新展示，即为无状态的组件模块。当应用程序较为复杂时，会产生明显的渲染性能影响（CPU调度）。

### 优化方案

Flutter 中创建组件分为两种方式：有状态（StatefulWidget） & 无状态（StatelessWidget） 组件。所以我们不是将构建方法拆分为更小的方法，而是将它们拆分为无状态的小部件，即：StatelessWidgets。来看看重构之后的代码：

```
 
	
@override	
Widget build(BuildContext context) {	
  return Scaffold(	
  body: Center(	
    child: Column(	
      mainAxisAlignment: MainAxisAlignment.center,	
      children: &lt;Widget&gt;[	
        Text(	
          widget.title,	
        ),	
        Center(	
          child: Text(result,)	
        ),	
        const _RowBtnWidget() // 拆分为组件方法	
      ],	
    ),	
  ),	
  );	
}	
 	
/**	
 * 组件	
 */	
class _RowBtnWidget extends StatelessWidget {	
 	
  const _RowBtnWidget();	
 	
  @override	
  Widget build(BuildContext context) {	
  return Row(	
    children: [	
    MaterialButton(	
      color: Theme.of(context).primaryColor,	
        child: Text("1", style: TextStyle(color: Colors.white)),	
      onPressed: () =&gt; onPressCallback('startActivity'),	
    ),	
    ......	
    ]	
  )	
  }	
}


```

可以看到上述代码要比拆分为方法显得“臃肿”很多，但这 _RowBtnWidget 只会构建一次，减少了不必要的组件重建的性能开销。 

### 结论

在创建无状态组件时，我们将它们拆分为StatelessWidgets。 减少重建静态小部件的性能开销。 在优化Flutter应用程序的性能方面，也是非常简单的一种优化方式。


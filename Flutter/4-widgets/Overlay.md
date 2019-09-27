Overlay 这个组件提供了动态的在Flutter的渲染树上插入布局的特性

## Overlay与OverlayEntry

Overlay是一个Stack的widget，可以将overlay entry插入到overlay中，使独立的child窗口悬浮于其他widget之上。 因为Overlay本身使用的是[Stack]布局，所以overlay entry可以使用[Positioned] 或者 [AnimatedPositioned]在overlay中定位自己的位置。 当我们创建MaterialApp的时候，它会自动创建一个Navigator，然后创建一个Overlay; 然后利用这个Navigator来管理路由中的界面。 就我感觉，有点类似Android中的WindowManager，可以利用addView和removeView方法添加或删除View到界面中。

## Overlay的使用方法

主要就是两个方法，往Overlay中插入entry，删除Overlay中的entry。

```
//创建OverlayEntry
Overlay entry=new OverlayEntry(builder:(){/*在这里创建对应的widget*/});
//往Overlay中插入插入OverlayEntry
Overlay.of(context).insert(overlayEntry);
//调用entry自身的remove()方法，从所在的overlay中移除自己
entry.remove();
复制代码
```

## Overlay的使用场景

要将某个widget悬浮到页面顶部，就可以利用Overlay来实现。挺多场景都会用到，比如下面的例子。

### 自定义Toast



![img](https://user-gold-cdn.xitu.io/2018/12/29/167f908ab9144935?imageView2/0/w/1280/h/960/ignore-error/1)

如果自己写插件调用原生的Toast的话，比较麻烦，可能还会出一些适配的问题。所以可以在Flutter中利用Overlay实现Toast的效果，比较方便，而且无需担心适配的问题。 下面是简单地显示一个Toast，更多功能的话，自行封装咯。

```
/**
 * 利用overlay实现Toast
 */
class Toast {
  static void show({@required BuildContext context, @required String message}) {
    //创建一个OverlayEntry对象
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
    //外层使用Positioned进行定位，控制在Overlay中的位置
      return new Positioned(
          top: MediaQuery.of(context).size.height * 0.7,
          child: new Material(
            child: new Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: new Center(
                child: new Card(
                  child: new Padding(
                    padding: EdgeInsets.all(8),
                    child: new Text(message),
                  ),
                  color: Colors.grey,
                ),
              ),
            ),
          ));
    });
    //往Overlay中插入插入OverlayEntry
    Overlay.of(context).insert(overlayEntry);
    //两秒后，移除Toast
    new Future.delayed(Duration(seconds: 2)).then((value) {
      overlayEntry.remove();
    });
  }
}
```



### 类似PopupWindow的弹窗效果



![img](https://user-gold-cdn.xitu.io/2018/12/29/167f9094d19a4d48?imageView2/0/w/1280/h/960/ignore-error/1)



比如实现微信首页右上角，点击“+”后的显示的弹窗效果。

（TODO：如何监听某个widget的焦点变化，我知道textform可以用focusNode来监听焦点变化，那其他widget如何监听焦点变化呢？）

```
/**
   * 展示微信下拉的弹窗
   */
  void showWeixinButtonView() {
    weixinOverlayEntry = new OverlayEntry(builder: (context) {
      return new Positioned(
          top: kToolbarHeight,
          right: 20,
          width: 200,
          height: 320,
          child: new SafeArea(
              child: new Material(
            child: new Container(
              color: Colors.black,
              child: new Column(
                children: <Widget>[
                  Expanded(
                    child: new ListTile(
                      leading: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      title: new Text(
                        "发起群聊",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: new ListTile(
                      leading: Icon(Icons.add, color: Colors.white),
                      title: new Text("添加朋友",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: new ListTile(
                      leading: Icon(Icons.add, color: Colors.white),
                      title: new Text("扫一扫",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: new ListTile(
                      leading: Icon(Icons.add, color: Colors.white),
                      title: new Text("首付款",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: new ListTile(
                      leading: Icon(Icons.add, color: Colors.white),
                      title: new Text("帮助与反馈",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          )));
    });
    Overlay.of(context).insert(weixinOverlayEntry);
  }
}
复制代码
```

### 比如，在某个TextForm获得焦点的时候，在TextForm下方显示一个listview的选择项



![img](https://user-gold-cdn.xitu.io/2018/12/29/167f909f7bfc8e0d?imageView2/0/w/1280/h/960/ignore-error/1)



```
 FocusNode focusNode = new FocusNode();
  OverlayEntry overlayEntry;

  LayerLink layerLink = new LayerLink();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        overlayEntry = createSelectPopupWindow();
        Overlay.of(context).insert(overlayEntry);
      } else {
        overlayEntry.remove();
      }
    });
  }


  /**
     * 利用Overlay实现PopupWindow效果，悬浮的widget
     * 利用CompositedTransformFollower和CompositedTransformTarget
     */
    OverlayEntry createSelectPopupWindow() {
      OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
        return new Positioned(
          width: 200,
          child: new CompositedTransformFollower(
            offset: Offset(0.0, 50),
            link: layerLink,
            child: new Material(
              child: new Container(
                  color: Colors.grey,
                  child: new Column(
                    children: <Widget>[
                      new ListTile(
                        title: new Text("选项1"),
                        onTap: () {
                          Toast.show(context: context, message: "选择了选项1");
                          focusNode.unfocus();
                        },
                      ),
                      new ListTile(
                          title: new Text("选项2"),
                          onTap: () {
                            Toast.show(context: context, message: "选择了选项1");
                            focusNode.unfocus();
                          }),
                    ],
                  )),
            ),
          ),
        );
      });
      return overlayEntry;
    }


复制代码
```


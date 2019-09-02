### 背景

用户行为埋点是用来记录用户在操作时的一系列行为，也是业务做判断的核心数据依据，如果缺失或者不准确将会给业务带来不可恢复的损失。闲鱼将业务代码从Native迁移到Flutter上过程中，发现原先Native体系上的埋点方案无法应用在Flutter体系之上。而如果我们只把业务功能迁移过来就上线，对业务是极其不负责任的。因此，经过不断探索，我们沉淀了一套Flutter上的高准确率的用户行为埋点方案。

### 用户行为埋点定义

先来讲讲在我们这里是如何定义用户行为埋点的。在如下用户时间轴上，用户进入A页面后，看到了按钮X，然后点击了这个按钮，随即打开了新的页面B。
![img](https://gw.alicdn.com/tfs/TB1sYNgck5E3KVjSZFCXXbuzXXa-1054-418.png)

这个时间轴上有如下5个埋点事件发生：

- 进入A页面。A页面首帧渲染完毕，并获得了焦点。
- 曝光坑位X。按钮X处于手机屏幕内，且停留一段时间，让用户可见可触摸。
- 点击坑位X。用户对按钮X的内容很感兴趣，于是点击了它。按钮X响应点击，然后需要打开一个新页面。
- 离开A页面。A页面失去焦点。
- 进入B页面。B页面首帧渲染完毕，并获得焦点。

在这里，打埋点最重要的是时机，即在什么时机下的事件中触发什么埋点，下面来看看闲鱼在Flutter上的实现方案。

### 实现方案

#### 进入/离开页面

在Native原生开发中，Android端是监听Activity的onResume和onPause事件来做为页面的进入和离开事件，同理iOS端是监听UIViewController的viewWillAppear和viewDidDisappear事件来做为页面的进入和离开事件。同时整个页面栈是由Android和iOS操作系统来维护。

在Flutter中，Android和iOS端分别是用FlutterActivity和FlutterViewController来做为容器承载Flutter的页面，通过这个容器可以在一个Native的页面内（FlutterActivity/FlutterViewController）来进行Flutter原生页面的切换。即在Flutter自己维护了一个Flutter页面的页面栈。这样，原来我们最熟悉的那套在Native原生上方案在Flutter上无法直接运作起来。

针对这个问题，可能很多人会想到去注册监听Flutter的NavigatorObserver，这样就知道Flutter页面的进栈（push）和出栈（pop）事件。但是这会有两个问题：

- 假设A、B两个页面先后进栈（A enter -> A leave -> B enter）。然后B页面返回退出（B leave），此时A页面重新可见，但是此时是收不到A页面push（A enter）的事件。
- 假设在A页面弹出一个Dialog或者BottomSheet，而这两类也会走push操作，但实际上A页面并未离开。

好在Flutter的页面栈不像Android Native的页面栈那么复杂，所以针对第一个问题，我们可以来维护一个和页面栈匹配的索引列表。当收到A页面的push事件时，往队列里塞一个A的索引。当收到B页面的push事件时，检测列表内是否有页面，如有，则对列表最后一个页面执行离开页面事件记录，然后再对B页面执行进入页面事件记录，接着往队列里塞一个B的索引。当收到B页面的pop事件时，先对B页面执行离开页面事件记录，然后对队列里存在的最后一个索引对应的页面（假设为A）进行判断是否在栈顶（ModalRoute.of(context).isCurrent
），如果是，则对A页面执行进入页面事件记录。

针对第二个问题，Route类内有个成员变量overlayEntries，可以获取当前Route对应的所有图层OverlayEntry，在OverlayEntry对象中有个成员变量opaque可以判断当前这个图层是否全屏覆盖，从而可以排除Dialog和BottomSheet这种类型。再结合问题1，还需要在上述方案中加上对push进来的新页面来做判断是否为一个有效页面。如果是有效页面，才对索引列表中前一个页面做离开页面事件，且将有效页面加到索引列表中。如果不是有效页面，则不操作索引列表。

以上并不是闲鱼的方案，只是笔者给出的一个建议。因为闲鱼APP在一开始落地Flutter框架时，就没有使用Flutter原生的页面栈管理方案，而是采用了Native+Flutter混合开发的方案。具体可参考前面的一篇文章[《已开源|码上用它开始Flutter混合开发——FlutterBoost》](https://yq.aliyun.com/go/articleRenderRedirect?url=https%3A%2F%2Fmp.weixin.qq.com%2Fs%2Fv-wwruadJntX1n-YuMPC7g)。因此接下来也是基于此来阐述闲鱼的方案。

闲鱼的方案如下（以Android为例，iOS同理）：
![img](https://gw.alicdn.com/tfs/TB1CHvCcouF3KVjSZK9XXbVtXXa-1100-826.png)
![img](https://gw.alicdn.com/tfs/TB1PuvIclCw3KVjSZR0XXbcUpXa-1100-712.png)

注：首次打开指的是基于混合栈新打开一个页面，非首次打开指的是通过回退页面的方式，在后台的页面再次到前台可见。

看似我们将何时去触发进入/离开页面事件的判断交给Flutter侧，实际上依然跟Native侧的页面栈管理保持了一致，将原先在Native侧做打埋点的时机告知Flutter侧，然后Flutter侧再立刻通过channel来调用Native侧的打埋点方法。那么可能会有人问，为什么这么绕，不全部交给Native侧去直接管理呢？交给Native侧去直接管理这样做针对非首次打开这个场景是合适的，但是对首次打开这个场景却是不合适的。因为在首次打开这个场景下，onResume时Flutter页面尚未初始化，此时还不知道页面信息，因此也就不知道进入了什么页面，所以需要在Flutter页面初始化（init）时再回过来调Native侧的进入页面埋点接口。为了避免开发人员去关注是否为首次打开Flutter页面，因此我们统一在Flutter侧来直接触发进入/离开页面事件。

### 曝光坑位

先讲下曝光坑位在我们这里的定义，我们认为图片和文本是有曝光意义的，其他用户看不见的是没有曝光意义的，在此之上，当一个坑位同时满足以下两点时才会被认为是一次有效曝光：

- 坑位在屏幕可见区域中的面积大于等于坑位整体面积的一半。
- 坑位在屏幕可见区域中停留超过500ms。

基于此定义，我们可以很快得出如下图所示的场景，在一个可以滚动的页面上有A、B、C、D共4个坑位。其中：

- 坑位A已经滑出了屏幕可见区域，即invisible；
- 坑位B即将向上从屏幕中可见区域滑出，即visible->invisible；
- 坑位C还在屏幕中央可视区域内，即visible；
- 坑位D即将滑入屏幕中可见区域，invisible->visible；
  ![img](https://gw.alicdn.com/tfs/TB1uZYwcf1H3KVjSZFHXXbKppXa-1562-1100.png)

那么我们的问题就是如何算出坑位在屏幕内曝光面积的比例。要算出这个值，需要知道以下几个数值：

- 容器相对屏幕的偏移量
- 坑位相对容器的偏移量
- 坑位的位置和宽高
- 容器的位置和宽高

其中坑位和容器的宽和高很容易获取和计算，这里就不再累述。

##### 获取容器相对屏幕的偏移量

```
//监听容器滚动，得到容器的偏移量
double _scrollContainerOffset = scrollNotification.metrics.pixels;
```

##### 获取坑位相对容器的偏移量

```
//曝光坑位Widget的context
final RenderObject childRenderObject = context.findRenderObject();
final RenderAbstractViewport viewport = RenderAbstractViewport.of(childRenderObject);
if (viewport == null) {
  return;
}
if (!childRenderObject.attached) {
  return;
}
//曝光坑位在容器内的偏移量
final RevealedOffset offsetToRevealTop = viewport.getOffsetToReveal(childRenderObject, 0.0);
```

##### 逻辑判断

```
if (当前坑位是invisible && 曝光比例 >= 0.5) {
  记录当前坑位是visible状态
  记录出现时间
} else if (当前坑位是visible && 曝光比例 < 0.5) {
  记录当前坑位是invisible状态
  if (当前时间-出现时间 > 500ms) {
    调用曝光埋点接口
  }
}
```

#### 点击坑位

点击坑位埋点没什么难点，很容易就可以想到下面的方案：
![img](https://gw.alicdn.com/tfs/TB1s8vtca1s3KVjSZFAXXX_ZXXa-928-382.png)

### 效果

经过多轮迭代和优化，目前线上Flutter页面的埋点准确率已经达到100%，有力地支持了业务的分析和判断。同时这套方案让业务同学在做开发时，对于页面进入/离开、曝光坑位可以做到无感知，即不用关心何时去触发，做到了简单易用和无侵入性。

### 展望

此外，针对页面进入/离开这个场景，由于闲鱼是基于Flutter Boost混合栈的方案，因此我们的解决方案还不够通用。不过未来随着闲鱼上的Flutter页面越来越多，我们后续也会去实现基于Flutter原生的方案。
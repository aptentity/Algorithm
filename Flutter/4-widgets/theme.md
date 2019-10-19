在`Flutter`中使用`ThemeData`来在应用中共享颜色和字体样式，Theme有两种：全局Theme和局部Theme。 全局Theme是由应用程序根`MaterialApp`创建的Theme 。

定义好一个Theme后，就可以在自己的`Widget`中使用它。另外，`Flutter`提供的`Material Widgets`将使用我们的Theme为AppBars、Buttons、Checkboxes等设置背景颜色和字体样式。

先来看看`ThemeData`的主要属性

- accentColor - `Color`类型，前景色（文本、按钮等）
- accentColorBrightness - `Brightness`类型，`accentColor`的亮度。 用于确定放置在突出颜色顶部的文本和图标的颜色（例如FloatingButton上的图标）。
- accentIconTheme - `IconThemeData`类型，与突出颜色对照的图片主题。
- accentTextTheme - `TextTheme`类型，与突出颜色对照的文本主题。
- backgroundColor - `Color`类型，与`primaryColor`对比的颜色(例如 用作进度条的剩余部分)。
- bottomAppBarColor - `Color`类型，`BottomAppBar`的默认颜色。
- brightness - `Brightness`类型，应用程序整体主题的亮度。 由按钮等`Widget`使用，以确定在不使用主色或强调色时要选择的颜色。
- buttonColor - `Color`类型，`Material`中`RaisedButtons`使用的默认填充色。
- buttonTheme - `ButtonThemeData`类型，定义了按钮等控件的默认配置，像`RaisedButton`和`FlatButton`。
- canvasColor - `Color`类型，`MaterialType.canvas Material`的默认颜色。
- cardColor - `Color`类型，`Material`被用作`Card`时的颜色。
- chipTheme - `ChipThemeData`类型，用于渲染`Chip`的颜色和样式。
- dialogBackgroundColor - `Color`类型，`Dialog`元素的背景色。
- disabledColor - `Color`类型，用于`Widget`无效的颜色，无论任何状态。例如禁用复选框。
- dividerColor - `Color`类型，`Dividers`和`PopupMenuDividers`的颜色，也用于`ListTiles`中间，和`DataTables`的每行中间.
- errorColor - `Color`类型，用于输入验证错误的颜色，例如在`TextField`中。
- hashCode - `int`类型，这个对象的哈希值。
  *highlightColor - `Color`类型，用于类似墨水喷溅动画或指示菜单被选中的高亮颜色。
- hintColor - `Color`类型，用于提示文本或占位符文本的颜色，例如在`TextField`中。
- iconTheme - `IconThemeData`类型，与卡片和画布颜色形成对比的图标主题。
- indicatorColor - `Color`类型，TabBar中选项选中的指示器颜色。
- inputDecorationTheme - `InputDecorationTheme`类型，`InputDecorator`，`TextField`和`TextFormField`的默认`InputDecoration`值基于此主题。
- platform - `TargetPlatform`类型，`Widget`需要适配的目标类型。
- primaryColor - `Color`类型，App主要部分的背景色（ToolBar,Tabbar等）。
- primaryColorBrightness - `Brightness`类型，`primaryColor`的亮度。
- primaryColorDark - `Color`类型，`primaryColor`的较暗版本。
- primaryColorLight - `Color`类型，`primaryColor`的较亮版本。
- primaryIconTheme - `IconThemeData`类型，一个与主色对比的图片主题。
- primaryTextTheme - `TextThemeData`类型，一个与主色对比的文本主题。
- scaffoldBackgroundColor - `Color`类型，作为`Scaffold`基础的`Material`默认颜色，典型`Material`应用或应用内页面的背景颜色。
- secondaryHeaderColor - `Color`类型，有选定行时`PaginatedDataTable`标题的颜色。
- selectedRowColor - `Color`类型，选中行时的高亮颜色。
- sliderTheme - `SliderThemeData`类型，用于渲染`Slider`的颜色和形状。
- splashColor - `Color`类型，墨水喷溅的颜色。
- splashFactory - `InteractiveInkFeatureFactory`类型，定义`InkWall`和`InkResponse`生成的墨水喷溅的外观。
- textSelectionColor - `Color`类型，文本字段中选中文本的颜色，例如`TextField`。
- textSelectionHandleColor - `Color`类型，用于调整当前文本的哪个部分的句柄颜色。
- textTheme - `TextTheme`类型，与卡片和画布对比的文本颜色。
- toggleableActiveColor - `Color`类型，用于突出显示切换`Widget`（如`Switch`，`Radio`和`Checkbox`）的活动状态的颜色。
- unselectedWidgetColor - `Color`类型，用于`Widget`处于非活动（但已启用）状态的颜色。 例如，未选中的复选框。 通常与`accentColor`形成对比。
- runtimeType - `Type`类型，表示对象的运行时类型。

至于使用主题就很简单了，在Flutter中文网上给出了很好的例子。

创建应用全局主题时，提供一个`ThemeData`给`MaterialApp`就可以了，如果没有提供，`Flutter`会提供一个默认主题。

```css
new MaterialApp(
  title: title,
  theme: new ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.lightBlue[800],
    accentColor: Colors.cyan[600],
  ),
);
```

局部主题是在应用程序某个小角落中用于覆盖全局主题，教程中提供了两个创建方法。

一是直接创建特有的`ThemeData`：

```csharp
new Theme(
  // 通过new ThemeData()创建一个实例并将其传递给Theme Widget
  data: new ThemeData(
    accentColor: Colors.yellow,
  ),
  child: new FloatingActionButton(
    onPressed: () {},
    child: new Icon(Icons.add),
  ),
);
```

一个是扩展父主题,扩展父主题时无需覆盖所有的主题属性，我们可以通过使用`copyWith`方法来实现。

```csharp
new Theme(
  data: Theme.of(context).copyWith(accentColor: Colors.yellow),
  child: new FloatingActionButton(
    onPressed: null,
    child: new Icon(Icons.add),
  ),
);
```

定义好一个主题后，就可以再`Widget`的`build`方法中通过`Theme.of(context)`函数来使用它。`Theme.of(context)`将查找`Widget`树并返回树中最近的`Theme`。如果`Widget`之上有一个单独的`Theme`定义，则返回该值。如果不是，则返回App主题。

另外，可以根据设备不同（iOS，Android和Fuchsia）提供不同的主题：

```csharp
new MaterialApp(
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? iOSTheme
          : AndroidTheme,
      title: 'Flutter Theme',
      home: new MyHomePage(),
);
```

`Flutter`的`Color`中大多数颜色从100到900，增量为100，加上颜色50，数字越小颜色越浅，数字越大颜色越深。强调色调只有100、200、400和700。

教程给出的完整例子

```java
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appName = 'Custom Themes';

    return new MaterialApp(
      title: appName,
      theme: new ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
      ),
      home: new MyHomePage(
        title: appName,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new Center(
        child: new Container(
          color: Theme.of(context).accentColor,
          child: new Text(
            'Text with a background color',
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
      floatingActionButton: new Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.yellow),
        child: new FloatingActionButton(
          onPressed: null,
          child: new Icon(Icons.add),
        ),
      ),
    );
  }
}
```
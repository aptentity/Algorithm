- **DO** ：表示你需要遵守的做法
- **DONT** ：表示这样的做法是非常不好的
- **PREFER** ：在多数情况下，都推荐的做法
- **AVOID** ： 在多数情况下，都应该避免的做法
- **CONSIDER** ： 需要你自己去斟酌的做法

# 样式规范

## 命名

### **DO: 类, 枚举, 类型定义, 以及泛型，都需要使用大写开头的驼峰命名法**

```
✅
class SliderMenu { ... }

class HttpRequest { ... }

typedef Predicate<T> = bool Function(T value);
```

在使用注解时候，也应该这样

```
✅

class Foo {
  const Foo([arg]);
}

@Foo(anArg)
class A { ... }

@Foo()
class B { ... }
```

不过为一个类的构造函数添加注解时，你可能需要创建一个小写开头的注解变量

```
✅

const foo = Foo();

@foo
class C { ... }
```

### **DO: 命名库、包、目录、dart文件都应该是小写加上下划线**

```
✅

library peg_parser.source_scanner;

import 'file_system.dart';
import 'slider_menu.dart';
```

```
❌

library pegparser.SourceScanner;

import 'file-system.dart';
import 'SliderMenu.dart';
```

### **DO: 将引用使用as转换的名字也应该是小写下划线**

```
✅

import 'dart:math' as math;
import 'package:angular_components/angular_components'
    as angular_components;
import 'package:js/js.dart' as js;
```

```
❌

import 'dart:math' as Math;
import 'package:angular_components/angular_components'
    as angularComponents;
import 'package:js/js.dart' as JS;
```

### **DO: 变量名、方法、参数名都应该是小写开头的驼峰命名法**

```
✅

var item;

HttpRequest httpRequest;

void align(bool clearItems) {
  // ...
}
```

优先使用小驼峰法作为常量命名

```
✅

const pi = 3.14;
const defaultTimeout = 1000;
final urlScheme = RegExp('^([a-z]+):');

class Dice {
  static final numberGenerator = Random();
}
```

```
❌

const PI = 3.14;
const DefaultTimeout = 1000;
final URL_SCHEME = RegExp('^([a-z]+):');

class Dice {
  static final NUMBER_GENERATOR = Random();
}

```

### DON’T: 不使用前缀字母

因为Dart可以告诉您声明的类型、范围、可变性和其他属性，所以没有理由将这些属性编码为标识符名称。

```
✅
defaultTimeout
```

```
❌
kDefaultTimeout
```

### 

## 花括号

### DO:所有流控制结构，请使用大括号

```
✅
if (isWeekDay) {
    print('Bike to work!');
  } else {
    print('Go dancing or read a book!');
}
```

这样做可以避免悬浮的else问题

### **DO: 只有一个if语句且没有else的时候，并且在一行内能够很好的展示，就可以不用花括号**

```
✅

if (arg == null) return defaultValue;
```

但是如果一行内展示比较勉强的话，就需要用花括号了：

```
✅

if (overflowChars != other.overflowChars) {
  return overflowChars < other.overflowChars;
}
```

```
❌

if (overflowChars != other.overflowChars)
  return overflowChars < other.overflowChars;
```

## 排序

为了使你的文件前言保持整洁，我们有规定的命令，指示应该出现在其中。每个“部分”应该用空行分隔。

#### DO:在其他引入之前引入所需的dart库

```
✅
  import 'dart:async';
  import 'dart:html';
  
  import 'package:bar/bar.dart';
  import 'package:foo/foo.dart';
```

#### DO:在相对引入之前先引入在包中的库

```
✅
  import 'package:bar/bar.dart';
  import 'package:foo/foo.dart';
  
  import 'util.dart';
```

#### DO:第三方包的导入先于其他包

```
✅
 import 'package:bar/bar.dart';
  import 'package:foo/foo.dart';
  
  import 'package:my_package/util.dart';
```

#### DO:在所有导入之后，在单独的部分中指定导出

```
✅
  import 'src/error.dart';
  import 'src/foo_bar.dart';
  
  export 'src/error.dart';
```

不推荐如下写法：

```
❌
  import 'src/error.dart';
  export 'src/error.dart';
  import 'src/foo_bar.dart';
```

# 文档规范

### **DO: 在dart的注释中，更加推荐使用///而非//**

```
✅

/// The number of characters in this chunk when unsplit.
int get length => ...
```

```
❌

// The number of characters in this chunk when unsplit.
int get length => ...
```

至于为什么要这样做，官方表示是由于历史原因以及他们觉得这个在某些情况下看起来更方便阅读。

### **DO: 文档注释应该以一句简明的话开头**

```
✅

/// Deletes the file at [path] from the file system.
void delete(String path) {
  ...
}
```

```
❌

/// Depending on the state of the file system and the user's permissions,
/// certain operations may or may not be possible. If there is no file at
/// [path] or it can't be accessed, this function throws either [IOError]
/// or [PermissionError], respectively. Otherwise, this deletes the file.
void delete(String path) {
  ...
}
```

### **DO: 将注释的第一句与其他内容分隔开来**

```
✅

/// Deletes the file at [path].
///
/// Throws an [IOError] if the file could not be found. Throws a
/// [PermissionError] if the file is present but could not be deleted.
void delete(String path) {
  ...
}
```

```
❌

/// Deletes the file at [path]. Throws an [IOError] if the file could not
/// be found. Throws a [PermissionError] if the file is present but could
/// not be deleted.
void delete(String path) {
  ...
}
```

### **DO: 使用方括号去声明参数、返回值以及抛出的异常**

```
❌

/// Defines a flag with the given name and abbreviation.
///
/// @param name The name of the flag.
/// @param abbr The abbreviation for the flag.
/// @returns The new flag.
/// @throws ArgumentError If there is already an option with
///     the given name or abbreviation.
Flag addFlag(String name, String abbr) => ...
```

```
✅

/// Defines a flag.
///
/// Throws an [ArgumentError] if there is already an option named [name] or
/// there is already an option using abbreviation [abbr]. Returns the new flag.
Flag addFlag(String name, String abbr) => ...
```

# 使用规范

## 依赖

### **PREFER: 推荐使用相对路径导入依赖**

如果项目结构如下：

```
my_package
└─ lib
   ├─ src
   │  └─ utils.dart
   └─ api.dart
```

想要在 *api.dart* 中导入 *utils.dart*

```
✅

import 'src/utils.dart';
```

```
❌

import 'package:my_package/src/utils.dart';
```

## 赋值

### **DO: 使用??将null值做一个转换**

在dart中 `??` 操作符表示当一个值为空时会给它赋值 `??` 后面的数据

```
❌

if (optionalThing?.isEnabled) {
  print("Have enabled thing.");
}
```

当 **optionalThing** 为空的时候，上面就会有空指针异常了。

这里说明一下。 `?.` 操作符相当于做了一次判空操作，只有当 **optionalThing** 不为空的时候才会调用 **isEnabled** 参数，当 **optionalThing** 为空的话默认返回null，用在if判断句中自然就不行了

下面是正确做法

```
✅

// 如果为空的时候你想返回false的话:
optionalThing?.isEnabled ?? false;

// 如果为空的时候你想返回ture的话:
optionalThing?.isEnabled ?? true;
```

```
❌

optionalThing?.isEnabled == true;

optionalThing?.isEnabled == false;
```

## 字符串

在dart中，不推荐使用 `+` 去连接两个字符串

### **DO: 使用回车键直接分隔字符串**

```
✅

raiseAlarm(
    'ERROR: Parts of the spaceship are on fire. Other '
    'parts are overrun by martians. Unclear which are which.');
```

```
❌

raiseAlarm('ERROR: Parts of the spaceship are on fire. Other ' +
    'parts are overrun by martians. Unclear which are which.');
```

### **PREFER: 使用${}来连接字符串与变量值**

```
✅

'Hello, $name! You are ${year - birth} years old.';
```

```
❌

'Hello, ' + name + '! You are ' + (year - birth).toString() + ' y...';
```

## 集合

dart中创建空的可扩展 **List** 有两种方法: **[]** 和 **List()**;创建空的 **HashMap** 有三种方法: **{}**, **Map()**,和 **LinkedHashMap()**

如果要创建不可扩展的列表或其他一些自定义集合类型，那么务必使用构造函数。

### **DO: 尽可能使用简单的字面量创建集合**

```
✅

var points = [];
var addresses = {};
```

```
❌

var points = List();
var addresses = Map();
```

当你想要指定类型的时候

```
✅

var points = <Point>[];
var addresses = <String, Address>{};
```

```
❌

var points = List<Point>();
var addresses = Map<String, Address>();
```

**DON’T: 不要使用.lenght的方法去表示一个集合是空的**

```
✅

if (lunchBox.isEmpty) return 'so hungry...';
if (words.isNotEmpty) return words.join(' ');
```

```
❌

if (lunchBox.length == 0) return 'so hungry...';
if (!words.isEmpty) return words.join(' ');
```

### **CONSIDER: 考虑使用高阶方法转换序列**

```
var aquaticNames = animals
    .where((animal) => animal.isAquatic)
    .map((animal) => animal.name);
```

**AVOID: 避免使用带有函数字面量的Iterable.forEach()**

forEach（）函数在JavaScript中被广泛使用，因为内置的for-in循环不能达到你通常想要的效果。在Dart中，如果要迭代序列，那么惯用的方法就是使用循环。

```
✅

for (var person in people) {
  ...
}
```

```
❌

people.forEach((person) {
  ...
});
```

**DON’T: 不要使用 List.from() 除非你打算更改结果的类型**

有两种方法去获取 **Iterable**，分别是**List.from()和Iterable.toList()**

```
✅

// 创建一个List<int>:
var iterable = [1, 2, 3];

// 输出"List<int>":
print(iterable.toList().runtimeType);
```

```
❌

// 创建一个List<int>:
var iterable = [1, 2, 3];

// 输出"List<dynamic>":
print(List.from(iterable).runtimeType);
```

### **DO: 使用 whereType()去用类型过滤一个集合**

```
❌

var objects = [1, "a", 2, "b", 3];
var ints = objects.where((e) => e is int);
```

```
❌

var objects = [1, "a", 2, "b", 3];
var ints = objects.where((e) => e is int).cast<int>();
```

```
✅

var objects = [1, "a", 2, "b", 3];
var ints = objects.whereType<int>();
```

## 参数

### **DO: 使用 = 给参数设置默认值**

```
✅

void insert(Object item, {int at = 0}) { ... }
```

```
❌

void insert(Object item, {int at: 0}) { ... }
```

### **DON’T: 不要将参数的默认值设置为 null**

```
✅

void error([String message]) {
  stderr.write(message ?? '\n');
}
```

```
❌

void error([String message = null]) {
  stderr.write(message ?? '\n');
}
```

## 变量

### AVOID: 避免存储可以计算的值

```
❌

class Circle {
  num _radius;
  num get radius => _radius;
  set radius(num value) {
    _radius = value;
    _recalculate();
  }

  num _area;
  num get area => _area;

  num _circumference;
  num get circumference => _circumference;

  Circle(this._radius) {
    _recalculate();
  }

  void _recalculate() {
    _area = pi * _radius * _radius;
    _circumference = pi * 2.0 * _radius;
  }
}
```

```
✅

class Circle {
  num radius;

  Circle(this.radius);

  num get area => pi * radius * radius;
  num get circumference => pi * 2.0 * radius;
}
```

## 成员

### **DON’T: 不要写没必要的getter 和 setter**

```
✅

class Box {
  var contents;
}
```

```
❌

class Box {
  var _contents;
  get contents => _contents;
  set contents(value) {
    _contents = value;
  }
}
```

### DO:优先使用final字段来创建只读属性

尤其对于 ```StatelessWidget```

### DON’T:在不需要的时候不要用this

```
❌
  class Box {
    var value;
    
    void clear() {
      this.update(null);
    }
    
    void update(value) {
      this.value = value;
    }
  }
```

```
✅
 class Box {
    var value;
  
    void clear() {
      update(null);
    }
  
    void update(value) {
      this.value = value;
    }
  }
```



## 构造函数

### **DO: 尽可能使用简单的初始化形式**

```
❌

class Point {
  num x, y;
  Point(num x, num y) {
    this.x = x;
    this.y = y;
  }
}
```

```
✅

class Point {
  num x, y;
  Point(this.x, this.y);
}
```

### **DON’T: 不要使用 new 来创建对象**

dart中不需要new

```
✅

Widget build(BuildContext context) {
  return Row(
    children: [
      RaisedButton(
        child: Text('Increment'),
      ),
      Text('Click!'),
    ],
  );
}
```

```
❌

Widget build(BuildContext context) {
  return new Row(
    children: [
      new RaisedButton(
        child: new Text('Increment'),
      ),
      new Text('Click!'),
    ],
  );
}
```

### **DON’T: 不要使用多余的 const 修饰对象**

```
✅

const primaryColors = [
  Color("red", [255, 0, 0]),
  Color("green", [0, 255, 0]),
  Color("blue", [0, 0, 255]),
];
```

```
❌

const primaryColors = const [
  const Color("red", const [255, 0, 0]),
  const Color("green", const [0, 255, 0]),
  const Color("blue", const [0, 0, 255]),
];
```

## 异常处理

### **DO: 使用 rethrow 重新抛出异常**

```
❌

try {
  somethingRisky();
} catch (e) {
  if (!canHandle(e)) throw e;
  handle(e);
}
```

```
✅

try {
  somethingRisky();
} catch (e) {
  if (!canHandle(e)) rethrow;
  handle(e);
}
```

## 异步

### DO:优先使用async/await代替原始的futures

async/await语法提高了可读性，允许你在异步代码中使用所有Dart控制流结构。

```
✅
 Future<int> countActivePlayers(String teamName) async {
    try {
      var team = await downloadTeam(teamName);
      if (team == null) return 0;
  
      var players = await team.roster;
      return players.where((player) => player.isActive).length;
    } catch (e) {
      log.error(e);
      return 0;
    }
  }
```

### DO:当异步没有任何用处时，不要使用它

如果可以在不改变函数行为的情况下省略异步，那么就这样做。

```
 ✅
  Future afterTwoThings(Future first, Future second) {
    return Future.wait([first, second]);
  }
```

```
❌
  Future afterTwoThings(Future first, Future second) async {
    return Future.wait([first, second]);
  }
```



# 设计规范

### **AVOID: 避免为了实现流式调用而让方法返回this**

```
✅

var buffer = StringBuffer()
  ..write('one')
  ..write('two')
  ..write('three');
```

```
❌

var buffer = StringBuffer()
    .write('one')
    .write('two')
    .write('three');
```

**AVOID: 避免使用 FutureOr<T> 作为返回类型**

```
✅

Future<int> triple(FutureOr<int> value) async => (await value) * 3;
```

```
❌

FutureOr<int> triple(FutureOr<int> value) {
  if (value is int) return value * 3;
  return (value as Future<int>).then((v) => v * 3);
}
```

### **AVOID: 避免将bool值直接作为输入参数**

```
❌

new Task(true);
new Task(false);
new ListBox(false, true, true);
new Button(false);
```

```
✅

Task.oneShot();
Task.repeating();
ListBox(scroll: true, showScrollbars: true);
Button(ButtonState.enabled);
```

### **DON’T: 不要在自定义的 == operator 方法中进行判空**

```
✅

class Person {
  final String name;
  // ···
  bool operator ==(other) => other is Person && name == other.name;

  int get hashCode => name.hashCode;
}
```

```
❌

class Person {
  final String name;
  // ···
  bool operator ==(other) => other != null && ...
}
```


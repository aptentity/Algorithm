# 一、Dart介绍

谷歌选择Dart作为开发Flutter的指定语言，并不仅仅因为是自家语言，避免纠纷。Dart语言具有很多优秀的特性。

## 1.编译和执行

### （1）静态、动态语言

历史上，计算机语言分为两组：静态语言（例如，Fortran和C，其中变量类型是在编译时静态指定的）和动态语言（例如，Smalltalk和JavaScript，其中变量的类型可以在运行时改变）。

静态语言通常编译成目标机器的本地机器代码（或汇编代码）程序，该程序在运行时直接由硬件执行。

动态语言由解释器执行，不产生机器语言代码。

当然，事情后来变得复杂得多。虚拟机（VM）的概念开始流行，它其实只是一个高级的解释器，用软件模拟硬件设备。虚拟机使语言移植到新的硬件平台更容易。因此，VM的输入语言常常是中间语言。例如，一种编程语言（如Java）被编译成中间语言（字节码），然后在VM（JVM）中执行。

### （2）JIT与AOT

JIT编译器在程序执行期间运行，即时编译代码。

JIT编译提供了更快的开发周期，但可能导致执行速度较慢或时快时慢。特别是，JIT编译器启动较慢，因为当程序开始运行时，JIT编译器必须在代码执行之前进行分析和编译。研究表明，如果开始执行需要超过几秒钟，许多人将放弃应用。

AOT编译器在程序创建期间（运行时之前）执行的编译。

在开发过程中AOT编译，开发周期（从更改程序到能够执行程序以查看更改结果的时间）总是很慢。但是AOT编译产生的程序可以更可预测地执行，并且运行时不需要停下来分析和编译。AOT编译的程序也更快地开始执行（因为它们已经被编译）。

一般来说，只有静态语言才适合AOT编译为本地机器代码，因为机器语言通常需要知道数据的类型，而动态语言中的类型事先并不确定。因此，动态语言通常被解释或JIT编译。

### （3）编译与执行Dart

Dart结合了AOT和JIT编译的优点。Dart是同时非常适合AOT编译和JIT编译的少数语言之一（也许是唯一的“主流”语言）。支持这两种编译方式为Dart和（特别是）Flutter提供了显著的优势。

JIT编译在开发过程中使用，编译器速度特别快。然后，当一个应用程序准备发布时，它被AOT编译。因此，借助先进的工具和编译器，Dart具有两全其美的优势：极快的开发周期、快速的执行速度和极短启动时间。

Dart在编译和执行方面的灵活性并不止于此。例如，Dart可以编译成JavaScript，所以浏览器可以执行。这允许在移动应用和网络应用之间重复使用代码。开发人员报告他们的移动和网络应用程序之间的代码重用率高达70％。通过将Dart编译为本地代码，或者编译为JavaScript并将其与node.js一起使用，Dart也可以在服务器上使用。

最后，Dart还提供了一个独立的虚拟机（本质上就像解释器一样），虚拟机使用Dart语言本身作为其中间语言。

Dart可以进行高效的AOT编译或JIT编译、解释或转译成其他语言。Dart编译和执行不仅非常灵活，而且速度特别快。

### （4）有状态热重载

Flutter最受欢迎的功能之一是其极速热重载。在开发过程中，Flutter使用JIT编译器，通常可以在一秒之内重新加载并继续执行代码。只要有可能，应用程序状态在重新加载时保留下来，以便应用程序可以从停止的地方继续。

Flutter的热重载也使得尝试新想法或尝试替代方案变得更加容易，从而为创意提供了巨大的推动力。

### （5）避免卡顿

应用程序速度快很不错，但流畅则更加了不起。即使是一个超快的动画，如果它不稳定，也会看起来很糟糕。但是，防止卡顿可能很困难，因为因素太多。Dart有许多功能可以避免许多常见的导致卡顿的因素。

当然，像任何语言一样，Flutter也可能写出来卡顿的应用程序；Dart通过提高可预测性，帮助开发人员更好地控制应用程序的流畅性，从而更轻松地提供最佳的用户体验。

以60fps运行，使用Flutter创建的用户界面的性能远远优于使用其他跨平台开发框架创建的用户界面。不仅仅比跨平台的应用程序好，而且和最好的原生应用程序一样好。

### （6）AOT编译和“桥”

Dart能AOT编译为本地机器码。预编译的AOT代码比JIT更具可预测性，因为在运行时不需要暂停执行JIT分析或编译。

然而，AOT编译代码还有一个更大的优势，那就是避免了“JavaScript桥梁”。当动态语言（如JavaScript）需要与平台上的本地代码互操作时，它们必须通过桥进行通信，这会导致上下文切换，从而必须保存特别多的状态（可能会存储到辅助存储）。这些上下文切换具有双重打击，因为它们不仅会减慢速度，还会导致严重的卡顿。

注意：即使编译后的代码也可能需要一个接口来与平台代码进行交互，并且这也可以称为桥，但它通常比动态语言所需的桥快几个数量级。另外，由于Dart允许将小部件等内容移至应用程序中，因此减少了桥接的需求。

### （7）抢占式调度、时间分片和共享资源

大多数支持多个并发执行线程的计算机语言（包括Java、Kotlin、Objective-C和Swift）都使用抢占式来切换线程。每个线程都被分配一个时间分片来执行，如果超过了分配的时间，线程将被上下文切换抢占。但是，如果在线程间共享的资源（如内存）正在更新时发生抢占，则会导致竞态条件。

竞态条件具有双重不利，因为它可能会导致严重的错误，包括应用程序崩溃并导致数据丢失，而且由于它取决于独立线程的时序，所以它特别难以找到并修复。在调试器中运行应用程序时，竞态条件常常消失不见。

解决竞态条件的典型方法是使用锁来保护共享资源，阻止其他线程执行，但锁本身可能导致卡顿，甚至更严重的问题（包括死锁和饥饿）。

Dart采取了不同的方法来解决这个问题。Dart中的线程称为isolate，不共享内存，从而避免了大多数锁。isolate通过在通道上传递消息来通信，这与Erlang中的actor或JavaScript中的Web Worker相似。

Dart与JavaScript一样，是单线程的，这意味着它根本不允许抢占。相反，线程显式让出（使用async/await、Future和Stream）CPU。这使开发人员能够更好地控制执行。单线程有助于开发人员确保关键功能（包括动画和转场）完成而无需抢占。这通常不仅是用户界面的一大优势，而且还是客户端——服务器代码的一大优势。

当然，如果开发人员忘记了让出CPU的控制权，这可能会延迟其他代码的执行。然而我们发现，忘记让出CPU通常比忘记加锁更容易找到和修复（因为竞态条件很难找到）。

### （8）对象分配和垃圾回收

另一个严重导致卡顿的原因是垃圾回收。事实上，这只是访问共享资源（内存）的一种特殊情况，在很多语言中都需要使用锁。但在回收可用内存时，锁会阻止整个应用程序运行。但是，Dart几乎可以在没有锁的情况下执行垃圾回收。

Dart使用先进的分代垃圾回收（https://www.cnblogs.com/mingziday/p/4967337.html）和对象分配方案，该方案对于分配许多短暂的对象（对于Flutter这样的反应式用户界面来说非常完美，Flutter为每帧重建不可变视图树）都特别快速。Dart可以用一个指针凹凸分配一个对象（不需要锁）。这也会带来流畅的滚动和动画效果，而不会出现卡顿。

### （9）统一的布局

Dart的另一个好处是，Flutter不会从程序中拆分出额外的模板或布局语言，如JSX或XML，也不需要单独的可视布局工具。以下是一个简单的Flutter视图，用Dart编写： 

```
new Center(child:
  new Column(children: [
    new Text('Hello, World!'),
    new Icon(Icons.star, color: Colors.green),
  ])
)
```

Dart编写的视图及其效果：

Dart 2即将发布，这将变得更加简单，因为new和const关键字变得可选，所以静态布局看起来像是用声明式布局语言编写的：

```
Center(child:
  Column(children: [
    Text('Hello, World!'),
    Icon(Icons.star, color: Colors.green),
  ])
)
```

在Flutter里，界面布局直接通过Dart编码来定义，不需要使用XML或模板语言，也不需要使用可视化设计器之类的工具。配合热重载可以快速开发界面。这比Android的Instant Run和任何类似解决方案不知道要领先多少年。对于大型的应用同样适用。如此快的速度，正是Dart的优势所在。

Dart创建的布局简洁且易于理解，而“超快”的热重载可立即看到结果。这包括布局的非静态部分。

在Flutter中进行布局要比在Android/XCode中快得多。一旦你掌握了它（我花了几个星期），由于很少发生上下文切换，因此会节省大量的开销。不必切换到设计模式，选择鼠标并开始点击，然后想是否有些东西必须通过编程来完成，如何实现等等。因为一切都是程序化的。而且这些API设计得非常好。它很直观，并且比自动布局XML更强大。

例如，下面是一个简单的列表布局，在每个项目之间添加一个分隔线（水平线），以编程方式定义： 

```
return new ListView.builder(itemBuilder: (context, i) {
  if (i.isOdd) return new Divider(); 
  // rest of function
});
```

​       在Flutter中，无论是静态布局还是编程布局，所有布局都存在于同一个位置。新的Dart工具，包括Flutter Inspector和大纲视图（利用所有的布局定义都在代码里）使复杂而美观的布局更加容易。

### （10）开源的Dart

Dart（如Flutter）是完全开源的，具备清楚的许可证，同时也是ECMA标准的。Dart在Google内外很受欢迎。在谷歌内部，它是增长最快的语言之一，并被Adwords、Flutter、Fuchsia和其他产品使用；在谷歌外部，Dart代码库有超过100个外部提交者。

Dart开放性的更好指标是Google之外的社区的发展。例如，我们看到来自第三方的关于Dart（包括Flutter和AngularDart）的文章和视频源源不断。

除了Dart本身的外部提交者之外，公共Dart包仓库中还有超过3000个包，其中包括Firebase、Redux、RxDart、国际化、加密、数据库、路由、集合等方面的库。

### （11）Dart程序员

如果没有很多程序员知道Dart，找到合格的程序员会困难吗？显然不是。Dart是一门难以置信的易学语言。事实上，已经了解Java、JavaScript、Kotlin、C＃或Swift等语言的程序员几乎可以立即开始使用Dart进行编程。

Dart是用于开发Flutter应用程序的语言，很易学。谷歌在创建简单、有文档记录的语言方面拥有丰富的经验，如Go。到目前为止，对我来说，Dart让我想起了Ruby，很高兴能够学习它。它不仅适用于移动开发，也适用于Web开发。

# 二、Dart语言特性

（1）Dart所有的东西都是对象， 即使是数字numbers、函数function、null也都是对象，所有的对象都继承自Object类。

（2）Dart动态类型语言, 尽量给变量定义一个类型，会更安全，没有显示定义类型的变量在debug 模式下会类型会是dynamic(动态的)。

（3）Dart 在running 之前解析你的所有代码，指定数据类型和编译时的常量，可以提高运行速度。

（4）Dart中的类和接口是统一的，类即接口，你可以继承一个类，也可以实现一个类（接口），自然也包含了良好的面向对象和并发编程的支持。

（5）Dart 提供了顶级函数(如：main())。

Dart 没有public、private、protected 这些关键字，变量名以"_"开头意味着对它的lib 是私有的。

（6）没有初始化的变量都会被赋予默认值null。

（7）final的值只能被设定一次。const 是一个编译时的常量，可以通过const 来创建常量值，var c=const[];，这里c 还是一个变量，只是被赋值了一个常量值，它还是可以赋其它值。实例变量可以是final，但不能是 const。

（8）编程语言并不是孤立存在的，Dart也是这样，他由语言规范、虚拟机、类库和工具等组成：

1）SDK：SDK 包含Dart VM、dart2js、Pub、库和工具。

2）Dartium：内嵌Dart VM 的Chromium ，可以在浏览器中直接执行dart 代码。

3）Dart2js：将Dart 代码编译为JavaScript 的工具。

4）Dart Editor：基于Eclipse 的全功能IDE，并包含以上所有工具。支持代码补全、代码导航、快速修正、重构、调试等功能。

# 一、Dart关键字（56个）

## 1.保留字33个（不能使用保留字作为标识符）

| **关键字** | **-**   | **-**  | **-**    |
| ---------- | ------- | ------ | -------- |
| if         | superdo | switch | assert   |
| else       | in      | this   | enum     |
| is         | throw   | true   | break    |
| new        | try     | case   | extends  |
| null       | typedef | catch  | var      |
| class      | false   | void   | const    |
| final      | rethrow | while  | continue |
| finally    | return  | with   | for      |
| default    |         |        |          |

## 2.内置标志符有：（17个）

| **关键字** | **-**      | **-**    | **-**   |
| ---------- | ---------- | -------- | ------- |
| abstract   | deferred   | as       | dynamic |
| covariant  | export     | external | factory |
| get        | implements | import   | library |
| operator   | part       | set      | static  |
| typedef    |            |          |         |

## 3.Dart2相对于Dart1新增的,支持异步功能的关键字有：（6个）

| **关键字** | **-**  | **-** | **-** |
| ---------- | ------ | ----- | ----- |
| async      | async* | await | sync* |
| yield      | yield* |       |       |

## 4.跟java相比，Dart特有的关键字有：（25个）

| **关键字** | **-**   | **-**   | **-**    |
| ---------- | ------- | ------- | -------- |
| deferred   | as      | assert  | dynamic  |
| sync*      | async   | async*  | in       |
| is         | await   | export  | library  |
| external   | typedef | factory | operator |
| var        | part    | const   | rethrow  |
| covariant  | set     | yield   | get      |
| yield*     |         |         |          |

 

# 二、变量和常量

## 1.变量的声明

（1）Dart语言本质上是动态类型语言，类型是可选的，可以使用var、Object 或dynamic 关键字声明变量。

（2）Dart 没有byte、char 和float，int、double 都是64 位。

```
bool done = true;
int num = 2;
double x = 3.14;
```

（3）可以使用类型推断var声明变量，也可以使用类型来直接声明变量。

```
var done = true;
var num = 2;
var x = 3.14;
```

（4）除基本类型外，变量存储的是引用，大多数情况，我们不会去改变一个变量的类型，但是一个变量也可以被赋予不同类型的对象。

（5）Dart 里的String 跟Java 中的一样，是不可变对象

（6）默认值，未初始化的变量的初始值为null（包括数字），因此数字、字符串都可以调用各种方法。

测试 数字类型的初始值是什么?

//我们先声明一个int类型的变量

```
int intDefaultValue;
```

//assert 是语言内置的断言函数，仅在检查模式下有效

//在开发过程中，除非条件为真，否则会引发异常。（断言失败则程序立即终止）

```
assert(intDefaultValue == null);
```

//打印结果为null, 说明数字类型初始化值为null

```
print(intDefaultValue);
```

（7）使用Object或dynamic关键字

Dart 里所有东西都是对象。所有这些对象的父类就是Object。

```
Object o = 'string';
o = 42;
o.toString();   // 我们只能调用 Object 支持的方法
 
dynamic obj = 'string';
obj['foo'] = 4;  // 可以编译通过，但在运行时会抛出 NoSuchMethodError
```

注：Object 和dynamic 都使得我们可以接收任意类型的参数，但两者的区别非常的大。

使用Object 时，我们只是在说接受任意类型，我们需要的是一个Object。类型系统会保证其类型安全。

使用dynamic 则是告诉编译器，我们知道自己在做什么，不用做类型检测。当我们调用一个不存在的方法时，会执行noSuchMethod() 方法，默认情况下（在Object 里实现）它会抛出NoSuchMethodError。

（8）类型检测和类型转换

为了在运行时检测进行类型检测，Dart提供了一个关键字is，使用该关键字后后续代码中使用变量不需要强制转换。

```
dynamic obj = <String, int>{};
if (obj is Map<String, int>) {
  // 进过类型判断后，Dart 知道 obj 是一个 Map<String, int>，
  // 所以这里不用强制转换 obj 的类型，即使我们声明 obj 为 Object。
  obj['foo'] = 42;
}
```

如果需要类型转换可以使用关键字as进行类型的强制转换，但为了进来更安全的转换，更推荐使用is

```
var map = obj as Map<String, int>;
```

## 二、常量的声明

如果您从未打算更改一个变量，那么使用final 或const，不是var，也不是一个类型。

（1）final 跟Java 里的final 一样，表示一个运行时常量（在程序运行的时候赋值，赋值后值不再改变）。final的顶级或类变量在第一次使用时被初始化。

（2）const 表示一个编译时常量，在程序编译的时候它的值就确定了。Const变量是隐式的final

（3）final和const的区别

​       I：初始化时机

final 是惰性初始化，即在运行时第一次使用前才初始化。

const 是在编译时就确定值了。    

II：初始化内容

final 要求变量只能初始化一次，并不要求赋的值一定是编译时常量，可以是常量也可以不是。

 const 要求在声明时初始化，并且赋值必需为编译时常量。

 

```
//被final修饰的变量的值无法被改变
final test1 = "test";
//这样写会提示'test1', a final variable, can only be set once
test1 = "test1";
  
//被const修饰的变量不能被重新赋值
const test2 = 20.02;
//这样写会提示 Constant variables can't be assigned a value
test2 = 23.33;
```

（4）被final或者const修饰的变量，变量类型可以省略。建议指定数据类型。

```
final visible = false;
final amount = 100;
final y = 2.7;
 
const debug = true;
const sum = 42;
const z = 1.2;
```

（5）注意：flnal 或者const 不能和var 同时使用

```
// Members can't be declared to be both 'const' and 'var'
 const var String outSideName = 'Bill';
 
 // Members can't be declared to be both 'final' and 'var'
 final var String name = 'Lili';
```

（6）常量如果是类级别的，请使用static const

```
const value = "";
class Test{
         //类级别的常量
  static const name = "test";
 
  static main(){
    //这里会报错：Undefined name 'static'
    //static类型的变量是属于类的所以在类里面，方法之外
    static const name = "test";
  }
}
```

（7）const也可以指向一个不可变引用

```
//注意：[] 创建的是一个空的list集合
// const[] 创建一个空的、不可变的列表（EIL）
var varList = const [];     //varList 当前时一个EIL
final finalList = const []; //finalList一直是EIL
const constList = const []; //constList是一个编译时常量的EIL
 
//可以更改非final、非const变量的值
//即使它曾经具有const值也可以改变
varList = [111, 222, 333];
 
// 不能更改final变量或const变量的值
// 这样写，编译器提示：a final variable, can only be set once
// finalList = [];
// 这样写，编译器提示：Constant variables can't be assigned a value
// constList = [];
```

（8）在常量表达式中，该运算符的操作数必须为'bool'、'num'、'String'或'null', const常量必须用conat类型的值初始化。

```
const String outSideName = 'Bill';
final String outSideFinalName = 'Alex';
const String outSideName2 = 'Tom';
 
const aConstList = const ['1', '2', '3'];
 
// In constant expressions, operands of this operator must be of type 'bool', 'num', 'String' or 'null'
// 在常量表达式中，该运算符的操作数必须为'bool'、'num'、'String'或'null'。
const validConstString = '$outSideName $outSideName2 $aConstList';
 
// Const variables must be initialized with a constant value
// const常量必须用conat类型的值初始化
const validConstString = '$outSideName $outSideName2 $outSideFinalName';
 
var outSideVarName='Cathy';
// Const variables must be initialized with a constant value.
// const常量必须用conat类型的值初始化
const validConstString = '$outSideName $outSideName2 $outSideVarName';
 
// 正确写法
const String outSideConstName = 'Joy';
const validConstString = '$outSideName $outSideName2 $outSideConstName';
```

（9）只要任何插值表达式是一个计算结果为null或数字，字符串或布尔值的编译时常量，那么文字字符串就是编译时常量。

```
//这些是常量字符串
const aConstNum = 0;
const aConstBool = true;
const aConstString = 'a const string'; 
//这些不是常量字符串
var aNum = 0;
var aBool = true;
var aString = 'a string'; 
//编译通过
const validConstString = '$aConstNum $aConstBool $aConstString';
var validString = '$aNum $aBool $aString';
var invalidString = '$aNum $aBool $aConstString';
//编译器报错
//报错：Const variables must be initialized with a constant value
//const常量必须用const类型的值初始化
const invalidConstString = '$aConstNum $aConstBool $aNum';
```

# 三、特殊数据类型

Dart中支持以下特殊类型：

## 1.numbers 数字

（1）num是数字类型的父类，有两个子类int 和double。

（2）int 根据平台的不同，整数值不大于64位。在Dart VM上，值可以从-263到263 - 1，编译成JavaScript的Dart使用JavaScript代码，允许值从-253到253 - 1。

（3）double 64位（双精度）浮点数，如IEEE 754标准所规定。

（4）num类型包括基本的运算符，如+,-,/和*，位运算符，如>>，在int类中定义。

（5）如果num和它的子类没有你要找的东西，math库可能会找到。比如你会发现abs(),ceil()和floor()等方法。

## 2.字符串String

（1）字符串赋值的时候，可以使用单引号，也可以使用双引号。

（2）单引号或者双引号里面嵌套使用引号。

（3）字符串也是对象

```
var str = ' foo';
var str2 = str.toUpperCase();
var str3 = str.trim();
```

（4）检测两个String 的内容是否一样时，我们使用== 进行比较。

```
assert(str == str2);
```

（5）要测试两个对象是否是同一个对象（indentity test），使用identical 函数。

```
assert(!identical(str, str2));
```

（6）多个字符串相邻中间的空格问题：

除了单引号嵌套单引号或者双引号嵌套双引号不允许出现空串之外，其余的几种情况都是可以运行的。

```
// 这个会报错
//String blankStr1 = 'hello''''world';
// 这两个运行正常
String blankStr2 = 'hello'' ''world'; //结果： hello world
String blankStr3 = 'hello''_''world'; //结果： hello_world
 
// 这个会报错
//String blankStr4 = "hello""""world";
// 这两个运行正常
String blankStr5 = "hello"" ""world"; //结果： hello world
String blankStr6 = "hello""_""world"; //结果： hello_world
 
//单引号里面有双引号，混合使用运行正常
String blankStr7 = 'hello""""world'; //结果： hello""""world
String blankStr8 = 'hello"" ""world'; //结果： hello"" ""world
String blankStr9 = 'hello""_""world'; //结果： hello""_""world
 
//双引号里面有单引号，混合使用运行正常
String blankStr10 = "hello''''world"; //结果： hello''''world
String blankStr11 = "hello'' ''world"; //结果： hello'' ''world
String blankStr12 = "hello''_''world"; //结果： hello''_''world
```

（7）字符串拼接，

1）相邻字符串

```
//直接把相邻字符串写在一起，就可以连接字符串了。
String connectionStr1 =  '字符串连接'
'甚至可以在'
'换行的时候进行。';
```

 2）+

```
//用+把相邻字符串连接起来。
String connectionStr2 =  '字符串连接'
  + '甚至可以在'
  + '换行的时候进行。';
```

 3）三引号（'''...'''，"""..."""表示多行字符串）

```
//使用单引号或双引号的三引号：
String connectionStr3 = ''' 
  你可以创建
  像这样的多行字符串。
  ''' ;
 
String connectionStr4 = """这也是一个
  多行字符串。""";
```

（8）关于转义符号的使用

声明raw字符串（前缀为r），在字符串前加字符“r”，或者在\前面再加一个\，

可以避免“\”的转义作用，在正则表达式里特别有用

举例如下：

```
print(r"换行符：\n"); //这个结果是 换行符：\n
print("换行符：\\n"); //这个结果是 换行符：\n
print("换行符：\n");  //这个结果是 换行符：
```

（9）插值表达式

可以使用${表达式}将表达式的值放入字符串中。如果表达式是标识符，则可以跳过{}。

```
String replaceStr1 = '字符串连接';
print('$replaceStr1'
    + '甚至可以在换行的时候进行。' == '字符串连接'
    + '甚至可以在换行的时候进行。');
 
String replaceStr2 = 'Android Studio';
print('你知道' +
    '${replaceStr2.toUpperCase()}'
      + '最新版本是多少吗？' ==
'你知道ANDROID STUDIO最新版本是多少吗？');
```

 

## 3.booleans 布尔

（1）Dart 是强bool 类型检查，只有bool 类型的值是true 才被认为是true。

（2）只有两个对象具有bool类型：true和false，它们都是编译时常量。

（3）Dart的类型安全意味着您不能使用if（nonbooleanValue） 或assert（nonbooleanValue） 等代码, 相反Dart使用的是显式的检查值。

（4）assert 是语言内置的断言函数，仅在检查模式下有效

在开发过程中， 除非条件为真，否则会引发异常。(断言失败则程序立刻终止)。

```
  // 检查是否为空字符串
  var fullName = '';
  assert(fullName.isEmpty);
  // 检查0
  var hitPoints = 0;
  assert(hitPoints <= 0);
  // 检查是否为null
  var unicorn;
  assert(unicorn == null);
  // 检查是否为NaN
  var iMeantToDoThis = 0 / 0;
  assert(iMeantToDoThis.isNaN);
```

## 4.lists (also known as arrays) list集合（也称为数组）

在Dart中，数组是List对象，因此大多数人只是将它们称为List。Dart list文字看起来像JavaScript数组文字

### （1）使用构造函数创建对象

使用List的构造函数，也可以添加int参数，表示List固定长度，不能进行添加 删除操作

```
// 跟 var list = new List<int>(); 一样
var list = List<int>();
list.add(1);
list.add(2);
```

### （2）通过字面量创建对象

推荐使用字面量方式创建对象，list的泛型参数可以从变量定义推断出来。

```
var list2 = [1, 2];
// 没有元素，显式指定泛型参数为 int
var list3 = <int>[];
list3.add(1);
list3.add(2);
```

### （3）常量list

```
var list4 = const[1, 2];
// list4 指向的是一个常量，我们不能给它添加元素（不能修改它）
list4.add(3);       // error
// list4 本身不是一个常量，所以它可以指向另一个对象
list4 = [4, 5];     // it's fine
const list5 = [1, 2];
// 相当于 const list5 = const[1, 2];
list5.add(3);       // error
```

### （4）遍历list

```
// 因为语音设计时就考虑到了这个需求，in 在 Dart 里是一个关键字
var list6 = [1, 3, 5, 7];
for (var e in list6) {
  print(e);
}
```

### （5）list中的方法

```
var fruits = new List(); 
```

 1）添加元素

```
 fruits.add('apples');
```

 2）添加多个元素

```
 fruits.addAll(['oranges', 'bananas']);
 List subFruits = ['apples', 'oranges', 'banans'];
```

3）添加多个元素

```
 fruits.addAll(subFruits);
```

4）输出：[apples, oranges, bananas, apples, oranges, banans]

```
 print(fruits);
```

5）获取List的长度

```
 print(fruits.length);
```

6）获取第一个元素

```
 print(fruits.first);
```

7）获取元素最后一个元素

```
 print(fruits.last);
```

8）利用索引获取元素

```
 print(fruits[0]);
```

9）查找某个元素的索引号

```
 print(fruits.indexOf('apples'));
```

10）删除指定位置的元素，返回删除的元素

```
 print(fruits.removeAt(0));
```

11）删除指定元素,成功返回true，失败返回false，如果集合里面有多个“apples”, 只会删除集合中第一个改元素

```
 fruits.remove('apples');
```

12）删除最后一个元素，返回删除的元素

```
 fruits.removeLast();
```

 

13）删除指定范围(索引)元素，含头不含尾

```
 fruits.removeRange(start,end);
```

14）删除指定条件的元素(这里是元素长度大于6)

```
 fruits.removeWhere((item) => item.length >6)；
```

15）删除所有的元素

```
 fruits.clear();
```

注：

I：可以直接打印list包括list的元素，list也是一个对象。但是java必须遍历才能打印list，直接打印是地址值。

II：和java一样list里面的元素必须保持类型一致，不一致就会报错。

III：和java一样list的角标从0开始。

IV：如果集合里面有多个相同的元素“X”,只会删除集合中第一个改元素

## 5.maps map集合

1.一般来说，map是将键和值相关联的对象。键和值都可以是任何类型的对象。

每个键只出现一次，但您可以多次使用相同的值。

2.初始化Map方式一： 直接声明，用{}表示，里面写key和value，每组键值对中间用逗号隔开。

```
// Two keys in a map literal can't be equal.
 // Map companys = {'Alibaba': '阿里巴巴', 'Tencent': '腾讯', 'baidu': '百度', 'Alibaba': '钉钉', 'Tenect': 'qq-music'};
 
 Map companys = {'Alibaba': '阿里巴巴', 'Tencent': '腾讯', 'baidu': '百度'};
 // 输出：{Alibaba: 阿里巴巴, Tencent: 腾讯, baidu: 百度}
 print(companys);
```

3.创建Map方式二：先声明，再去赋值。

（1）单引号

```
Map schoolsMap = new Map();
 schoolsMap['first'] = '清华';
 schoolsMap['second'] = '北大';
 schoolsMap['third'] = '复旦';
 // 打印结果 {first: 清华, second: 北大, third: 复旦}
 print(schoolsMap);
```

（2）双引号

```
 var fruits = new Map();
 fruits["first"] = "apple";
 fruits["second"] = "banana";
 fruits["fifth"] = "orange";
 //换成双引号,换成var 打印结果 {first: apple, second: banana, fifth: orange}
 print(fruits);
```

（3）常量

```
var map2 = const {
  'foo': 2,
  'bar': 4,
};
```

（4）简化与类型推断

```
var map3 = <String, String>{};
```

（5）指定类型

```
var aMap = new Map<int, String>();
```

4.Map API

```
var aMap = new Map<int, String>();
```

（1）Map的赋值，中括号中是Key，这里可不是数组

```
aMap[1] = '小米';
```

（2）Map中的键值对是唯一的，同Set不同，第二次输入的Key如果存在，Value会覆盖之前的数据

```
aMap[1] = 'alibaba';
```

（3）map里面的value可以相同

```
aMap[2] = 'alibaba';
```

（4）map里面value可以为空字符串

```
aMap[3] = '';
```

（5）map里面的value可以为null

```
aMap[4] = null;
```

（6）检索Map是否含有某Key

```
assert(aMap.containsKey(1));
```

（7）删除某个键值对

```
aMap.remove(1); 
```

（8）对应的key 不存在时，返回null

```
if (map['foobar'] == null) {
  print('map does not contain foobar');
}
```

注：

I：map的key类型不一致也不会报错。

II：添加元素的时候，会按照你添加元素的顺序逐个加入到map里面，哪怕你的key，比如分别是1,2,4，看起来有间隔，事实上添加到map的时候是{1:value,2:value,4:value}这种形式。

III：map里面的key不能相同。但是value可以相同,value可以为空字符串或者为null。

## 6.Set

```
var set = Set<String>();
set.add('foo');
set.add('bar');
assert(set.contains('foo'));
```

我们只能通过Set 的构造函数创建实例。

## 7..runes (for expressing Unicode characters in a string) 字符（用于在字符串中表示Unicode字符）

## 8..symbols 符号

# 四、运算符

| **描述**       | **操作符**                               |      |      |
| -------------- | ---------------------------------------- | ---- | ---- |
| 一元后置操作符 | expr++ expr-- () [] . ?.                 |      |      |
| 一元前置操作符 | expr !expr ~expr ++expr --expr           |      |      |
| 乘除           | * / % ~/                                 |      |      |
| 加减           | + -                                      |      |      |
| 位移           | << >>                                    |      |      |
| 按位与         | &                                        |      |      |
| 按位或         |                                          |      |      |
| 按位异或       | ^                                        |      |      |
| 逻辑与         | &&                                       |      |      |
| 逻辑或         |                                          |      |      |
| 关系和类型判断 | >= > <= < as is is!                      |      |      |
| 等             | == !=                                    |      |      |
| 如果为空       | ??                                       |      |      |
| 条件表达式     | expr1 ? expr2 : expr3                    |      |      |
| 赋值           | = *= /= ~/= %= += -= <<= >>= &= ^= = ??= |      |      |
| 级联           | ..                                       |      |      |

 

# 五、流程控制语句

常见的if/else，do while，while 和switch 在Dart 里面都支持。switch 也支持String 和enum。

## 1.条件语句

```
var success = true;
if (success) {
  print('done');
} else {
  print('fail');
}
```

## 2.循环语句

### （1）for循环

```
for (var i = 0; i < 5; ++i) {
  print(i);
}
```

### （2）do while循环

```
var sum = 0;
var j = 1;
do {
  sum += j;
  ++j;
} while (j < 5);
```

### （3）while循环

```
while (sum-- > 0) {
  print(sum);
}
```

## 3.switch语句

```
var type = 1;
switch (type) {
  case 0:
    // ...
    break;
  case 1:
    // ..
    break;
  case 2:
    // ...
    break;
  default:
    // ...
    break;
}
```

## 4.三元表达式

三目表达式：condition? expr1:expr2

??运算符：expr1:expr2

例子：

```
void main(List<String> args) {
  int gender = 1;
  String str = gender == 0 ? "Male" : "Frmale=$gender";
  print(str);
 
  String a;
  String b = "java";
  String c = a ?? b;
  //a为空的时候打印b，a不为空是打印a
  print(c);
 
  a = "huang";
  b = "java";
  c = a ?? b;
  print(c);
}
结果：
Frmale=1
java
huang
```

# 六、异常

## 1.抛出异常throw

### （1）抛出固定类型的异常

```
  throw new FormatException('Expected at least 1 section');
```

### （2）抛出任意类型的异常

```
 throw 'Out of llamas!';
```

### （3）使用表达式

因为抛出异常属于表达式，可以将throw语句放在=>语句中，或者其它可以出现表达式的地方

```
 distanceTo(Point other) =>
throw new UnimplementedError();
```

## 2.捕获异常catch

将可能出现异常的代码放置到try语句中，可以通过on语句来指定需要捕获的异常类型，使用catch来处理异常。

```
 try {
    breedMoreLlamas();
 } on OutOfLlamasException { // 捕获特定类型的异常，但不需要这个对象
    // A specific exception
    buyMoreLlamas();
 } on Exception catch (e) {// 捕获特定类型的异常
    // Anything else that is an exception
    print('Unknown exception: $e');
 } catch (e, s) {// 捕获所有异常
    print('Exception details:\n $e');
    print('Stack trace:\n $s');
 }
```

注：

跟Java 不同的是，Dart 可以抛出任意类型的对象：

throw 42;

## 3.异常链rethrow

rethrow语句用来处理一个异常，同时希望这个异常能够被其它调用的部分使用。

 

```
 final foo = '';
 void misbehave() {
    try {
      foo = "1";
    } catch (e) {
      print('2');
      rethrow;// 如果不重新抛出异常，main函数中的catch语句执行不到
    }
 }
 void main() {
    try {
      misbehave();
    } catch (e) {
      print('3');
    }
 }
```

## 4. finally

Dart的finally用来执行那些无论异常是否发生都执行的操作。

```
  final foo = '';
 
  void misbehave() {
    try {
      foo = "1";
    } catch (e) {
      print('2');
    }
  }
 
  void main() {
    try {
      misbehave();
    } catch (e) {
      print('3');
    } finally {
      print('4'); // 即使没有rethrow最终都会执行到
    }
  }
```

 

# 七、函数Function

## 1.普通函数 

最普通的函数看起来和Java一样

```
int foo(int x) {
  return 0;
}
```

## 2.main 函数

main 函数是一个dart应用的入口。main函数返回类型是void，可选参数作为一个List<String>类型传递进来。

```
// 调用方法：
// dart demo.dart 1 test
void main(List<String> arguments) {
  print(arguments);
  assert(arguments.length == 2);
  assert(int.parse(arguments[0]) == 1);
  assert(arguments[1] == 'test');
}
```

## 3.可选参数

（1）可选的命名参数, 定义函数时，使用{param1, param2, …}，用于指定命名参数。例如：

```
//设置[bold]和[hidden]标志
 void enableFlags({bool bold, bool hidden}) {
      // ... 
 }  
 enableFlags(bold: true, hidden: false);
void main() {
  print(foo(2));
  print(foo(1, 2));
}
```

（2）可选的位置参数，用[]它们标记为可选的位置参数：

注：可选参数可能为null（默认值）

```
String say(String from, String msg, [String device]) {
      var result = '$from says $msg';
      if (device != null) {
         result = '$result with a $device';
      }
      return result;
  }
```

（3）下面是一个不带可选参数调用这个函数的例子：

 

```
  say('Bob', 'Howdy'); //结果是： Bob says Howdy
```

（4）下面是用第三个参数调用这个函数的例子：

```
  say('Bob', 'Howdy', 'smoke signal'); //结果是：Bob says Howdy with a smoke signal
```

## 4.默认参数

（1）函数可以使用=为命名参数和位置参数定义默认值。默认值必须是编译时常量。如果没有提供默认值，则默认值为null。

（2）下面是为命名参数设置默认值的示例:

```
  // 设置 bold 和 hidden 标记的默认值都为false
  void enableFlags2({bool bold = false, bool hidden = false}) {
       // ...
  }
  // 调用的时候：bold will be true; hidden will be false.
  enableFlags2(bold: true);
```

（3）下一个示例显示如何为位置参数设置默认值：

```
String say(String from, String msg,
    [String device = 'carrier pigeon', String mood]) {
        var result = '$from says $msg';
        if (device != null) {
            result = '$result with a $device';
        }
        if (mood != null) {
            result = '$result (in a $mood mood)';
        }
        return result;
 }
 //调用方式：
 say('Bob', 'Howdy'); //结果为：Bob says Howdy with a carrier pigeon;
```

（4）您还可以将list或map作为默认值传递。下面的示例定义一个函数doStuff()，该函数指定列表参数的默认list和gifts参数的默认map。

```
 // 使用list 或者map设置默认值
 void doStuff(
     {List<int> list = const [1, 2, 3],
     Map<String, String> gifts = const {'first': 'paper', 
     'second': 'cotton', 'third': 'leather'
    }}) {
     print('list:  $list');
     print('gifts: $gifts');
 }
```

## 5.具名参数（named parameters）

（1）具名参数的顺序可以是任意的

```
void main() {
  print(foo(x: 1, y: 2));
  // 具名参数的顺序可以是任意的
  print(foo(y: 3, x: 4));
  // 所有的具名参数都是可选的，这个调用是合法的，但它会导致 foo() 在运行时抛异常
  print(foo());
}
int foo({int x, int y}) {
  return x + y;
}
```

（2）具名参数也可以有默认参数：

```
void main() {
  print(foo(x: 1, y: 2));
  print(foo());
}
 
int foo({int x = 0, int y = 0}) {
  return x + y;
}
```

## 6. 注解@required

如果想告诉用户某个具名参数是必须的，可以使用注解@required：

```
int foo({@required int x, @required int y}) {
  return x + y;
}
```

@required 是meta 包里提供的API，更多的信息读者可以查看https://pub.dartlang.org/packages/meta。

## 7.内部函数

函数还可以在函数的内部定义：

```
// typedef 在 Dart 里面用于定义函数类型的别名
typedef Adder = int Function(int, int);
Adder makeAdder(int extra) {
  int adder(int x, int y) {
    return x + y + extra;
  }
  return adder;
}
void main() {
  var adder = makeAdder(2);
  print(adder(1, 2));
}
// 结果： 5
```

## 8.lambda表达式

简单的函数可以使用lambda表达式：

```
typedef Adder = int Function(int, int);
 
Adder makeAdder(int extra) {
  return (int x, int y) {
    return x + y + extra;
  };
  // 如果只有一个语句，我们可以使用下面这种更为简洁的形式
  // return (int x, int y) => x + y + extra;
}
void main() {
  var adder = makeAdder(2);
  print(adder(1, 2));
}
```

## 9.自动推断

Dart 里面不仅变量支持类型推断，lambda的参数也支持自动推断。上面的代码还可以进一步简化为：

```
typedef Adder = int Function(int, int);
 
Adder makeAdder(int extra) {
  // 我们要返回的类型是 Adder，所以 Dart 知道 x, y 都是 int
  return (x, y) => x + y + extra;
}
 
void main() {
  var adder = makeAdder(2);
  print(adder(1, 2));
}
```

## 10.匿名函数

大多数函数都能被命名为匿名函数，如main() 或printElement()。 一个匿名函数看起来类似于一个命名函数- 0或更多的参数，在括号之间用逗号和可选类型标注分隔。

（1）匿名函数可赋值给变量，通过变量进行调用, 例如，可以从集合中添加或删除它。

（2）匿名函数可在其他方法中直接调用或传递给其他方法

（3）定义：

([[Type] param1[, …]]) { 

 codeBlock; 

};

（参数1,参数2,....）{

​       方法体...

​      return 返回值

 }

（4）下面的示例定义了一个具有无类型参数的匿名函数item，该函数被list中的每个item调用，输出一个字符串，该字符串包含指定索引处的值。

```
 var list = ['apples', 'bananas', 'oranges'];
 list.forEach((item) {
    print('${list.indexOf(item)}: $item');
 });
```

（5）如果函数只包含一条语句，可以使用箭头符号=>来缩短它, 比如上面的例子可以简写成：

```
 list.forEach((item) => print('${list.indexOf(item)}: $item'));
```

## 11.返回值

所有函数都返回一个值，如果没有指定返回值，则语句return null，隐式地附加到函数体。

```
  foo() {}
  assert(foo() == null);
```

## 12.关于重载

Dart语言是不支持方法重载的。但是它支持命名构造函数：

```
class Test{
  int x;
  int y;
  Test(){}
  Test.X(int x){
    this.x = x;
  }
  Test.Y(int y){
    this.y = y;
  } 
  Test.XY(int x, int y){
    this.x = x;
    this.y = y;
  }
  @override
  String toString() {
    if (x != null && y != null) {
      return "x: " + x.toString() + " y: " + y.toString();
    }
    if (x != null) {
      return "x: " + x.toString();
    }
    if (y != null) {
      return "y: " + y.toString();
    }
    return super.toString();
  }
}
```

我们在主函数中创建Test对象：

```
main(List<String> arguments) {
 Test testX = new Test.X(1);
 print(testX.toString());
 
 Test testY = new Test.Y(2);
 print(testY.toString());
 
 Test testXY = new Test.XY(3, 4);
 print(testXY.toString());
}
```

## 13.函数别名

https://juejin.im/post/5a436804f265da432c24218a

当看到用typedef定义函数别名的时候，不自觉的想到了函数指针

```
typedef int Add(int a, int b);
int Subtract(int a, int b) => a - b;
 
void main(){
  print(Substract is Function);
  print(Substract is Add);
}
```

上面代码的命名感觉有点误导人的感觉，如果两个函数的参数和返回值都一样，那么is操作符就会返回true

## 14.函数闭包

dart的闭包就是函数对象，其实跟JavaScript的闭包函数差不多，理论请参考JavaScript的闭包函数https://www.cnblogs.com/yunfeifei/p/4019504.html

一个 闭包 是一个方法对象，不管该对象在何处被调用， 该对象都可以访问其作用域内 的变量。方法可以封闭定义到其作用域内的变量。

在一下示例中，makeAdder()捕获了变量addBy。不管返回的函数在哪里被调用，它都可以使用addBy。

```
/// 返回一个把 addBy 作为参数的函数
Function makeAdder(num addBy) {
     return (num i) => addBy + 1;
}
main() {
     // 创建一个加2的函数
     var add2 = makeAdder(2);
     // 创建一个加4的函数
     var add4 = makeAdder(4);
     assert(add2(3) == 5);
     assert(add4(3) == 7);
}
```

## 15.函数是对象

（1）可以将一个函数作为参数传递给另一个函数。

```
  void printElement(int element) {
     print(element);
  }
  var list = [1, 2, 3];
  // 把 printElement函数作为一个参数传递进来
  list.forEach(printElement);
```

（2）您也可以将一个函数分配给一个变量。

```
  var loudify = (msg) => '!!! ${msg.toUpperCase()} !!!';
  assert(loudify('hello') == '!!! HELLO !!!');
```

## 16.级联调用

代码中的.. 语法为 级联调用（cascade）。使用级联调用语法，允许在同一个对象上进行一系列操作。可以同时访问该对象上的函数和字段。

（1）web 应用的main() 方法：

```
void main() {
  querySelector("#sample_text_id")
    ..text = "Click me!"
    ..onClick.listen(reverseText);
}
```

上述例子相对于：

```
 var button = querySelector('#confirm');
 button.text = 'Confirm';
 button.classes.add('important');
 button.onClick.listen((e) => window.alert('Confirmed!'));
```

（2）级联符号也可以嵌套使用。 例如：

```
  final addressBook = (AddressBookBuilder()
   ..name = 'jenny'
   ..email = 'jenny@example.com'
   ..phone = (PhoneNumberBuilder()
         ..number = '415-555-0100'
         ..label = 'home')
       .build())
   .build();   
```

（3）当返回值是void时不能构建级联。 例如，以下代码失败：

```
var sb = StringBuffer();
sb.write('foo') // 返回void
  ..write('bar'); // 这里会报错
```

注意： 严格地说，级联的..符号不是操作符。它只是Dart语法的一部分。

# 八、类

## 1.对象

（1）Dart 是一种面向对象的语言，并且支持基于mixin的继承方式。

（2）Dart 语言中所有的对象都是某一个类的实例,所有的类有同一个基类--Object。

（3）基于mixin的继承方式具体是指：一个类可以继承自多个父类。

（4）使用new语句来构造一个类，构造函数的名字可能是ClassName，也可以是ClassName.identifier（命名构造函数）， 例如：

  1）Create a Point using Point().

```
  var p1 = new Point(2, 2);
```

  2）Create a Point using Point.fromJson().

```
  var jsonData = JSON.decode('{"x":1, "y":2}');
  var p2 = new Point.fromJson(jsonData);
```

（5）使用.（dot）来调用实例的变量或者方法。

```
  var p = new Point(2, 2);
  //设置p实例中的y值
  p.y = 3;
  //获取y值
  assert(p.y == 3);
  // 执行p实例的distanceTo() 方法
  num distance = p.distanceTo(new Point(4, 4));
```

（6）使用?.来确认前操作数不为空, 常用来替代. , 避免左边操作数为null引发异常。

```
 // 如果p不为空则设置它的y值为4
 p?.y = 4;
```

（7）使用const替代new来创建编译时的常量构造函数。

```
var p = const ImmutablePoint(2, 2);
```

（8）使用runtimeType方法，在运行中获取对象的类型。该方法将返回Type 类型的变量。

```
print('The type of a is ${a.runtimeType}');
```

## 2实例化变量(Instance variables) 

（1）在类定义中，所有没有初始化的变量都会被初始化为null。

```
 class Point {
    num x; // 声明变量x,初始化值为null
    num y; // 声明变量y,初始化值为null
    num z = 0; //声明变量z,初始化值为null
 }
```

（3）Dart会为类中定义的所有变量隐式定义定义setter 方法，针对非空的变量会额外增加getter 方法。

```
 class Point {
    num x;
    num y;
 }
 main() {
    var point = new Point();
    point.x = 4;          // 使用x的setter方法
    assert(point.x == 4); // 使用x的getter方法
    assert(point.y == null); // 默认值为空
 }
```

## 3. 构造函数(Constructors)

### （1）定义

声明一个和类名相同的函数，来作为类的构造函数。

```
class Point {
     num x;
     num y;
     Point(num x, num y) {
        // 可以优化这种初始化赋值
        this.x = x;
        this.y = y;
     }
  }
```

### （2）简化

this关键字指向了当前类的实例, 上面的代码可以简化为：

```
class Point {
    num x;
    num y;
    //在构造函数体运行之前，用于设置x和y的句法糖
    Point(this.x, this.y);
 }
```

### （3）默认构造函数

如果你不声明一个构造函数，系统会提供默认构造函数。默认构造函数没有参数，它将调用父类的无参数构造函数。

### （4）构造函数不能继承

子类不继承父类的构造函数。子类只有默认构造函数。（无参数，没有名字的构造函数）。

### （5）命名的构造函数(Named constructors)

1）使用命名构造函数从另一类或现有的数据中快速实现构造函数。

```
class Point {
   num x;
   num y;
   Point(this.x, this.y);
   // 命名构造函数Named constructor
   Point.fromJson(Map json) {
     x = json['x'];
     y = json['y'];
   }
}
```

2）构造函数不能被继承，父类中的命名构造函数不能被子类继承。如果想要子类也拥有一个父类一样名字的构造函数，必须在子类是实现这个构造函数。

### （6）初始化列表（initializer list）

除了调用父类的构造函数，也可以通过初始化列表在子类的构造函数体前（大括号前）来初始化实例的变量值，使用逗号,分隔。如下所示：

```
class Point {
   num x;
   num y;
 
   Point(this.x, this.y);
   // 初始化列表在构造函数运行前设置实例变量。
   Point.fromJson(Map jsonMap)
   : x = jsonMap['x'],
     y = jsonMap['y'] {
      print('In Point.fromJson(): ($x, $y)');
   }
 }
```

注意：上述代码，初始化程序无法访问this 关键字。

### （7）调用父类的非默认构造函数

1）默认情况下，调用父类构造函数特点： 

I：子类只能调用父类的无名，无参数的构造函数; 

II：父类的无名构造函数会在子类的构造函数前调用; 

III：如果initializer list 也同时定义了，则会先执行initializer list 中的内容

IV：然后在执行父类的无名无参数构造函数

V：最后调用子类自己的无名无参数构造函数。

2）调用父类非默认构造函数流程：

I：先执行子类initializer list，但只初始化自己的成员变量

II：初始化父类的成员变量

III：执行父类构造函数的函数体（父类无参数构造函数）

IV：执行子类构造函数的函数体（主类无参数构造函数）

基于这个初始化顺序，推荐是把super() 放在initializer list 的最后。此外，在initializer list 里不能访问this（也就是说，只能调用静态方法）。

3）父类中不提供无名无参构造函数

如果父类不显式提供无名无参数的构造函数，在子类中必须手打调用父类的一个构造函数。这种情况下，调用父类的构造函数的代码放在子类构造函数名后，子类构造函数体前，中间使用:(colon) 分割。

```
class Person {
   String firstName;
   Person.fromJson(Map data) {
       print('in Person');
   }
}
class Employee extends Person {
   // 父类没有无参数的非命名构造函数，必须手动调用一个构造函数     
   //super.fromJson(data)
   Employee.fromJson(Map data) : super.fromJson(data) {
      print('in Employee');
   }
}
main() {
   var emp = new Employee.fromJson({});
 
   // Prints:
   // in Person
   // in Employee
   if (emp is Person) {
     // Type check
     emp.firstName = 'Bob';
   }
   (emp as Person).firstName = 'Bob';
}
```

4）在调用父类构造函数前会检测参数，这个参数可以是一个表达式，如函数调用：

```
class Employee extends Person {
  // ...
  Employee() : super.fromJson(findDefaultData());
}
```

注：父类构造函数的参数不能访问this 。例如，参数可调用静态方法但是不能调用实方法。

### （8）重定向构造函数

有时一个构造函数的目的只是重定向到同一个类中的另一个构造函数。如果一个重定向的构造函数的主体为空，那么调用这个构造函数的时候，直接在冒号后面调用这个构造函数即可。

 

```
class Point {
  num x;
  num y;
  // 这个类的主构造函数。
  Point(this.x, this.y);
  // 主构造函数的代表。
  Point.alongXAxis(num x) : this(x, 0);
}
```

### （9）静态构造函数

如果你的类产生的对象永远不会改变，你可以让这些对象成为编译时常量。为此，需要定义一个const 构造函数并确保所有的实例变量都是final 的。

```
class ImmutablePoint {
    final num x;
    final num y;
    const ImmutablePoint(this.x, this.y);
    static final ImmutablePoint origin = const ImmutablePoint(0, 0);
}
```

### （10）工厂构造函数

当需要的构造函数不是每次都创建一个新的对象时，使用factory关键字修饰的构造函数。例如，工厂构造函数可能从缓存返回实例，或者它可能返回子类型的实例。 下面的示例演示一个工厂构造函数从缓存返回的对象：

```
class Logger {
   final String name;
   bool mute = false;
   // _cache 是一个私有库,幸好名字前有个 _ 。 
   static final Map<String, Logger> _cache = <String, Logger>{};
   factory Logger(String name) {
       if (_cache.containsKey(name)) {
          return _cache[name];
       } else {
          final logger = new Logger._internal(name);
          _cache[name] = logger;
          return logger;
       }
    }
    Logger._internal(this.name);
    void log(String msg) {
       if (!mute) {
          print(msg);
       }
    } 
 }
```

注：

1）工厂构造函数不能使用this

2）调用工厂构造函数，可以使用new关键字

```
//var logger = new Logger('UI');
var logger = Logger('UI');
logger.log('Button clicked');
```

## 4. Mixin机制

Dart 把支持多重继承的类叫做Mixin

（1）mixins 是一种多类层次结构的类的代码重用。

（2）要使用mixins ，在with 关键字后面跟一个或多个mixin 的名字。下面的例子显示了两个使用mixins的类：

https://www.dartlang.org/articles/language/mixins

[http://kevinwu.cn/p/ae2ce64/#%E5%9C%BA%E6%99%AF](http://kevinwu.cn/p/ae2ce64/#场景)

```
 class Musician extends Performer with Musical {
      // ...
 }
class Maestro extends Person with Musical, 
    Aggressive, Demented {
       Maestro(String maestroName) {
           name = maestroName;
           canConduct = true;
       }
 }
```

（3）要实现mixin ，就创建一个继承Object 类的子类，不声明任何构造函数，不调用super 。例如：

```
 abstract class Musical {
    bool canPlayPiano = false;
    bool canCompose = false;
    bool canConduct = false;
   void entertainMe() {
     if (canPlayPiano) {
         print('Playing piano');
     } else if (canConduct) {
         print('Waving hands');
     } else {
         print('Humming to self');
     }
   }
 }
```

## 5.抽象类

使用abstract 修饰符来定义一个抽象类，该类不能被实例化。抽象类在定义接口的时候非常有用，实际上抽象中也包含一些实现。如果你想让你的抽象类被实例化，请定义一个 工厂构造函数 。

（1）抽象类通常包含 抽象方法。下面是声明一个含有抽象方法的抽象类的例子：

```
 // 这个类是抽象类，因此不能被实例化。
 abstract class AbstractContainer {
   // ...定义构造函数，域，方法...
   void updateChildren(); // 抽象方法。
 }
```

（2）下面的类不是抽象类，因此它可以被实例化，即使定义了一个抽象方法：

```
 class SpecializedContainer extends AbstractContainer {
    // ...定义更多构造函数，域，方法...
    void updateChildren() {
      // ...实现 updateChildren()...
    }
   // 抽象方法造成一个警告，但是不会阻止实例化。
   void doSomething();
 }
```

## 6.隐式接口（implements）

每个类隐式的定义了一个接口，含有类的所有实例和它实现的所有接口。如果你想创建一个支持类B 的API 的类A，但又不想继承类B ，那么，类A 应该实现类B 的接口。

（1）一个类实现一个或更多接口通过用implements 子句声明，然后提供API 接口要求。例如：

```
// 一个 person ，包含 greet() 的隐式接口。
class Person {
  // 在这个接口中，只有库中可见。
  final _name;
  // 不在接口中，因为这是个构造函数。
  Person(this._name);
  // 在这个接口中。
  String greet(who) => 'Hello, $who. I am $_name.';
}
//  Person 接口的一个实现。
class Imposter implements Person {
  // 我们不得不定义它，但不用它。
  final _name = "";
  String greet(who) => 'Hi $who. Do you know who I am?';
}
greetBob(Person person) => person.greet('bob');
main() {
  print(greetBob(new Person('kathy')));
  print(greetBob(new Imposter()));
}
```

（2）这里是具体说明一个类实现多个接口的例子：

```
class Point implements Comparable, Location {
  // ...
}
```

注：不可以调用super，因为没有继承（扩展）关系

## 7.扩展一个类（extends）

（1）使用extends 创建一个子类，同时supper 将指向父类：

```
 class Television {
    void turnOn() {
       _illuminateDisplay();
        _activateIrSensor();
    }
    // ...
 }
 class SmartTelevision extends Television {
    void turnOn() {
       super.turnOn();
       _bootNetworkInterface();
       _initializeMemory();
       _upgradeApps();
    }
    // ...
 }
```

（2）子类可以重载实例方法，getters 方法，setters 方法。

下面是个关于重写Object 类的方法noSuchMethod() 的例子,当代码企图用不存在的方法或实例变量时，这个方法会被调用。

```
  class A {
    // 如果你不重写 noSuchMethod 方法, 就用一个不存在的成员，会导致NoSuchMethodError 错误。
    void noSuchMethod(Invocation mirror) {
        print('You tried to use a non-existent member:' + 
            '${mirror.memberName}');
     }
  }
```

（3）你可以使用@override 注释来表明你重写了一个成员。

```
 class A {
    @override
    void noSuchMethod(Invocation mirror) {
       // ...
    }
 }
```

（4）如果你用noSuchMethod() 实现每一个可能的getter 方法，setter 方法和类的方法，那么你可以使用@proxy 标注来避免警告。

```
 @proxy
 class A {
    void noSuchMethod(Invocation mirror) {
        // ...
    }
 }
```

# 九、方法

方法就是为对象提供行为的函数。

## 1.实例方法

对象的实例方法可以访问实例变量和this 。以下示例中的distanceTo() 方法是实例方法的一个例子：

```
import 'dart:math';
class Point {
   num x;
   num y;
   Point(this.x, this.y);
   num distanceTo(Point other) {
      var dx = x - other.x;
      var dy = y - other.y;
      return sqrt(dx * dx + dy * dy);
   }
 }
```

## 2. setters 和Getters

（1）setters 和Getters是一种提供对方法属性读和写的特殊方法。每个实例变量都有一个隐式的getter 方法，合适的话可能还会有setter 方法。你可以通过实现getters 和setters 来创建附加属性，也就是直接使用get 和set 关键词：

```
class Rectangle {
   num left;
   num top;
   num width;
   num height;
   Rectangle(this.left, this.top, this.width, this.height);
   // 定义两个计算属性: right and bottom.
   num get right => left + width;
   set right(num value) => left = value - width;
   num get bottom => top + height;
   set bottom(num value) => top = value - height;
}
main() {
   var rect = new Rectangle(3, 4, 20, 15);
   assert(rect.left == 3);
   rect.right = 12;
   assert(rect.left == -8);
}
```

（2）借助于getter 和setter ，你可以直接使用实例变量，并且在不改变客户代码的情况下把他们包装成方法。

注： 不论是否显式地定义了一个getter，类似增量（++）的操作符，都能以预期的方式工作。为了避免产生任何向着不期望的方向的影响，操作符一旦调用getter ，就会把他的值存在临时变量里。

即用到getter后就把得到值存起来

## 3.抽象方法

Instance（实例方法） ，getter 和setter 方法可以是抽象的，也就是定义一个接口，但是把实现交给其他的类。要创建一个抽象方法，使用分号（；）代替方法体：

```
 abstract class Doer {
    // ...定义实例变量和方法...
    void doSomething(); // 定义一个抽象方法。
 }
 class EffectiveDoer extends Doer {
     void doSomething() {
        // ...提供一个实现，所以这里的方法不是抽象的...
     }
 }
```

## 4.类的变量和方法

（1）使用static 关键字来实现类变量和类方法。

（2）只有当静态变量被使用时才被初始化。

（3）静态变量

静态变量（类变量）对于类状态和常数是有用的：

```
  class Color {
     static const red = const Color('red'); // 一个恒定的静态变量
     final String name;      // 一个实例变量。 
     const Color(this.name); // 一个恒定的构造函数。
  }
  main() {
     assert(Color.red.name == 'red');
  }
```

（4）静态方法

静态方法（类方法）不在一个实例上进行操作，因而不必访问this 。例如：

```
  import 'dart:math';
  class Point {
     num x;
     num y;
     Point(this.x, this.y);
     static num distanceBetween(Point a, Point b) {
        var dx = a.x - b.x;
        var dy = a.y - b.y;
        return sqrt(dx * dx + dy * dy);
     }
  }
  main() {
    var a = new Point(2, 2);
    var b = new Point(4, 4);
    var distance = Point.distanceBetween(a, b);
    assert(distance < 2.9 && distance > 2.8);
  }
```

注：

可以将静态方法作为编译时常量。例如，你可以把静态方法作为一个参数传递给静态构造函数。

# 十、枚举类型

1.枚举类型，通常被称为enumerations 或enums ，是一种用来代表一个固定数量的常量的特殊类。

2.声明一个枚举类型需要使用关键字enum ：

```
 enum Color {
    red,
    green,
    blue
 }
```

3.在枚举中每个值都有一个index getter 方法，它返回一个在枚举声明中从0 开始的位置。例如，第一个值索引值为0 ，第二个值索引值为1 。

```
  assert(Color.red.index == 0);
  assert(Color.green.index == 1);
  assert(Color.blue.index == 2);
```

4.要得到枚举列表的所有值，可使用枚举的values 常量。

```
  List<Color> colors = Color.values;
  assert(colors[2] == Color.blue);   
```

5.可以在switch 语句 中使用枚举。如果e 在switch (e) 是显式类型的枚举，那么如果你不处理所有的枚举值将会弹出警告：

```
 Color aColor = Color.blue;
  switch (aColor) {
      case Color.red:
         print('Red as roses!');
         break;
      case Color.green:
         print('Green as grass!');
         break;
      default: // Without this, you see a WARNING.
         print(aColor);  // 'Color.blue'
   }
```

6.枚举类型有以下限制

（1）你不能在子类中混合或实现一个枚举。

（2）你不能显式实例化一个枚举。

# 十一、库和可见性

前面介绍Dart基础知识的时候基本上都是在一个文件里面编写Dart代码的，但实际开发中不可能这么写，模块化很重要，所以这就需要使用到库的概念。

（1）在Dart中，库的使用时通过import关键字引入的。

（2）library指令可以创建一个库，每个Dart app都是一个库，即使没有使用library指令来指定。

库不仅提供了API，还提供privacy权限的单元：以下划线（_）开头的标识符只对内部库可见。

（2）库可以分布式使用包。见 [Pub Package and Asset Manager](https://www.dartlang.org/tools/pub/) 中有关pub(SDK中的一个包管理器)。

（3）使用库

使用import来引入一个库，这个是跟大多数语言一致的，如创建的第一个Flutter应用中，默认生成的main.dart文件中就有这么一句：

```
import 'package:flutter/material.dart';
```

其中import后面跟着的是库的URI，上面例子中的路径格式为： package:scheme，scheme是由指定的库通过包管理器提供的，在Flutter中，Dart是通过pub工具来管理包的。

上面是外部的库的引入方式，对于内部库，dart的路径格式为：dart:scheme，示例如下所示：

```
import 'dart:io';
```

而对于同一包下面的dart库，如我们在main.dart下面新增了一个testFile.dart的文件，我们需要引入它使用的时候则直接通过相对路径引入即可：

```
import 'testFile.dart';
```

（4）冲突解决-指定库前缀

当引入两个库中有相同名称标识符的时候，如果是java通常我们通过写上完整的包名路径来指定使用的具体标识符，甚至不用import都可以，但是Dart里面是必须import的。当冲突的时候，可以使用as关键字来指定库的前缀。如下例子所示：

```
import 'package:lib1/lib1.dart';
import 'package:lib2/lib2.dart' as lib2;
// ...
Element element1 = new Element();        // 使用lib1里的元素
lib2.Element element2 = new lib2.Element();// 使用lib2里的元素
```

（5）导入部分库

如果只需要导入库的一部分，有两种模式：

模式一：只导入需要的部分，使用show关键字，如下例子所示：

```
import 'package:lib1/lib1.dart' show foo;
```

模式二：隐藏不需要的部分，使用hide关键字，如下例子所示：

```
import 'package:lib2/lib2.dart' hide foo;
```

（6）延迟加载库

1）延迟(deferred)加载（也称为延迟(lazy)加载）允许应用程序按需加载库（可以在需要的时候再进行加载）。

2）下面是当你可能会使用延迟加载某些情况：

I：为了减少应用程序的初始启动时间；

II：执行A / B测试-尝试的算法的替代实施方式中；？？？

III：加载很少使用的功能，例如可选的屏幕和对话框。

3）懒加载使用deferred as关键字来指定，如下例子所示：

```
import 'package:deferred/hello.dart' deferred as hello;
```

当需要库时，使用该库的调用标识符调用LoadLibrary（）。

```
 greet() async {
   await hello.loadLibrary();
   hello.printGreeting();
 }
```

注：在前面的代码，在库加载好之前，await关键字都是暂停执行的。有关async 和await 见asynchrony support 的更多信息。

4）可以在一个库多次调用LoadLibrary（），多次调用该库也只被加载一次。

5）当您使用延迟加载，请记住以下内容：？？？

I：延迟库的常量在其作为导入文件时不是常量。直到迟库被加载完成才可以使用这些常量

II：不能在导入文件中使用延迟库常量的类型。相反，考虑将接口类型移到同时由延迟库和导入文件导入的库。

III：Dart隐含调用LoadLibrary（）插入到定义deferred as namespace。在调用LoadLibrary（）函数返回一个Future。

（7）库的实现？？？

用library 来命名库，用part来指定库中的其他文件。 注意：不必在应用程序中（具有顶级main（）函数的文件）使用library，但这样做可以让你在多个文件中执行应用程序。

（8）声明库

利用library identifier（库标识符）指定当前库的名称：

```
  // 声明库，指定该库的名字为ballgame
  library ballgame;
  // 导入html库
  import 'dart:html';
  // ...代码从这里开始... 
```

（9）关联文件与库

添加实现文件，把part fileUri放在有库的文件中，其中fileURI是实现文件的路径。然后在实现文件中，添加部分标识符（part of identifier），其中标识符是库的名称。下面的示例使用的一部分，在三个文件来实现部分库。

1）第一个文件，ballgame.dart，声明球赛库，导入其他需要的库，并指定ball.dart和util.dart是此库的部分：

```
  library ballgame;
  import 'dart:html';
  // ...其他导入在这里...
  part 'ball.dart';
  part 'util.dart';
  // ...代码从这里开始...
```

2）第二个文件ball.dart，实现了球赛库的一部分：

```
 part of ballgame;
 // ...代码从这里开始...
```

3）第三个文件，util.dart，实现了球赛库的其余部分：

```
 part of ballgame;
 // ...Code goes here...
```

（10）重新导出库(Re-exporting libraries)

可以通过重新导出部分库或者全部库来组合或重新打包库。例如，你可能有实现为一组较小的库集成为一个较大库。或者你可以创建一个库，提供了从另一个库方法的子集。

1)  // In french.dart:

```
   library french;
   hello() => print('Bonjour!');
   goodbye() => print('Au Revoir!');
```

2)  // In togo.dart:

```
   library togo;
   import 'french.dart';
   export 'french.dart' show hello;
```

  3）// In another .dart file:

```
   import 'togo.dart';
   void main() {
       hello();   //print bonjour
       goodbye(); //FAIL
   }
```

（11）变量、方法的可见性

Dart 使用package 的概念来管理源码和可见性。它没有public、private 之类的访问权限控制符，默认情况下，所有的符号都是公开的。如果我们不想某个变量对包的外部可见，可以使用下划线开头来给变量命名。

```
class _Foo {
  // ...
}
class Bar {
  int _x;
}
```

# 十二、异步的支持（没有太好的资料）

1.Dart 添加了一些新的语言特性用于支持异步编程。最通常使用的特性是async 方法和await 表达式。Dart 库大多方法返回Future 和Stream 对象。这些方法是异步的：它们在设置一个可能的耗时操作（比如I/O 操作）之后返回，而无需等待操作完成。

2.当你需要使用Future 来表示一个值时，你有两个选择。

使用async 和await

使用Future API

3.同样的，当你需要从Stream 获取值的时候，你有两个选择。

使用async 和一个异步的for循环(await for)

使用Stream API

4.使用async 和await 的代码是异步的，不过它看起来很像同步的代码。比如这里有一段使用await等待一个异步函数结果的代码：

```
await lookUpVersion()
```

5.要使用await，代码必须用await 标记

```
 checkVersion() async {
    var version = await lookUpVersion();
    if (version == expectedVersion) {
       // Do something.
    } else {
      // Do something else.
      }
 }
```

6.你可以使用try, catch,和finally 来处理错误并精简使用了await 的代码。

```
 try {
    server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4044);
 } catch (e) {
    // React to inability to bind to the port...
 }
```

7.声明异步函数

（1）一个异步函数是一个由async修饰符标记的函数。虽然一个异步函数可能在操作上比较耗时，但是它可以立即返回-在任何方法体执行之前。

```
 checkVersion() async {
    // ...
 }
 lookUpVersion() async => /* ... */;
```

（2）在函数中添加关键字async 使得它返回一个Future

比如，考虑一下这个同步函数，它将返回一个字符串。

```
String lookUpVersionSync() => '1.0.0';
```

如果你想更改它成为异步方法-因为在以后的实现中将会非常耗时-它的返回值是一个Future 。

```
Future<String> lookUpVersion() async => '1.0.0';
```

注：函数体不需要使用Future API，如果必要的话Dart 将会自己创建Future 对象。

8.使用带future 的await 表达式

（1）一个await表达式具有以下形式

```
await expression
```

（3）在异步方法中你可以使用await 多次。比如，下列代码为了得到函数的结果一共等待了三次。

```
 var entrypoint = await findEntrypoint();
 var exitCode = await runExecutable(entrypoint, args);
 await flushThenExit(exitCode);
```

（3）在await 表达式中， 表达式 的值通常是一个Future 对象；如果不是，那么这个值会自动转为Future。这个Future 对象表明了表达式应该返回一个对象。await 表达式 的值就是返回的一个对象。在对象可用之前，await 表达式将会一直处于暂停状态。

（4）如果await 没有起作用，请确认它是一个异步方法。比如，在你的main() 函数里面使用await，main()的函数体必须被async 标记：

```
  main() async {
     checkVersion();
     print('In main: version is ${await lookUpVersion()}');
  }
```

9.结合streams 使用异步循环

（1）一个异步循环具有以下形式：

```
 await for (variable declaration in expression) {
     // Executes each time the stream emits a value.
 }
```

（2）expression（表达式） 的值必须有Stream 类型（流类型）。执行过程如下：

1）在stream 发出一个值之前等待

2）把变量设置为发出的值，执行for循环的主体，

3）重复1 和2，直到Stream 关闭

（3）如果要停止监听stream ，你可以使用break 或者return 语句，跳出循环并取消来自stream 的订阅 。

（4）如果一个异步for 循环没有正常运行，请确认它是一个异步方法。 比如，在应用的main() 方法中使用异步的for 循环时，main() 的方法体必须被async 标记。

```
  main() async {
     ...
     await for (var request in requestServer) {
         handleRequest(request);
     }
     ...
  }
```

更多关于异步编程的信息，请看 dart:async 库部分的介绍。你也可以看文章 [Dart Language Asynchrony Support: Phase 1 ](https://www.dartlang.org/articles/await-async/)和 [Dart Language Asynchrony Support: Phase 2](https://www.dartlang.org/articles/beyond-async/), 和 [the Dart language specification](https://www.dartlang.org/docs/spec/)

# 十三、Isolates（待补充）

现在的网页浏览器，甚至是移动平台上的，运行在多核CPU 之上。为了充分利用多核心的优势，开发人员通常对共享内存的线程采取并行策略。然而，在共享状态下使用并发容易出错并且会使代码复杂化。

Dart 在代码中使用isolates 来替代线程。每个isolate 有自己的内存堆，以确保isolate 的状态不能被其他任何isolate 访问。

# 十四、Typedefs

在Dart 中，方法是对象，就像字符串和数字也是对象。typedef ,又被称作函数类型别名，让你可以为函数类型命名，并且该命名可以在声明字段和返回类型的时候使用。当一种函数类型被分配给一个变量的时候，typedef 会记录原本的类型信息。

考虑下面使用typedef的代码。

```
class SortedCollection {
  Function compare;
  SortedCollection(int f(Object a, Object b)) {
    compare = f;
  }
}
 // Initial, broken implementation.
 int sort(Object a, Object b) => 0;
main() {
  SortedCollection coll = new SortedCollection(sort);
  // All we know is that compare is a function,
  // but what type of function?
  assert(coll.compare is Function);
}
```

当f 分配到compare 的时候类型信息丢失了。f的类型是(Object, Object) → int(→ 意味着返回的)，然而compare 的类型是方法。如果我们使用显式的名字更改代码并保留类型信息，则开发者和工具都可以使用这些信息。

```
typedef int Compare(Object a, Object b);
class SortedCollection {
  Compare compare;
  SortedCollection(this.compare);
}
 // Initial, broken implementation.
 int sort(Object a, Object b) => 0;
main() {
  SortedCollection coll = new SortedCollection(sort);
  assert(coll.compare is Function);
  assert(coll.compare is Compare);
}
```

注：目前typedefs 仅限于函数类型。

因为typedefs 是简单的别名，所以它提供了一种方法来检查任何函数的类型。比如：

```
typedef int Compare(int a, int b);
int sort(int a, int b) => a - b;
main() {
  assert(sort is Compare); // True!
}
```

# 十五、元数据

1.使用元数据来给你的代码提供附加信息。

2.元数据注解以@ 字符开头，后面跟一个编译时的常量引用（例如deprecated）或者调用常量构造器的语句。

3.所有的Dart 代码中支持三个注解：@deprecated，@override 和@proxy。@override 和@proxy的用法示例，请查看类的继承。以下是@deprecated 用法的示例：

```
class Television {
  /// _Deprecated: Use [turnOn] instead._
  @deprecated
  void activate() {
    turnOn();
  }
  /// Turns the TV's power on.
  void turnOn() {
    print('on!');
  }
}
```

4.你可以定义你自己的元数据注解。下面的例子定义了一个有两个参数的@todo 注解：

```
library todo;
class todo {
  final String who;
  final String what;
  const todo(this.who, this.what);
}
```

下面是使用@todo 注解的例子：

```
import 'todo.dart';
@todo('seth', 'make this do something')
void doSomething() {
  print('do something');
}
```

5.元数据可以出现在库、类、typedef、类型参数、构造器、工厂、函数、属性、参数、变量声明、import 或export 指令之前。你可以在运行时通过反射来取回元数据。

# 十六、注释

Dart 支持单行注释、多行注释和文档注释。

## 1.单行注释

单行注释由// 开始。每一行中//到行尾之间的内容会被Dart 编译器忽略。

```
main() {
  // TODO: refactor into an AbstractLlamaGreetingFactory?
  print('Welcome to my Llama farm!');
}
```

## 2.多行注释

一段多行注释由/* 开始，由*/ 结束。在/* 和*/ 之间的内容会被Dart编译器忽略（除非他们是文档注释；请看下面的部分）。多行注释可以嵌套。

```
main() {
  /*
   * This is a lot of work. Consider raising chickens.
  Llama larry = new Llama();
  larry.feed();
  larry.exercise();
  larry.clean();
   */
}
```

## 3.文档注释

文档注释是由/// 或/** 开始的多行或单行注释。在连续的行上使用/// 的效果等同于多行注释。

在一段文档注释中，Dart 编译器忽略所有除括号内的文本。你可以使用括号来引用类、方法、属性、顶级变量、函数和参数。括号中的名字会在被文档化程序元素的词法范围内解析。

下面是一个引用了其它类和参数的文档注释的例子：

```
/// A domesticated South American camelid (Lama glama).
///
/// Andean cultures have used llamas as meat and pack
/// animals since pre-Hispanic times.
class Llama {
  String name;
 
  /// Feeds your llama [Food].
  ///
  /// The typical llama eats one bale of hay per week.
  void feed(Food food) {
    // ...
  }
 
  /// Exercises your llama with an [activity] for
  /// [timeLimit] minutes.
  void exercise(Activity activity, int timeLimit) {
    // ...
  }
}
```

在生成的文档中，[food] 变成了指向Food 类的API 文档连接。

为了转换Dart 代码并生成HTML 文档，你可以使用SDK 的 文档生成器（https://www.dartlang.org/tools/dartdocgen/）。生成文档的示例，请参阅Dart API 文档（http://api.dartlang.org/）。关于如何组织你的文档，请参阅 文档注释准则（https://www.dartlang.org/guides/language/effective-dart/documentation）。
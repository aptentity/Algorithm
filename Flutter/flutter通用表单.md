# 背景

为了用flutter支持业务，需要用到表单（Form）组件。先看一下Form的使用：

```
import 'package:flutter/material.dart';

class FormDemoPage extends StatefulWidget {
  static const String routeName = '/page/form_demo_page';
  static const String name = "FormDemoPage";

  @override
  _FormDemoState createState() => _FormDemoState();
}

class _FormDemoState extends State<FormDemoPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name;
  String _password;
  String _common;

  void _forSubmitted() {
    var _form = _formKey.currentState;

    if (_form.validate()) {
      _form.save();
      print(_name);
      print(_password);
      print(_common);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter data',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Form'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _forSubmitted,
          child:  Text('提交'),
        ),
        body:  Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child:  Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                  ),
                  onSaved: (val) {
                    _name = val;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: (val) {
                    return val.length < 4 ? "密码长度错误" : null;
                  },
                  onSaved: (val) {
                    _password = val;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

运行效果：

<img src="/Users/gulliver/work/borg_technology/img/Screenshot_1571647892.png" alt="Screenshot_1571647892" style="zoom: 25%;" />

但是flutter的Form表单在取值时相对较为繁琐，尤其是层级较多时。考虑用一种比较方便的方式获取，这里使用map的形式。map也比较容易转为json。

# 结构

![image-20191021170555085](/Users/gulliver/work/borg_technology/img/image-20191021170555085.png)

# Form

save

reset

validate

value：表单值，k-v形式



# FormField

save

reset

validate



# 自定义FormField

1、initState中初始化

2、实现reset方法

3、为了支持autovalidate需要在内容变化时调用didChange

4、didChange同时会为value负值



# 后续

1、级联

2、数据初始化





https://github.com/LFWheel/flutter_dynamic_page

https://github.com/dengyin2000/dynamic_widget

https://github.com/OndrejKunc/flutter_dynamic_forms



数据与UI

绑定：简单，容易控制；接口实现难度大，且不灵活

分离：实现复杂，灵活性差；接口实现难度小

方案：中间层？分离



# 动态表单

## 场景

1、静态单页表单：单页、固定表单项、固定初始值

2、动态单页表单：单页、固定表单项、动态初始值

3、静态多页表单：多页、固定表单项、固定初始化

4、动态多页表单：多页、固定表单项、动态初始值

5、引导式

## 参数获取

1、跳转参数

2、接口获取



## 基础表单项

### 布局

#### 表单组

属性：标题、副标题、跳转url

<img src="/Users/gulliver/work/borg_technology/img/2ED5E271-C23A-4263-A2EA-9C0B284EEAA5.png" alt="2ED5E271-C23A-4263-A2EA-9C0B284EEAA5" style="zoom:50%;" />

#### tab

属性：标题

### <img src="/Users/gulliver/work/borg_technology/img/336A1F36-C288-49FB-A9BE-B9D3AC0518F2.png" alt="336A1F36-C288-49FB-A9BE-B9D3AC0518F2" style="zoom:50%;" />

### 输入

#### 单选

属性：主标题、副标题

<img src="/Users/gulliver/work/borg_technology/img/2AEC850E-5045-4902-ABB6-0DDB91FDC9E2.png" alt="2AEC850E-5045-4902-ABB6-0DDB91FDC9E2" style="zoom:50%;" />

#### 单行输入

属性：标题、输入类型、后缀

<img src="/Users/gulliver/work/borg_technology/img/E1B3A49E-FA61-4A7F-B006-A80CCAB49D5C.png" alt="E1B3A49E-FA61-4A7F-B006-A80CCAB49D5C" style="zoom:50%;" />

#### 多行输入

<img src="/Users/gulliver/work/borg_technology/img/375C3B2D-BFC0-46A8-B75E-29D5878AE169.png" alt="375C3B2D-BFC0-46A8-B75E-29D5878AE169" style="zoom:50%;" />

### 选择

#### 日期选择

属性：标题

<img src="/Users/gulliver/work/borg_technology/img/B6BF405C-26B5-4B59-9ABE-A393507AF28C.png" alt="B6BF405C-26B5-4B59-9ABE-A393507AF28C" style="zoom:50%;" />

#### 时间选择

#### 内容选择

#### 加减

### 按钮

### 拍照

<img src="/Users/gulliver/work/borg_technology/img/FE1C9A5F-BB59-4C57-B77E-70BE2C4AF9E4.png" alt="FE1C9A5F-BB59-4C57-B77E-70BE2C4AF9E4" style="zoom:50%;" />



### 显示

#### 单行显示

<img src="/Users/gulliver/work/borg_technology/img/A5854043-26DA-4F19-85D0-8D8D89E7F5A2.png" alt="A5854043-26DA-4F19-85D0-8D8D89E7F5A2" style="zoom:50%;" />

#### 图片

#### 地图

### 提示

### 提交

1、直接提交

2、确认提交

动态列表


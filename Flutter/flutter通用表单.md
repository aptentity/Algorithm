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





1、嵌套

2、级联

3、选择

4、数据初始化

混入、集成
import 'package:flutter/material.dart';

///自定义表单
///根节点只能是DkForm，且DkForm只能是根节点
///
class DkForm extends StatefulWidget {
  final Widget child;
  final bool autovalidate;
  final WillPopCallback onWillPop;
  final VoidCallback onChanged;

  const DkForm(
      {Key key,
      @required this.child,
      this.autovalidate = false,
      this.onWillPop,
      this.onChanged})
      : assert(child != null),
        super(key: key);

  @override
  DkFormState createState() => DkFormState();

  static DkFormState of(BuildContext context) {
    final _DkFormScope scope =
        context.inheritFromWidgetOfExactType(_DkFormScope);
    return scope?._formState;
  }
}

class DkFormState extends DkFormFieldParentBaseState<DkForm>
    with DkFormParentState<DkForm> {
  int _generation = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.autovalidate) {}
    return WillPopScope(
      onWillPop: widget.onWillPop,
      child: _DkFormScope(
        formState: this,
        generation: _generation,
        child: widget.child,
      ),
    );
  }

  void _fieldDidChange() {
    if (widget.onChanged != null) widget.onChanged();
    _forceRebuild();
  }

  void _forceRebuild() {
    setState(() {
      ++_generation;
    });
  }

  void reset() {
    print('DkFormState reset _fields $_fields');
    super.reset();
    _fieldDidChange();
  }

  bool validate() {
    _forceRebuild();
    return super.validate();
  }
}

class _DkFormScope extends InheritedWidget {
  final DkFormState _formState;
  final int _generation;

  const _DkFormScope({
    Key key,
    Widget child,
    DkFormState formState,
    int generation,
  })  : _formState = formState,
        _generation = generation,
        super(key: key, child: child);

  DkForm get form => _formState.widget;

  @override
  bool updateShouldNotify(_DkFormScope oldWidget) {
    return _generation != oldWidget._generation;
  }
}

typedef DkFormFieldSetter<T> = void Function(T newValue);
typedef DkFormFieldValidator<T> = String Function(T value);
typedef DkFormFieldBuilder<T> = Widget Function(DkFormFieldState<T> field);
typedef ValueTransformer<T> = dynamic Function(T value);

class DkFormField<T> extends StatefulWidget {
  final DkFormFieldSetter<T> onSaved;
  final DkFormFieldValidator<T> validator;
  final DkFormFieldBuilder<T> builder;
  final T initialValue;
  final bool autovalidate;
  final bool enabled;
  final String attribute;
  final ValueTransformer valueTransformer;

  const DkFormField({
    Key key,
    @required this.builder,
    @required this.attribute,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.autovalidate = false,
    this.enabled = true,
    this.valueTransformer,
  })  : assert(builder != null),
        super(key: key);
  @override
  DkFormFieldState<T> createState() => DkFormFieldState<T>();
}

///
/// didChange、setValue用于负值
class DkFormFieldState<T> extends DkFormFieldBaseState<DkFormField<T>>
    with DkFormLeafState {
  T _value;
  String _errorText;

  T get value => _value;
  String get errorText => _errorText;
  bool get hasError => _errorText != null;

  @override
  void save() {
    dynamic newValue;
    if(widget.valueTransformer!=null){
      newValue = widget.valueTransformer(value);
    }else{
      newValue = value;
    }
    if (widget.onSaved != null) {
      widget.onSaved(newValue);
    }
    saveValue(widget.attribute, newValue);
  }

  @override
  void reset() {
    setState(() {
      _value = widget.initialValue;
      _errorText = null;
    });
  }

  @override
  bool validate() {
    setState(() {
      _validate();
    });
    return !hasError;
  }

  void _validate() {
    if (widget.validator != null) {
      _errorText = widget.validator(_value);
    }
  }

  void didChange(T value) {
    setState(() {
      _value = value;
    });
    _formState?._fieldDidChange();
  }

  void setValue(T value) {
    _value = value;
  }

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  void dispose() {
    _value = widget.initialValue;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.autovalidate && widget.enabled) {
      _validate();
    }
    super.build(context);
    return widget.builder(this);
  }
}

///表单组widget
class DkFormFieldGroup extends StatefulWidget {
  final Widget child;
  final String attribute;

  const DkFormFieldGroup(
      {Key key, @required this.child, @required this.attribute})
      : assert(child != null),
        super(key: key);
  @override
  DkFormFieldGroupState createState() => DkFormFieldGroupState();

  static DkFormFieldGroupState of(BuildContext context) {
    return context
        .ancestorStateOfType(const TypeMatcher<DkFormFieldGroupState>());
  }
}

///表单组节点
///
/// value：{"favorite":{"favorite name":"地心历险记2"}}
class DkFormFieldGroupState extends DkFormFieldParentBaseState<DkFormFieldGroup>
    with DkFormParentState, DkFormLeafState {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: widget.child,
    );
  }

  @override
  void save() {
    super.save();
    saveValue(widget.attribute, value);
  }
}

///数组根节点widget
class DkFormFieldList extends StatefulWidget {
  final Widget child;
  final String attribute;

  const DkFormFieldList(
      {Key key, @required this.child, @required this.attribute})
      : assert(child != null),
        super(key: key);

  @override
  DkFormFieldListState createState() => DkFormFieldListState();

  static DkFormFieldListState of(BuildContext context) {
    return context
        .ancestorStateOfType(const TypeMatcher<DkFormFieldListState>());
  }
}

///数组根节点
///
/// 提供saveArray方法
/// value:{"movie":[{"name":"双面杀手","nation":"美国"},{"name":"我的国","nation":"中国"}]}
class DkFormFieldListState extends DkFormFieldParentBaseState<DkFormFieldList>
    with DkFormParentState, DkFormLeafState {
  List<dynamic> _array;

  @override
  void initState() {
    _array = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: widget.child,
    );
  }

  @override
  void save() {
    _array = [];
    super.save();
    saveValue(widget.attribute, _array);
  }

  void saveArray(dynamic data) {
    _array.add(data);
  }
}

///数组节点包装widget，父widget需要是DkFormFieldList
///
class DkFormFieldListItem extends StatefulWidget {
  final Widget child;

  const DkFormFieldListItem({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  @override
  DkFormFieldListItemState createState() => DkFormFieldListItemState();
}

///数组根节点
///
///需要寻找FormFieldList节点
///save时调用FormFieldList的saveArray
class DkFormFieldListItemState
    extends DkFormFieldParentBaseState<DkFormFieldListItem>
    with DkFormParentState {
  DkFormFieldListState _formFieldListState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formFieldListState = DkFormFieldList.of(context);

    assert(_formFieldListState != null);
  }

  @override
  void deactivate() {
    super.deactivate();
    _formFieldListState?._unregister(this);
  }

  @override
  Widget build(BuildContext context) {
    _formFieldListState?._register(this);
    return Container(
      child: widget.child,
    );
  }

  @override
  void save() {
    super.save();
    _formFieldListState.saveArray(value);
  }
}

///表单的父节点
///
///实现_register，_unregister，setAttributeValue，save，reset，validate
mixin DkFormParentState<T extends StatefulWidget>
    on DkFormFieldParentBaseState<T> {
  final Set<DkFormFieldBaseState<dynamic>> _fields =
      <DkFormFieldBaseState<dynamic>>{};
  Map<String, dynamic> _value;
  Map<String, dynamic> get value => _value;

  void _register(DkFormFieldBaseState<dynamic> field) {
    print('DkFormParentState _register $field');
    _fields.add(field);
  }

  void _unregister(DkFormFieldBaseState<dynamic> field) {
    print('DkFormParentState _unregister $field');
    _fields.remove(field);
  }

  void setAttributeValue(String attribute, dynamic value) {
    setState(() {
      _value[attribute] = value;
    });
  }

  @override
  void initState() {
    _value = {};
    super.initState();
  }

  void save() {
    print('DkFormParentState save');
    for (DkFormFieldBaseState<dynamic> field in _fields) {
      print("DkFormFieldBaseState save $field");
      field.save();
    }
  }

  void reset() {
    print('DkFormRootState reset');
    for (DkFormFieldBaseState<dynamic> field in _fields) {
      field.reset();
    }
  }

  bool validate() {
    return _validate();
  }

  bool _validate() {
    bool hasError = false;
    for (DkFormFieldBaseState<dynamic> field in _fields)
      hasError = !field.validate() || hasError;
    return !hasError;
  }
}

///表单的叶子节点
///
///注册到上一级的DkFormFieldParentBaseState
///取到DkFormState
///saveValue将k-v保存到上一级DkFormFieldParentBaseState
mixin DkFormLeafState<T extends StatefulWidget> on DkFormFieldBaseState<T> {
  DkFormState _formState;
  DkFormFieldParentBaseState _formFieldBaseState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formState = DkForm.of(context);
    _formFieldBaseState = DkFormFieldParentBaseState.of(context);

    assert(_formState != null);
    assert(_formFieldBaseState != null);
  }

  @override
  void deactivate() {
    _formFieldBaseState?._unregister(this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    _formFieldBaseState?._register(this);
    return null;
  }

  void saveValue(String attribute, dynamic value) {
    _formFieldBaseState?.setAttributeValue(attribute, value);
  }
}

///表单父节点抽象类
///
///_register：注册为该节点的子节点
///_unregister：删除该节点的子节点
///setAttributeValue：添加k-v到节点中，作为表单数据
///of：取上一级的DkFormFieldParentBaseState
abstract class DkFormFieldParentBaseState<T extends StatefulWidget>
    extends DkFormFieldBaseState<T> {
  void _register(DkFormFieldBaseState<dynamic> field);
  void _unregister(DkFormFieldBaseState<dynamic> field);
  void setAttributeValue(String attribute, dynamic value);

  static DkFormFieldParentBaseState of(BuildContext context) {
    return context
        .ancestorStateOfType(const TypeMatcher<DkFormFieldParentBaseState>());
  }
}

///表单的叶子节点抽象类
///
///save保存数据
///reset恢复为初始值
///validate数据校验
abstract class DkFormFieldBaseState<T extends StatefulWidget> extends State<T> {
  void save();
  void reset();
  bool validate();
}

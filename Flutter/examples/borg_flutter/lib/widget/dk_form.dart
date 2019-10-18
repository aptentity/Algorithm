import 'package:flutter/material.dart';

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
    with DkFormRootState<DkForm> {
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

class DkFormField<T> extends StatefulWidget {
  final DkFormFieldSetter<T> onSaved;
  final DkFormFieldValidator<T> validator;
  final DkFormFieldBuilder<T> builder;
  final T initialValue;
  final bool autovalidate;
  final bool enabled;
  final String attribute;

  const DkFormField({
    Key key,
    @required this.builder,
    @required this.attribute,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.autovalidate = false,
    this.enabled = true,
  })  : assert(builder != null),
        super(key: key);
  @override
  DkFormFieldState<T> createState() => DkFormFieldState<T>();
}

class DkFormFieldState<T> extends DkFormFieldBaseState<DkFormField<T>>
    with DkFormLeafState {
  T _value;
  String _errorText;

  T get value => _value;
  String get errorText => _errorText;
  bool get hasError => _errorText != null;

  @override
  void save() {
    if (widget.onSaved != null) {
      widget.onSaved(value);
    }
    saveValue(widget.attribute, value);
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

abstract class DkFormFieldParentBaseState<T extends StatefulWidget> extends DkFormFieldBaseState<T> {
  void _register(DkFormFieldBaseState<dynamic> field);
  void _unregister(DkFormFieldBaseState<dynamic> field);
  void setAttributeValue(String attribute, dynamic value);

  static DkFormFieldParentBaseState of(BuildContext context) {
    return context
        .ancestorStateOfType(const TypeMatcher<DkFormFieldParentBaseState>());
  }
}

abstract class DkFormFieldBaseState<T extends StatefulWidget> extends State<T>{
  void save();
  void reset();
  bool validate();
}


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

class DkFormFieldGroupState extends DkFormFieldParentBaseState<DkFormFieldGroup>
    with DkFormRootState, DkFormLeafState {
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

class DkFormFieldList extends StatefulWidget {
  final Widget child;
  final String attribute;

  const DkFormFieldList(
      {Key key, @required this.child, @required this.attribute})
      : assert(child != null),
        super(key: key);

  @override
  DkFormFieldListState createState() => DkFormFieldListState();

  static DkFormFieldListState of(BuildContext context){
    return context
        .ancestorStateOfType(const TypeMatcher<DkFormFieldListState>());
  }
}

class DkFormFieldListState extends DkFormFieldParentBaseState<DkFormFieldList>
    with DkFormRootState, DkFormLeafState {
  List<dynamic> _array;

  @override
  void initState() {
    _array =[];
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

  void saveArray(dynamic data){
    _array.add(data);
  }
}

class DkFormFieldListItem extends StatefulWidget {
  final Widget child;

  const DkFormFieldListItem(
      {Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  @override
  DkFormFieldListItemState createState() => DkFormFieldListItemState();

  static DkFormFieldListItemState of(BuildContext context){
    return context
        .ancestorStateOfType(const TypeMatcher<DkFormFieldListItemState>());
  }
}

class DkFormFieldListItemState extends DkFormFieldParentBaseState<DkFormFieldListItem>
    with DkFormRootState{
  DkFormFieldListState _formFieldListState;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formFieldListState = DkFormFieldList.of(context);
  }

  @override
  void save() {
    super.save();
    _formFieldListState.saveArray(value);
  }
}


mixin DkFormRootState<T extends StatefulWidget> on DkFormFieldParentBaseState<T> {
  final Set<DkFormFieldBaseState<dynamic>> _fields =
      <DkFormFieldBaseState<dynamic>>{};
  Map<String, dynamic> _value;
  Map<String, dynamic> get value => _value;

  void _register(DkFormFieldBaseState<dynamic> field) {
    print('DkFormRootState _register $field');
    _fields.add(field);
  }

  void _unregister(DkFormFieldBaseState<dynamic> field) {
    print('DkFormRootState _unregister $field');
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

  @override
  void dispose() {
    super.dispose();
  }

  void save() {
    print('DkFormRootState save');
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

mixin DkFormLeafState<T extends StatefulWidget> on DkFormFieldBaseState<T> {
  DkFormState _formState;
  DkFormFieldParentBaseState _formFieldBaseState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formState = DkForm.of(context);
    _formFieldBaseState = DkFormFieldParentBaseState.of(context);
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

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

class DkFormState extends State<DkForm> {
  Map<String, GlobalKey<DkFormFieldState>> _fieldKeys;
  Map<String, dynamic> _value;
  Map<String, dynamic> get value => _value;

  int _generation = 0;
  final Set<DkFormFieldBaseState<dynamic>> _fields =
      <DkFormFieldBaseState<dynamic>>{};

  @override
  void initState() {
    _fieldKeys = {};
    _value = {};
    super.initState();
  }

  @override
  void dispose() {
    _fieldKeys = null;
    super.dispose();
  }

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

  void _register(DkFormFieldBaseState<dynamic> field) {
    print('DkFormState _register $field');
    _fields.add(field);
  }

  void _unregister(DkFormFieldBaseState<dynamic> field) {
    print('DkFormState _unregister $field');
    _fields.remove(field);
  }

  void registerFieldKey(String attribute, GlobalKey key) {
    print('DkFormState registerFieldKey $attribute $key');
    this._fieldKeys[attribute] = key;
  }

  void unregisterFieldKey(String attribute) {
    print('DkFormState unregisterFieldKey $attribute');
    this._fieldKeys.remove(attribute);
  }

  void setAttributeValue(String attribute, dynamic value) {
    setState(() {
      _value[attribute] = value;
    });
  }

  void save() {
    print('DkFormState save');
    for (DkFormFieldBaseState<dynamic> field in _fields) {
      print("DkFormFieldBaseState save $field");
      field.save();
    }
  }

  void reset() {
    for (DkFormFieldBaseState<dynamic> field in _fields) {
      field.reset();
    }
    _fieldDidChange();
  }

  bool validate() {
    _forceRebuild();
    return _validate();
  }

  bool _validate() {
    bool hasError = false;
    for (DkFormFieldBaseState<dynamic> field in _fields)
      hasError = !field.validate() || hasError;
    return !hasError;
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

class DkFormFieldState<T> extends DkFormFieldBaseState<DkFormField<T>> {
  final GlobalKey<DkFormFieldState> _fieldKey = GlobalKey<DkFormFieldState>();
  DkFormState _formState;
  DkFormFieldGroupState _formFieldGroupState;
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
    if (_formFieldGroupState != null) {
      _formFieldGroupState.setAttributeValue(widget.attribute, value);
    } else {
      _formState?.setAttributeValue(widget.attribute, value);
    }
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
    DkForm.of(context)?._fieldDidChange();
  }

  T setValue(T value) {
    _value = value;
  }

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formState = DkForm.of(context);
    _formState?.registerFieldKey(widget.attribute, _fieldKey);
    _formFieldGroupState = DkFormFieldGroup.of(context);
    if (_formFieldGroupState == null) {
      print('!!!!!!!!!!!!!!!!!!!!!!!!!!');
    } else {
      print('@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    }
  }

  @override
  void dispose() {
    _value = widget.initialValue;
    super.dispose();
  }

  @override
  void deactivate() {
    if (_formFieldGroupState != null) {
      _formFieldGroupState._unregister(this);
    } else {
      _formState?._unregister(this);
    }
    _formState?.unregisterFieldKey(widget.attribute);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.autovalidate && widget.enabled) {
      _validate();
    }
    if (_formFieldGroupState != null) {
      _formFieldGroupState._register(this);
    } else {
      _formState?._register(this);
    }
    return widget.builder(this);
  }
}

abstract class DkFormFieldBaseState<T extends StatefulWidget> extends State<T> {
  void save();
  void reset();
  bool validate();
}

class DkFormFieldGroup extends StatefulWidget {
  final Widget child;
  final VoidCallback onChanged;
  final String attribute;

  const DkFormFieldGroup(
      {Key key, @required this.child, this.onChanged, @required this.attribute})
      : assert(child != null),
        super(key: key);
  @override
  DkFormFieldGroupState createState() => DkFormFieldGroupState();

  static DkFormFieldGroupState of(BuildContext context) {
    return context
        .ancestorStateOfType(const TypeMatcher<DkFormFieldGroupState>());
  }
}

class DkFormFieldGroupState extends DkFormFieldBaseState<DkFormFieldGroup> {
  Map<String, dynamic> _value;
  Map<String, dynamic> get value => _value;
  final Set<DkFormFieldBaseState<dynamic>> _fields =
      <DkFormFieldBaseState<dynamic>>{};
  DkFormState _formState;
  DkFormFieldGroupState _dkFormFieldGroupState;

  @override
  void initState() {
    _value = {};
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formState = DkForm.of(context);
    _dkFormFieldGroupState = DkFormFieldGroup.of(context);
  }

  @override
  Widget build(BuildContext context) {
    _dkFormFieldGroupState != null
        ? _dkFormFieldGroupState._register(this)
        : _formState?._register(this);
    return Container(
      child: widget.child,
    );
  }

  @override
  void save() {
    print('DkFormFieldGroupState save');
    for (DkFormFieldBaseState<dynamic> field in _fields) {
      print("DkFormFieldBaseState save $field");
      field.save();
    }
    _dkFormFieldGroupState != null
        ? _dkFormFieldGroupState.setAttributeValue(widget.attribute, value)
        : _formState?.setAttributeValue(widget.attribute, value);
  }

  void reset() {
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

  void _register(DkFormFieldBaseState<dynamic> field) {
    print('DkFormFieldGroupState _register $field');
    _fields.add(field);
  }

  void _unregister(DkFormFieldBaseState<dynamic> field) {
    print('DkFormFieldGroupState _unregister $field');
    _fields.remove(field);
  }

  void setAttributeValue(String attribute, dynamic value) {
    setState(() {
      _value[attribute] = value;
    });
  }
}

class DkFormFieldList {}

class DkFormFieldListItem {}

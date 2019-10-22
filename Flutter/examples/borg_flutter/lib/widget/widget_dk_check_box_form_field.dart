import 'package:flutter/material.dart';
import 'package:borg_flutter/widget/dk_form.dart';

class DkCheckBoxFormField extends DkFormField<bool> {
  DkCheckBoxFormField({
    Key key,
    @required String attribute,
    InputDecoration decoration = const InputDecoration(),
    bool initialValue = false,
    bool readOnly = false,
    Widget secondary,
    Widget title,
    ValueChanged<bool> onChanged,
    DkFormFieldValidator<bool> validator,
    ValueTransformer valueTransformer,
  }) : super(
          attribute: attribute,
          initialValue: initialValue,
          validator:validator,
          valueTransformer:valueTransformer,
          builder: (DkFormFieldState<bool> field) {
            print('bulder........');
            final DkFormFieldState state = field;
            void onChangedHandler(bool value) {
              if (onChanged != null) {
                onChanged(value);
              }
              field.didChange(value);
            }

            return InputDecorator(
              decoration: decoration.copyWith(errorText: state.errorText),
              child: CheckboxListTile(
                secondary: secondary,
                title: title,
                onChanged: onChangedHandler,
                value: state.value,
              ),
            );
          },
        );
}

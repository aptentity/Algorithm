import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart' as toast;
import 'package:borg_flutter/main.dart';

toast.ToastFuture showLongToast(
    String msg, {
      bool dismissOtherToast = false,
    }) =>
    dkShowToast(msg,
        duration: Duration(milliseconds: 4000),
        position: toast.ToastPosition.bottom,
        dismissOtherToast: dismissOtherToast);

toast.ToastFuture showShortToast(
    String msg, {
      bool dismissOtherToast = false,
    }) =>
    dkShowToast(msg,
        duration: Duration(milliseconds: 2300),
        position: toast.ToastPosition.bottom,
        dismissOtherToast: dismissOtherToast);

toast.ToastFuture showCenterToast(
    String msg, {
      bool dismissOtherToast = false,
      duration = const Duration(milliseconds: 2300),
    }) =>
    dkShowToast(msg,
        position: toast.ToastPosition.center,
        duration: duration,
        dismissOtherToast: dismissOtherToast);

void cancelToast() => toast.dismissAllToast();

toast.ToastFuture dkShowToast(
    String msg, {
      Duration duration = const Duration(milliseconds: 2300),
      toast.ToastPosition position,
      TextStyle textStyle,
      EdgeInsetsGeometry textPadding,
      Color backgroundColor,
      double radius,
      VoidCallback onDismiss,
      TextDirection textDirection,
      bool dismissOtherToast = false,
      TextAlign textAlign,
    }) =>
    toast.showToast(
      msg,
      duration: duration,
      position: position,
      textStyle: textStyle,
      textPadding: textPadding,
      backgroundColor: backgroundColor,
      radius: radius,
      onDismiss: onDismiss,
      textDirection: textDirection,
      dismissOtherToast: dismissOtherToast,
      textAlign: textAlign,
    );

toast.ToastFuture showWidgetToast(
    Widget widget, {
      Duration duration = const Duration(milliseconds: 2300),
      VoidCallback onDismiss,
      bool dismissOtherToast,
      TextDirection textDirection,
      toast.ToastPosition position,
    }) =>
    toast.showToastWidget(widget,
        context: MyApp.myContext,
        duration: duration,
        onDismiss: onDismiss,
        dismissOtherToast: dismissOtherToast,
        textDirection: textDirection,
        position: position);

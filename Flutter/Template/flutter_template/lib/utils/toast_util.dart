import 'package:oktoast/oktoast.dart' as toast;

toast.ToastFuture showLongToast(String msg) {
  return toast.showToast(
    msg,
    duration: Duration(milliseconds: 4000),
    position: toast.ToastPosition.bottom,
    dismissOtherToast: true,
  );
}


toast.ToastFuture showShortToast(String msg) {
  return toast.showToast(
    msg,
    duration: Duration(milliseconds: 2300),
    position: toast.ToastPosition.bottom,
    dismissOtherToast: true,
  );
}
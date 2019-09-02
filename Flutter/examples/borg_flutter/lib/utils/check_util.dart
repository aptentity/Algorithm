import 'package:dio/dio.dart';
import 'package:quiver/strings.dart';

bool checkBool(bool value) => (null == value) ? false : value;

bool listNotEmpty(List list) => null != list && list.length > 0;

bool listEmpty(List list) => null == list || list.length <= 0;

bool objEmpty(dynamic obj) => null == obj;

bool objNotEmpty(dynamic obj) => null != obj;

bool mapNotEmpty(Map map) => null != map && map.isNotEmpty;

bool mapEmpty(Map map) => null == map || map.isEmpty;

bool stringBlank(String content) => isBlank(content);

bool stringEmpty(String content) => isEmpty(content);

bool stringNotEmpty(String content) => isNotEmpty(content);

Options checkDioOptions(method, options) {
  if (options == null) {
    options = new Options();
  }
  options.method = method;
  return options;
}

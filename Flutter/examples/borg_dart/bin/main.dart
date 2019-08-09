import 'package:borg_dart/borg_dart.dart' as borg_dart;

main(List<String> arguments) {
  print('Hello world: ${borg_dart.calculate()}!');

  var lists = {
    ["abc","1111","---"],
    ["bcd","2222","==="],
  };


  var t = lists.map((e){
    print(e);
    print(e[1]);
    return e;
  }).toList();

  print(t);
}

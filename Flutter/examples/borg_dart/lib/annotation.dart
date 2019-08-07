class Todo {
  final String who;
  final String what;

  const Todo(this.who, this.what);
}


@Todo('seth', 'make this do something')
void doSomething() {
  var temp = 'ttttt';
  print('do something''bbb $temp');
  var points = [0,1,2,3];
  int i=0;

  points.where((point){
    print('abc');
    return point > 0;
  }).map((point)=>print('haha'));

  var a = points.map((point){
    i++;
    print('abc');
    point = 0;
    return 0;
  });

  //print(a);

  var objects = [1, "a", 2, "b", 3];
  var ints = objects.where((e){
    print('aaaaaaa');
    return e is int;
  } ).map((e){
    print('abc');
  });
  print(ints);
  print(points);
  print('abc');


  var iterable = [1, 2, 3];
  print(iterable.toList());
  print(List.from(iterable).runtimeType);
}

class Person {
  Person(this.name);

  final String name;
  // ···
  bool operator ==(other) => other is Person && name == other.name;

  int get hashCode => name.hashCode;
}

main(List<String> arguments) {
  //doSomething();

  var person = Person('jim');
  Person person1 = null;
  if(person == person1){
    print("aaa");
  }
}

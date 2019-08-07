import 'dart:async';

void taskTest(){
  new Future((){
    print("task 0");
    new Future(()=>print('aaaaaaaa'));
  });
  scheduleMicrotask(()=> print('microtask 1'));
  new Future.microtask(()=>print('microtask 2'))
      .then((_)=>print('then 1'))
      .whenComplete(()=>print('when complete 1'))
      .then((_)=>print('then 2'))
      .catchError((_)=>print("when catch error"));
  new Future.delayed(new Duration(seconds:5),()=>print("delay 5s"));
  new Future(()=>print('task 1'));
  print('taskTest call end');
}
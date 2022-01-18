import 'package:fl02_lite/screens/ex0/ex0.dart';
import 'package:fl02_lite/screens/ex1/ex1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final exam = [const Ex0Page(),const Ex1Page()];
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                exam.length,
                (idx) => Center(
                    child: ElevatedButton(
                        onPressed: () {
                          if (idx == 0) {
                            Navigator.of(context).pushNamed('/root');
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => exam[idx]),
                            );
                          }
                        },
                        child: Text("Ex$idx"))))));
  }
}

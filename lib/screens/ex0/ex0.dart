import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Ex0Page extends StatelessWidget {
  const Ex0Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Root"),
      ),
      body: SafeArea(
          child: Center(
              child: InkWell(
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/two');
                      },
                      child: const Text("Hello, World!"))))),
    );
  }
}

class Ex0Page2 extends StatelessWidget {
  const Ex0Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Two"),
      ),
      body: SafeArea(
          child: Center(
              child: InkWell(
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/three');
                      },
                      child: const Text("Hello, World #2!"))))),
    );
  }
}

class Ex0Page3 extends StatelessWidget {
  const Ex0Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Three"),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text("Hello, World #3!")),
          Center(
            child: InkWell(
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName('/root'));
                    },
                    child: const Text("Pop to root"))),
          ),
        ],
      )),
    );
  }
}

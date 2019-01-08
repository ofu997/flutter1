import 'package:flutter/material.dart';

//renders, mounts widgets
// we need to attach widgets (building blocks, UI components)
void main() => runApp(MyApp());

// root widget, extends widget features
class MyApp extends StatelessWidget {
  @override
  Widget build( BuildContext context) {
    // return a shippable widget
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('A List')),
      ),
    );
  }
  // functions here are methods, of course
}
// dart is a modular object-oriented language, importing from packages

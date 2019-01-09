import 'package:flutter/material.dart';
import './product_manager.dart';

//renders, mounts widgets
// we need to attach widgets (building blocks, UI components)
void main() => runApp(MyApp());

// root widget, extends widget features
class MyApp extends StatelessWidget {
  // @override
  // // state object belongs to statefulwidget
  // State<StatefulWidget> createState() {
  //   return _MyAppState();
  // }


// underscored classes are private
//class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    // return a shippable widget
    return MaterialApp(
      home: Scaffold(
        // we can put UI elements here
        appBar: AppBar(
          title: Text('A List'),
        ),
        body: ProductManager()
      ),
    );
  }
  // functions here are methods, of course
}

// dart is a modular object-oriented language, importing from packages
// <Widget>: generic type array for only holding widgets

// shift alt f for format

// stateless widget: can't work, change or recall internal data, recalls build function

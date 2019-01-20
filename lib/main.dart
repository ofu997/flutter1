import 'package:flutter/material.dart';
// import './product_manager.dart';
import './pages/home.dart';

//renders, mounts widgets. we need to attach widgets (building blocks, UI components)
void main() => runApp(MyApp());

// root widget, extends widget features
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // return a shippable widget
    return MaterialApp(
      theme: ThemeData( // swatch is auto-color-schemes. Colors is package, followed by static types
        brightness: Brightness.light,
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.deepPurple
      ),
      home: HomePage()
    );
  }
  // functions here are methods, of course
}

// dart is a modular object-oriented language, importing from packages
// <Widget>: generic type array for only holding widgets

// shift alt f for format

// stateless widget: can't work, change or recall internal data, recalls build function

// main.dart. class MyApp is stateless. inserts a title and calls on ProductManager object. 
  // passes 'food tester' to ProductManager (see  "_products.add(widget.startingProduct);") 
// class Products: stateless. Returns image-text components by mapping the products array. 
// class Product_Manager: stateful. includes functional button, pass _products to class Products to change UI. 

// Lifecycle hooks . 
// Stateless Ws are used to create a widget that render things to the UI. You can pass data into them. Eg: Proudcts W 
// input External data from ProductManager -> Widget Proudcts -> Renders UI  
// Stateful: External data as input -> Widget with Internal State -> Renders UI

/* Stateless: constructor method leads to build
Stateful: Constructor, initState(), build(), setState();
*/

/*
main calls ProductManager, which usesproducts.
ProductManager setState() causes another build 
Rebuilding is efficient, checking what has changed
 */

/* MATERIAL: a design system with guides, best practices, color pairings, Customizable*/

/* to debug, import 'package:flutter/rendering.dart'; and add 
debugPaintSizeEnabled = true to main.
debugPaintBaselinesEnabled = true; underlines where leements start and end 
debugPaintPointersEnabled = true; shows tap listeners
print() variables to see what they are
in MaterialApp, add debugShowMaterialGrid: true, to show positioning/centering and distances
*/

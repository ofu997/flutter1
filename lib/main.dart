import 'package:flutter/material.dart';
import 'package:second_app/pages/product_manager_page.dart';
import 'package:second_app/pages/products.dart';
import 'package:second_app/pages/product.dart';
import 'package:second_app/pages/auth.dart';
import 'package:second_app/models/product.dart';
// import 'package:flutter/rendering.dart';//to show layout lines for paintSizeEnabled

//renders, mounts widgets. we need to attach widgets (building blocks, UI components)
void main() {
  //debugPaintSizeEnabled=true;
  runApp(MyApp());
}

// root widget, extends widget features
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  int count = 0;
  List<Product> _products = [];

  void _addsProducts(Product product) {
    setState(() {
      count++;
      _products.add(product);
      print(' addProduct() text count: ' +
          count.toString() +
          ' ' +
          DateTime.now().toIso8601String());
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  void _updateProduct(int index, Product product) {
    setState(() {
      _products[index] = product;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return a shippable widget
    return MaterialApp(
      theme: ThemeData(
        // swatch is auto-color-schemes. Colors is package, followed by static types
        brightness: Brightness.light,
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.lightBlue,
        // fontFamily: 'Oswald',
      ),
      //home: AuthPage(),
      routes: {
        '/': (BuildContext context) => AuthPage(),
        '/products': (BuildContext context) => ProductsPage(_products),
        /*'/':(BuildContext context) => ProductsPage(_products),*/
        '/admin': (BuildContext context) => ProductManagerPage(
            _addsProducts, _deleteProduct, _updateProduct, _products),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'product') {
          final int index = int.parse(pathElements[2]);
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ProductPage(
                  _products[index].title,
                  _products[index].image,
                  _products[index].description,
                  _products[index].price,
                ),
          );
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => ProductsPage(_products));
      },
    );
  }
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

/*Tips:
-If emulator won't start, go to AVD Manager, select Show On Disk, and delete cached images
Source: https://stackoverflow.com/questions/15565028/android-emulator-wont-boot-up
-Faster emulator: flutter clean, or connect to physical device. Try to keep main stateless.
*/
/*$flutter doctor --android-licenses */

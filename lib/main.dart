import 'package:flutter/material.dart';
import 'package:second_app/pages/product_manager_page.dart';
import 'package:second_app/pages/products.dart';
import 'package:second_app/pages/product.dart';
import 'package:second_app/pages/auth.dart';
import 'package:second_app/models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped-models/main.dart';
// import 'package:flutter/rendering.dart';//to show layout lines for paintSizeEnabled

//renders, mounts widgets. we need to attach widgets (building blocks, UI components)
void main() {
  //debugPaintSizeEnabled=true;debugBaselinesEnabled=true;debugPaintPointersEnabled=true;
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
  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        theme: ThemeData(
          // swatch is auto-color-schemes. Colors is package, followed by static types
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.lightBlue,
        ),
        //home: AuthPage(),
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/products': (BuildContext context) => ProductsPage(model),
          '/admin': (BuildContext context) => ProductManagerPage(model),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];
            final Product product = model.allProducts.firstWhere((Product product){
              return product.id == productId;
            });
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => ProductPage(product),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage(model)
          );
        },
      ), 
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

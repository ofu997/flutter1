// import 'package:flutter/material.dart';
// import 'package:second_app/pages/products_admin.dart';
// import 'package:second_app/pages/products.dart';
// import 'package:second_app/pages/product.dart';
// import 'package:second_app/pages/auth.dart';
// import 'package:second_app/models/product.dart';
// import 'package:scoped_model/scoped_model.dart';
// import './scoped-models/main.dart';
// import 'package:map_view/map_view.dart';
// import 'package:flutter/rendering.dart';//to show layout lines for paintSizeEnabled

import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:map_view/map_view.dart';
// import 'package:flutter/rendering.dart';

import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './scoped-models/main.dart';
import './models/product.dart';
import './pages/pathelementsempty.dart';

//renders, mounts widgets. we need to attach widgets (building blocks, UI components)
void main() {
  //debugPaintSizeEnabled=true;debugBaselinesEnabled=true;debugPaintPointersEnabled=true;
  MapView.setApiKey("AIzaSyC3nhgfXt7zasHjaV1j33_sW1QdInAIIPM");
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
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        print("setting is authenticated $isAuthenticated");
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building main page');
    // final MainModel _model = MainModel();
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        theme: ThemeData(
          // swatch is auto-color-schemes. Colors is package, followed by static types
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.lightBlue,
        ),
        //home: AuthPage(),
        routes: {
          '/': (BuildContext context) {
            return !_isAuthenticated ? AuthPage()
            : ProductsPage(_model);},
          '/admin': (BuildContext context) =>
            !_isAuthenticated ? AuthPage()
            : ProductsAdminPage(_model),
        },
        onGenerateRoute: (RouteSettings settings) {
          if (!_isAuthenticated) {
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => AuthPage(),
            );
          }
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => PathElementsEmpty(),
            );
          }
          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];
            final Product product =_model.allProducts.firstWhere((Product product) {
              return product.id == productId;
            });
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) =>
                  !_isAuthenticated ? AuthPage()
                  : ProductPage(product),
            );
          }
          //return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) {
              print("on unknown route");
            !_isAuthenticated ? AuthPage() 
            : ProductsPage(_model); }
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
Or wipe data.
-Faster emulator: flutter clean, or connect to physical device. Try to keep main stateless.
*/
//$flutter doctor --android-licenses */

// location package in 14.223

/*
https://github.com/apptreesoftware/flutter_google_map_view/issues/129

This worked for me (VS Code):

Edit \Pub\Cache\hosted\pub.dartlang.org\map_view-0.0.14\android\build.gradle. Change ext.kotlin_version under buildscript to 1.2.51.

Edit \Pub\Cache\hosted\pub.dartlang.org\map_view-0.0.14\android\src\main\kotlin\com\apptreesoftware\mapview\MapViewPlugin.kt:

Line 168: Change to val cameraDict = mapOptions!!["cameraPosition"] as Map<String, Any>
Line 171: Change to showUserLocation = mapOptions!!["showUserLocation"] as Boolean
Line 172: Change to showMyLocationButton = mapOptions!!["showMyLocationButton"] as Boolean
Line 173: Change to showCompassButton = mapOptions!!["showCompassButton"] as Boolean
Line 174: Change to hideToolbar = mapOptions!!["hideToolbar"] as Boolean
Line 175: Change to mapTitle = mapOptions!!["title"] as String
Line 177: Change to if (mapOptions!!["mapViewType"] != null) {
Line 178: Change to val mappedMapType: Int? = mapTypeMapping.get(mapOptions!!["mapViewType"]);
*/

// line 87

// ofu997@gmail.com, qwer4321
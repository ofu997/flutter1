import 'package:flutter/material.dart';
import '../product_manager.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // we can put UI elements here
      appBar: AppBar(
        title: Text('Food List'),
      ),
      body: ProductManager() // an argument here would override the one in Constructor
    );
  }
}


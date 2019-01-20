import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget{
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return  Scaffold(
        // we can put UI elements here
        appBar: AppBar(
          title: Text('Product Page'),
        ),
        body: Center(child: Text('You are on ProductPage'),) // an argument here would override the one in Constructor
      );;
    }
}
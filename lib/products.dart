import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  // final: the data is set from outside, triggers a build and replace
  final List<String> products;
  Products([this.products = const ['first']]){
    print('[Products Widget] Constructor');
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return ListView(
      children: products
        .map((element) => Card(
              child: Column(
                children: <Widget>[
                  Image.asset("assets/food.jpg"),
                  Text(element)
                ],
              ), 
            ))
        .toList(),
    );
  }
}

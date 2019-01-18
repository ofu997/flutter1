import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  // final: the data is set from outside, triggers a build and replace
  final List<String> products;
  Products([this.products = const ['first']]){
    print('[Products Widget] Constructor');
  }

  Widget _buildProductItem(BuildContext context, int index){
    return Card(
                  child: Column(
                    children: <Widget>[
                      Image.asset("assets/food.jpg"),
                      Text(products[index])
                    ],
                  ), 
                );
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return ListView.builder(
      itemBuilder: _buildProductItem,
      itemCount: products.length,// how many items will be built/displayed
      // children: products
      //   .map((element) => Card(
      //         child: Column(
      //           children: <Widget>[
      //             Image.asset("assets/food.jpg"),
      //             Text(element)
      //           ],
      //         ), 
      //       ))
      //   .toList(),
    );
  }
}

/* listViews are good for limited number of elements  
Using builder, it can also destroy items out of view*/

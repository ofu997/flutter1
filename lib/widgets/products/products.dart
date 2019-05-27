import 'package:flutter/material.dart';
import './product_card.dart';
import '../../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/main.dart';



class Products extends StatelessWidget {
  // final: the data is set from outside, triggers a build and replace
  // final List<Product> products;
  // final Function deleteProduct;

  // Products(this.products) {
  //   print('[Products Widget] Constructor');
  // }

  Widget _buildProductList(List<Product> products) {
    Widget productCard = Center(
      child: Text('No product found, please add one'),
    );
    if (products.length > 0) {
      productCard = ListView.builder(
        // conditional rendering
        itemBuilder: (BuildContext context, int index) => ProductCard(products[index]),
        itemCount: products.length, // how many items will be built/displayed
      );
    }
    return productCard; // we must return something, such as Container(), because Widget build() requires it.
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build() ' + DateTime.now().toIso8601String());
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
      return _buildProductList(model.displayedProducts);
    });
  }
}

/* listView(children: ) is good for static number of items
Using builder.(...) allows dynamic and longer lists. it can also destroy items out of view*/

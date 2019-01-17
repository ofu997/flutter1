import 'package:flutter/material.dart';

import './products.dart';
import './ProductControl.dart';

class ProductManager extends StatefulWidget {
  final String startingProduct;
  // when argument is in curly brackets we can define it more clearly
  ProductManager({this.startingProduct = 'sweets tester'}){
    print('[ProductsManager state] Constructor');
  }

  @override
  // state object belongs to statefulwidget
  State<StatefulWidget> createState() {
    print('[ProductManager state] createState()');
    return _ProductManagerState();
  }
}

class _ProductManagerState extends State<ProductManager> {
  List<String> _products = [];
  int count = 0;
  // this runs before BuildContext
  @override
  void initState(){
    print('[ProductManager state] initState()');
    super.initState();
    _products.add(widget.startingProduct);
  }
  // this works when it receives outside data
  @override 
  void didUpdateWidget(ProductManager oldWidget) {
    print('[ProductManager state] didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  void _addsProducts(String product){
    setState(
      () {
        count++;
        _products.add(product);
        print(' addProduct() text count: ' + count.toString() + ' ' + DateTime.now().toIso8601String());
      }
    );
  }

  @override
  Widget build(BuildContext context) { // context stores metadata like Themes
    print('[ProductManager state] build()');
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          child: ProductControl(_addsProducts, count) // Refs function without executing
        ),
        Expanded(child: Products(_products)),     
        // Container(height: 300.0, child: Products(_products)) // scrollable but within a container      
      ]
    );
  }
}

// setState() causes another build

// here build includes a button that adds 'advanced food tester' 
// to _products, then calls Products(_products)

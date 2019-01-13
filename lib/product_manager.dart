import 'package:flutter/material.dart';

import './products.dart';

class ProductManager extends StatefulWidget {
  final String startingProduct;

  ProductManager(this.startingProduct){
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

  @override
  Widget build(BuildContext context) {
    print('[ProductManager state] build()');
    return Column(children: [
      Container(
        margin: EdgeInsets.all(10.0),
        child: RaisedButton(
          onPressed: () {
            setState(() {
              _products.add('advanced food tester!');
            });
          },
          child: Text("Add product"),
        ),
      ),
      Products(_products)
    ]);
  }
}

// setState() causes another build


import 'package:flutter/material.dart';

class ProductControl extends StatelessWidget{
  final Function addProduct;
  ProductControl(this.addProduct);

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return RaisedButton(
        color: Theme.of(context).primaryColor,
        onPressed: () {
          addProduct('timestamp: ' + DateTime.now().toIso8601String() + '. Here is a picture of sweets');
        },
        child: Text("Add product"),
      );
    }
}

/* this passes data up 
  reference to _addsProducts was passed down

*/
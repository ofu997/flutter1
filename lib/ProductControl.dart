import 'package:flutter/material.dart';
import './product_manager.dart';

class ProductControl extends StatelessWidget{
  final Function addProduct;
  int pcCount=1;
  ProductControl(this.addProduct,this.pcCount);

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return RaisedButton(
        color: Theme.of(context).primaryColor,
        onPressed: () {
          //addProduct(pcCount.toString() + ') ' + 'timestamp: ' + DateTime.now().toIso8601String() + '. Here is a picture of sweets');
          addProduct({'one':"val one", 'image':'assets/food.jpg', 'title':'the title'});
        },
        child: Text("Add product"),
      );
    }
}

/* 
  this passes data up 
  reference to _addsProducts was passed down
*/
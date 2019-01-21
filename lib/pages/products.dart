import 'package:flutter/material.dart';
import '../product_manager.dart';

class ProductsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: Drawer(child: Column(children: <Widget>[
        AppBar(automaticallyImplyLeading: false, title: Text('Choose'),), //automaticallyImplyLeading: whether to assume AppBar actions
        ListTile(title: Text('Manage Products'), onTap: (){},)
      ],),),
      appBar: AppBar(
        title: Text('Food List'),
      ),
      body: ProductManager() // an argument here would override the one in Constructor
    );
  }
}


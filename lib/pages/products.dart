import 'package:flutter/material.dart';
import '../widgets/products/products.dart';
import '../models/product.dart';

class ProductsPage extends StatelessWidget{
  final List<Product> products;

  ProductsPage(this.products);

  Widget _buildDrawer(BuildContext context){//we pass context in callback and construct it with (BuildContext context) 
    return Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false, 
              title: Text('Choose below'),
              ), //automaticallyImplyLeading: whether to assume AppBar actions
              ListTile(
                  leading: Icon(Icons.shop),
                  title: Text('Manage Products'),
                  onTap: (){
                    Navigator.pushReplacementNamed(context, '/admin');
                  },
                )
              ],
            ),
      );
  }
  
  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: Text('Food List'),
        actions: <Widget>[

        ],
      ),
      body: Products(products), // an argument here would override the one in Constructor
    );
  }
}


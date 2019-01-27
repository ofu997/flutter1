import 'package:flutter/material.dart';
import '../product_manager.dart';
// import './product_manager_page.dart';
import '../widgets/products/products.dart';

class ProductsPage extends StatelessWidget{
  final List<Map<String, dynamic>> products;
  // final Function addProduct;
  // final Function deleteProduct;

  ProductsPage(this.products);
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: Drawer(
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
      ),
      appBar: AppBar(
        title: Text('Food List'),
        actions: <Widget>[

        ],
      ),
      body: Products(products), // an argument here would override the one in Constructor
    );
  }
}


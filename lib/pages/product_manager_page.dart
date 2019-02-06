import 'package:flutter/material.dart';
import './product_edit.dart';
import './product_list.dart';

class ProductManagerPage extends StatelessWidget {

  final Function addProduct;
  final Function deleteProduct;
  final Function updateProduct;
  final List<Map<String,dynamic>> products;

  ProductManagerPage(this.addProduct, this.deleteProduct, this.updateProduct, this.products);

  @override
  Widget build(BuildContext context) {
     
    return DefaultTabController(length: 2, child: Scaffold(
      drawer: Drawer(// menu square UI
        child: Column(
          children: <Widget>[
            AppBar(// what shows up when hamburger menu is clicked
              automaticallyImplyLeading: false,
              title: Text(''),
            ), //automaticallyImplyLeading: whether to assume AppBar actions
            ListTile(
              title: Text('All products'),
              onTap: () {// change parameters to key since it requires the page
                Navigator.pushReplacementNamed(context,'/');
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Manage products'),
        bottom: TabBar(tabs: <Widget>[
          Tab(icon: Icon(Icons.create),text: 'create product',),
          Tab(icon: Icon(Icons.list), text: 'my products',),
        ],),
      ),
      body: TabBarView(// reads TabBar events and displays content
        children: <Widget>[
          ProductEditPage(addProduct: addProduct),
          ProductListPage(products, updateProduct)
        ],
      ),
    ));
  }
}

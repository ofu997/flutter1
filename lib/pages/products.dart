import 'package:flutter/material.dart';
import '../product_manager.dart';
import './product_manager_page.dart';
class ProductsPage extends StatelessWidget{
  final List<Map<String,String>> products;
  final Function addProduct;
  final Function deleteProduct;
  ProductsPage(this.products, this.addProduct, this.deleteProduct);
  
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
      ),
      body: ProductManager(products, addProduct, deleteProduct), // an argument here would override the one in Constructor
    );
  }
}


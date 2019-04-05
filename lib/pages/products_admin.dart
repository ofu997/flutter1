import 'package:flutter/material.dart';
import './product_edit.dart';
import './product_list.dart';
import '../scoped-models/main.dart';

class ProductsAdminPage extends StatelessWidget {
  final MainModel model;

  ProductsAdminPage(this.model);

  Widget _buildSideDrawer(BuildContext context) {
    return 
    Drawer(// menu square UI
      child: Column(
        children: <Widget>[
          AppBar(// what shows up when hamburger menu is clicked
            automaticallyImplyLeading: false,
            title: Text(''),
          ), //automaticallyImplyLeading: whether to assume AppBar actions
          ListTile(
            title: Text('All products'),
            onTap: () {// change parameters to key since it requires the page
              Navigator.pushReplacementNamed(context,'/products');
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar:  AppBar(
          title: Text('Manage products'),
          bottom: TabBar(tabs: <Widget>[
            Tab(icon: Icon(Icons.create),text: 'Create product',),
            Tab(icon: Icon(Icons.list), text: 'My products',),
          ],),
        ),
        body: TabBarView(// reads TabBar events and displays content
          children: <Widget>[
          ProductEditPage(),
          ProductListPage(model)
          ],
        ),
      )
    );
  }
}
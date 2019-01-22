import 'package:flutter/material.dart';
import './products.dart';
import './product_create.dart';
import './product_list.dart';
class ProductManagerPage extends StatefulWidget {
  ProductManagerPage();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductManagerPageState();
  }
}

class _ProductManagerPageState extends State<ProductManagerPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(length: 2, child: Scaffold(
      drawer: Drawer(// menu square UI
        child: Column(
          children: <Widget>[
            AppBar(// what shows up when hamburger menu is clicked
              automaticallyImplyLeading: false,
              title: Text(''),
            ), //automaticallyImplyLeading: whether to assume AppBar actions
            ListTile(
              title: Text('all Products'),
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
          ProductCreatePage(),
          ProductListPage()
        ],
      ),
    ));
  }
}

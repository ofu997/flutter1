import 'package:flutter/material.dart';
import './products.dart';

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
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(// what shows up when hamburger menu is clicked
              automaticallyImplyLeading: false,
              title: Text('What is this?'),
            ), //automaticallyImplyLeading: whether to assume AppBar actions
            ListTile(
              title: Text('all Products'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ProductsPage()));
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('The product manager'),
      ),
      body: Center(
        child: Text('Here goes all product'),
      ),
    );
  }
}
